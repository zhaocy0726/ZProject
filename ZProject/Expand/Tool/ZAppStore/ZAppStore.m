//
//  ZAppStore.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ZAppStore.h"

#import <StoreKit/StoreKit.h> // AppStore 支付 必须引用

/// 支付异常状态
typedef NS_ENUM(NSUInteger, IAPError) {
    IAPErrorUnknow,             // 未知错误
    IAPErrorCannotMakePayments, // 不能支付
    IAPErrorNoProductInfo,      // 无法获取商品信息
    IAPErrorPayCancel,          // 取消支付
    IAPErrorPayFail,            // 支付失败
};


/** 沙盒测试环境验证 */
#define SandBox  @"https://sandbox.itunes.apple.com/verifyReceipt"
/** 正式环境验证 */
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"

static NSString * const receiptKey = @"receiptKey";

dispatch_queue_t iap_queue() {
    static dispatch_queue_t as_iap_queue;
    static dispatch_once_t onceToken_iap_queue;
    dispatch_once(&onceToken_iap_queue, ^{
        as_iap_queue = dispatch_queue_create("com.retech.iap.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return as_iap_queue;
}

static ZAppStore *manager = nil;

@interface ZAppStore () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (copy, nonatomic) NSString *productId; // 商品id
@property (copy, nonatomic) NSString *orderId; // 订单id
@property (copy, nonatomic) NSString *receipt; // 支付凭证
@property (copy, nonatomic) PayResultBlock payResult; // 支付结果

@end

@implementation ZAppStore

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [ZAppStore.alloc init];
        }
    });
    return manager;
}

/// MARK: 漏单处理
- (void)startManager
{
    dispatch_sync(iap_queue(), ^{
        [[SKPaymentQueue defaultQueue] addTransactionObserver:manager];
    });
}

/// MARK: 移除交易事件
- (void)stopManager
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    });
}

#pragma mark - 交易流程

/// MARK: 根据商品 id 购买
- (void)buyProductWithId:(NSString *)productId orderId:(NSString *)orderId result:(PayResultBlock)result
{
    // 检查是否有未完成的交易
    [self removeAllUncompleteTransaction];
    
    self.productId = productId;
    self.orderId = orderId;
    self.payResult = result;
    
    if (!self.productId || !self.productId.length) {
        [self payErrorHandler:IAPErrorNoProductInfo];
        return;
    }

    // 检查是否能够使用app内购
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductArray:@[self.productId]];
    }
    else {
        [self payErrorHandler:IAPErrorCannotMakePayments];
    }
}

/// MARK: 结束上次未完成的交易, 防止串单
- (void)removeAllUncompleteTransaction
{
    NSArray *transactions = [SKPaymentQueue defaultQueue].transactions;
    // 检测是否有未完成的交易
    if (transactions.count >= 1) {
        for (NSInteger count = transactions.count; count > 0; count--) {
            SKPaymentTransaction *transaction = [transactions objectAtIndex:count - 1];
            if (transaction.transactionState == SKPaymentTransactionStatePurchased ||
                transaction.transactionState == SKPaymentTransactionStateRestored) {
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                return;
            }
        }
    } else {
        // 没有历史订单
    }
}

/// MARK: iTunes Connect 里面提取产品列表
- (void)requestProductArray:(NSArray *)array
{
    NSLog(@"IAP: 获取对应的产品信息");
    NSSet *requestSet = [NSSet setWithArray:array];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:requestSet];
    request.delegate = self;
    [request start];
}

#pragma mark - SKProductsRequestDelegate

/// MARK: 会接收到请求响应，在此回调中，发送购买请求. 收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"IAP: 收到产品反馈消息");
    NSArray *products = response.products;
    if([products count] == 0){
        [self payErrorHandler:IAPErrorNoProductInfo];
        return;
    }
    
    NSLog(@"IAP: product ID:%@", response.invalidProductIdentifiers);
    
    SKProduct *currentProduct = nil;
    for (SKProduct *product in products) {
        NSLog(@"IAP: product description %@", [product description]);
        NSLog(@"IAP: product localizedTitle %@", [product localizedTitle]);
        NSLog(@"IAP: product localizedDescription %@", [product localizedDescription]);
        NSLog(@"IAP: product price %@", [product price]);
        NSLog(@"IAP: product productIdentifier %@", [product productIdentifier]);
        
        if ([product.productIdentifier isEqualToString:_productId]) {
            currentProduct = product;
        }
    }
    if (!currentProduct) {
        [self payErrorHandler:IAPErrorNoProductInfo];
        return;
    }
    NSLog(@"IAP: 发送购买请求");
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:currentProduct];
    // 使用苹果提供的属性，将平台订单号复制给这个属性作为参数，处理漏单问题
//    payment.applicationUsername = self.orderId;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKRequestDelegate

/// MARK: 请求商品失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    self.payResult(IAPPayStateCancel, nil, error.localizedDescription);
}

/// MARK: 请求商品结束
- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"IAP: 反馈信息结束");
}

#pragma mark - SKPaymentTransactionObserver

/// MARK: 监听购买流程变化
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    // 发送到苹果服务器验证凭证
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"IAP: 支付状态 == 完成支付");
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"IAP: 订单状态 == 恢复购买");
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"IAP: 订单状态 == 正在购买");
                break;
            default:
                NSLog(@"IAP: 订单状态 == 未确定");
                break;
        }
    }
}

#pragma mark - 交易结果处理

/// MARK: 交易失败
- (void)failTransaction:(SKPaymentTransaction *)transaction
{
    // 检查是否为取消支付
    if (transaction.error.code == SKErrorPaymentCancelled) {
        NSLog(@"IAP: 订单状态2 == 取消支付");
        [self payErrorHandler:IAPErrorPayCancel];
    } else {
        NSLog(@"IAP: 订单状态2 == 支付失败");
        [self payErrorHandler:IAPErrorPayFail];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

/// MARK: 恢复购买
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

/// MARK: 交易结束后需要验证购买，避免越狱软件模拟苹果请求达到非法购买问题或其他问题引起的数据错误导致损失
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self getReceiptAndSendToService:transaction];
}

/// MARK: 获取支付凭证
- (void)getReceiptAndSendToService:(SKPaymentTransaction *)transaction
{
    // 从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    if (!receiptData) {
        self.payResult(IAPPayStateFail, nil, @"支付异常，请联系管理检查订单状态");
        // 结束交易
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        return;
    }
    // 转化为base64字符串
    self.receipt = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    self.payResult(IAPPayStateSuccess, self.receipt, nil);
    
    // 结束交易
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

/// MARK: 通过苹果服务器审核订单
- (void)checkReceiptFromAppleService
{
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", self.receipt];//拼接请求数据
    // 再转换为字符串,来发送请求
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建请求到苹果官方进行购买验证
    NSURL *url = [NSURL URLWithString:SandBox];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
    requestM.HTTPBody = bodyData;
    requestM.HTTPMethod = @"POST";
    // 创建连接并发送同步请求
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if (dic) {
        NSLog(@"购买成功！\n%@", dic);
//        NSDictionary *dicReceipt = dic[@"receipt"];
//        NSDictionary *dicInApp = [dicReceipt[@"in_app"] firstObject];
//        NSString *productIdentifier = dicInApp[@"product_id"];//读取产品标识
//        // 如果是消耗品则记录购买数量，非消耗品则记录是否购买过
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        if ([productIdentifier isEqualToString:@"123"]) {
//            NSInteger purchasedCount = [defaults integerForKey:productIdentifier]; //已购买数量
//            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount + 1) forKey:productIdentifier];
//        }
//        else {
//            [defaults setBool:YES forKey:productIdentifier];
//        }
        //在此处对购买记录进行存储，可以存储到服务器端
        self.payResult(IAPPayStateSuccess, self.receipt, nil);
    }
    else {
        [self payErrorHandler:IAPErrorPayFail];
    }
}

/// MARK: 失败处理
- (void)payErrorHandler:(IAPError)error
{
    switch (error) {
        case IAPErrorNoProductInfo:
            self.payResult(IAPPayStateCancel, nil, @"无法获取商品信息，支付失败");
            break;
        case IAPErrorCannotMakePayments:
            self.payResult(IAPPayStateCancel, nil, @"您的设备不支持内购");
            break;
        case IAPErrorPayCancel:
            self.payResult(IAPPayStateCancel, nil, @"取消支付");
            break;
        case IAPErrorPayFail:
            self.payResult(IAPPayStateFail, nil, @"支付失败");
            break;
        default:
            break;
    }
}

//- (void)dealloc
//{
//    // 移除观察者
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
//}

@end

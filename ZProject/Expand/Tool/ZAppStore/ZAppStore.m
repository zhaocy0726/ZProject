//
//  ZAppStore.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ZAppStore.h"

#import <StoreKit/StoreKit.h> // AppStore 支付 必须引用

/** 沙盒测试环境验证 */
#define SandBox  @"https://sandbox.itunes.apple.com/verifyReceipt"
/** 正式环境验证 */
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"

@interface ZAppStore () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (strong, nonatomic) NSString *productId; // 商品id
@property (strong, nonatomic) UIViewController *viewConstroller; // 使用app内购的控制器

@end

@implementation ZAppStore

+ (instancetype)shareInstance
{
    static ZAppStore *appStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appStore = [[ZAppStore alloc] init];
    });
    return appStore;
}

#pragma mark - 根据商品 id 购买

- (void)buyProductWithId:(NSString *)productId viewController:(UIViewController *)viewController
{
    self.productId = productId;
    self.viewConstroller = viewController;
    
    if (!self.productId) {
        [_viewConstroller presentMessageTips:@"没有商品id，请联系后台管理员"];
        return;
    }
    
    // 添加观察者
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // 检查是否能够使用app内购
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductId:self.productId];
    } else {
        [_viewConstroller presentMessageTips:@"您的手机没有打开程序内付费购买"];
    }
}

// iTunes Connect里面提取产品列表
- (void)requestProductId:(NSString *)productId
{
    NSLog(@"-----请求对应的产品信息-----");
    // productId 就是苹果后台存储的商品ID，通过这个ID确定商品或消费金额
    NSSet *requestSet = [NSSet setWithArray:@[productId]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:requestSet];
    request.delegate = self;
    // 开始请求
    [request start];
    // 苹果支付很慢，需要加载动画
    [_viewConstroller showWaitTips];
}

// SKProductsRequestDelegate 会接收到请求响应，在此回调中，发送购买请求. 收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"-----收到产品反馈消息-----");
    NSArray *products = response.products;
    // 服务器没有指定id的商品
    if([products count] == 0){
        NSLog(@"-----没有商品-----");
        [self alertFailed];
        return;
    }
    
    NSLog(@"-----productID-----:%@", response.invalidProductIdentifiers);
    NSLog(@"-----产品付费数量-----:%lu",(unsigned long)[products count]);
    
    SKProduct *requestProduct = nil;
    for (SKProduct *product in products) {
        NSLog(@"-----product description-----:%@", [product description]);
        NSLog(@"-----product localizedTitle-----:%@", [product localizedTitle]);
        NSLog(@"-----product localizedDescription-----:%@", [product localizedDescription]);
        NSLog(@"-----product price-----:%@", [product price]);
        NSLog(@"-----product productIdentifier-----:%@", [product productIdentifier]);
        
        // 如果后台消费条目id与指定id相同
        if ([product.productIdentifier isEqualToString:_productId]) {
            requestProduct = product;
        }
    }
    if (!requestProduct) {
        [self alertFailed];
        return;
    }
    
    NSLog(@"-----发送购买请求-----");
    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - 收到反馈

#pragma mark 请求商品失败

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"-----反馈信息结束-----");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [self alertFailed];
    NSLog(@"-----请求商品失败-----:%@", error);
}

#pragma mark 监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    [_viewConstroller dismissTips];
    // 发送到苹果服务器验证凭证
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: // 交易完成
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:// 商品添加到列表
                //                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:  // 购买过商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:    // 购买商品失败
                [self failedTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

#pragma mark 处理交易结果
/** 交易结束后需要验证购买，避免越狱软件模拟苹果请求达到非法购买问题或其他问题引起的数据错误导致损失 */
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    // 从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptStr = [[NSString alloc] initWithData:receiptData encoding:NSUTF8StringEncoding];
    NSString *environment = [self environmentForReceipt:receiptStr];
    NSLog(@"-----完成交易调用的方法-----:%@", environment);
    
    if (!receiptData) {
        [self failedTransaction:transaction];
        return;
    }
    
    // 转化为base64字符串
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    // 再转换为字符串,来发送请求
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建请求到苹果官方进行购买验证
    NSURL *storeURL = nil;
    if ([environment isEqualToString:@"environment=Sandbox"]) {
        storeURL= [[NSURL alloc] initWithString:SandBox];
    } else {
        storeURL= [[NSURL alloc] initWithString:AppStore];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:storeURL];
    request.HTTPBody = bodyData;
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 50.0;
    
    // 创建连接并发送同步请求
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"-----验证购买过程中发生错误-----:%@",error.localizedDescription);
            [self failedTransaction:transaction];
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"-----请求成功-----:%@",dic);
        if ([dic[@"status"] intValue] == 0) {
            NSLog(@"-----购买成功-----");
            //            NSDictionary *dicReceipt = dic[@"receipt"];
            //            NSDictionary *dicInApp = [dicReceipt[@"in_app"] firstObject];
            //            NSString *productIdentifier = dicInApp[@"product_id"];//读取产品标识
            //            // 如果是消耗品则记录购买数量，非消耗品则记录是否购买过
            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //            if ([productIdentifier isEqualToString:@"123"]) {
            //                NSInteger purchasedCount = [defaults integerForKey:productIdentifier]; //已购买数量
            //                [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount + 1) forKey:productIdentifier];
            //            } else {
            //                [defaults setBool:YES forKey:productIdentifier];
            //            }
            //在此处对购买记录进行存储，可以存储到开发商的服务器端
            
            [self finishTransaction:transaction];
        }
        else {
            NSLog(@"-----购买失败，未通过验证-----");
            [self failedTransaction:transaction];
        }
    }];
    [dataTask resume];
}

- (NSString *)environmentForReceipt:(NSString *)receipt
{
    receipt = [receipt stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    receipt = [receipt stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    receipt = [receipt stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    receipt = [receipt stringByReplacingOccurrencesOfString:@" " withString:@""];
    receipt = [receipt stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSArray *array = [receipt componentsSeparatedByString:@";"];
    
    //存储收据环境的变量
    NSString *environment = array[2];
    NSLog(@"-----环境变量-----:%@", environment);
    return environment;
}

#pragma mark 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    [self alertFailed];
    [self finishTransaction:transaction];
}

/** 提示支付失败 */
- (void)alertFailed
{
    [_viewConstroller dismissTips];
    [_viewConstroller presentMessageTips:@"支付失败"];
}

#pragma mark 交易恢复处理
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"-----交易恢复处理-----");
}

#pragma mark 交易结束
- (void)finishTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    // 移除观察者
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end

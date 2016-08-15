//
//  ViewController.m
//  ChrisAliPayDemo
//
//  Created by Chris on 16/8/13.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "ViewController.h"
#import <AliPaySDK/AlipaySDK.h>
#import "Order.h"
#import "AlipayConfig.h"
#import "AlipayConfig.h"
#import "DataSigner.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)click {
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.sellerID = SellerID;
    order.outTradeNO = @"123456789"; //订单ID（由商家?自?行制定）
    order.subject = @"布加迪威龙"; //商品标题
    order.body = @"牛逼红花那个的车"; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",0.01f]; //商品价格
    order.notifyURL = @"http://www.test.com"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //【callback处理支付结果】
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

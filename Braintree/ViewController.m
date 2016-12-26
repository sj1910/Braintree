//
//  ViewController.m
//  Braintree
//
//  Created by 魏礼明 on 2016/12/20.
//  Copyright © 2016年 魏礼明. All rights reserved.
//
#import <BraintreeCore.h>
#import <BraintreeUI.h>
#import "ViewController.h"

@interface ViewController ()<BTDropInViewControllerDelegate>{
    BTDropInViewController * _dropinview;
    
}
@property (nonatomic,strong) NSString *ClientToken;
@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (nonatomic,strong) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_btn setTitle:@"DropUI" forState:(UIControlStateNormal)];
    [_btn setTintColor:[UIColor redColor]];
    [_btn addTarget:self action:@selector(next) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_btn];
}
- (void)getToken {
    //首先从后台请求拿到clientToken这个参数，创建dropUI必须的参数
    /*
    NSString *registerAgreement = [NSString stringWithFormat:@"%@%@",HOST,@"braintree/clientToken"];
    [RequestManager POSTWithUrl:registerAgreement arrKeys:@[@"customerId"] arrValues:@[[UserInfoManager getUserCustomerID]] finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //        NSLog(@"======%@",dic);
        self.ClientToken = dic[@"resdata"][@"clientToken"];
        //        NSLog(@"%@",self.ClientToken);
    } error:^(NSError *error) {
    }];
    */
}
#pragma mark - Private methods

- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    [_dropinview.view endEditing:YES];
    [self BraintreeSubmit:paymentMethodNonce.nonce];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    
    [self.navigationController popViewControllerAnimated:YES];
    [_dropinview.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayment {
    [self.navigationController popViewControllerAnimated:YES];
    [_dropinview dismissViewControllerAnimated:NO completion:nil];
}
- (void)BraintreeSubmit:(NSString *)non
{
   //这部是dropUI下面付钱按钮的方法
    /*
    NSString *insurancePlanList = [NSString stringWithFormat:@"%@%@",HOST,@"pac/buy"];
    [RequestManager POSTWithUrl:insurancePlanList arrKeys: arrValues:@[[UserInfoManager getUserID],[[NSUserDefaults standardUserDefaults] objectForKey:@"descID"],@([[NSUserDefaults standardUserDefaults] boolForKey:@"isAgree"]),non] finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([dic[@"code"] integerValue] != 0) {
            [_dropinview.view addSubview:[AleterView defaultRemiderViewWithTitle:dic[@"msg"]]];
            return ;
        }
        [UserInfoManager conserveuserPayType:dic[@"resdata"][@"payType"]];
        //        NSLog(@"$$$$$$$$$$$$%@",dic);
           } error:^(NSError *error) {
    }];*/
    
}
//尾部NEXT按钮
- (void)next{
    // 调用dropUI的方法
                self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:@""];
        //        if (IOS_VERSION_9_OR_LATER) {
        //            _dropinview = [[BTDropInViewController alloc]
        //                           initWithAPIClient:self.braintreeClient];
        //        }else{
        _dropinview = [[BTDropInViewController alloc]
                       initWithAPIClient:[[BTAPIClient alloc] initWithAuthorization:self.ClientToken]];
        //        }
        _dropinview.delegate = self;
    
        //        BTPaymentRequest *paymentRequest = [[BTPaymentRequest alloc] init];
        //        paymentRequest.summaryTitle = @"";
        //        paymentRequest.summaryDescription = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"訂單號:", nil),@"121"];
        //        paymentRequest.displayAmount = [NSString stringWithFormat:@"%@%@",@"555",@"909"];
        //        paymentRequest.callToActionText = [NSString stringWithFormat:@"%@%@ - %@",@"232",@"000000",NSLocalizedString(@"付款", nil)];
        //        paymentRequest.shouldHideCallToAction = NO;
        //
        //        _dropinview.paymentRequest = paymentRequest;
        //        _dropinview.title = NSLocalizedString(@"付款", nil);
        
        UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame=CGRectMake(0, 0, 60, 30);
        [rightButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(userDidCancelPayment) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButton1=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
        _dropinview.navigationItem.leftBarButtonItem = rightButton1;
        
        
        
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:_dropinview];
        [navigationController.navigationBar setBarTintColor:[UIColor blueColor]];
        NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
        navigationController.navigationBar.titleTextAttributes = dict;
        [self presentViewController:navigationController animated:NO completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

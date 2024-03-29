//
//  ViewController.m
//  WebFrame
//
//  Created by banggo on 3/6/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ViewController.h"
#import "UMSocial.h"
#import "DeviceNetViewController.h"
//#import "JavaScriptInterface.h"

@interface ViewController (){
    JSValue *functionJS;
    JSValue * functionQR;
    JSValue * functionShare;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    GesturePasswordController *gesturePsw=[[GesturePasswordController alloc]init];
//
////    gesturePsw.detegate=self;
////    [self.navigationController pushViewController:gesturePsw animated:YES];
//    [self presentViewController:gesturePsw animated:YES completion:^{
//
//    }];
    
    // Do any additional setup after loading the view, typically from a nib.
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://jira.hongware.cn:8084/sbmproject/index.html"]];
   
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://baobeixiu.softbanana.com/"]];
    
//      NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://169.254.29.251:3000/"]];
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.lengjing.info/WebApp/html/index.html"]];
//      NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://169.254.29.251/test/"]];
//      NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://open.koudaitong.com/oauth/authorize?client_id=2c436c071a453a55&response_type=code&state=mobilebbx&redirect_uri=http://api.softbanana.com/openApi/kdtback/1704/kdt"]];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ziyousenlin.cn/remote_web/customize/purifier/m/app.html#/index"]];
    
    
    
//    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"JSCallOC.html"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];

    
    self.webFrameView.scrollView.bounces = NO;
    [self.webFrameView loadRequest:request];

}
#pragma mark webviewdelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    


    return TRUE;
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
-(void)sharewith:(NSString *)title with:(NSString *)imageurl with:(NSString *)desc with:(NSString *)way withURL:(NSString *)url{
    NSString * waytype ;
    UMSocialDataService * socialdataservice = [UMSocialDataService defaultDataService];
    if ([way isEqualToString:@"timeline"]) {
        waytype = UMShareToWechatTimeline;
        UMSocialData * socialdata =[UMSocialData defaultData];
        socialdata.extConfig.wechatTimelineData.url = url;
        socialdataservice.socialData = socialdata;
    }
    else if ([way isEqualToString:@"weixin"]) {
        waytype = UMShareToWechatSession;
        UMSocialData * socialdata =[UMSocialData defaultData];
        socialdata.extConfig.wechatSessionData.url = url;
        socialdataservice.socialData = socialdata;
        
    }else if ([way isEqualToString:@"weibo"]){
        waytype = UMShareToSina;
    }else if ([way isEqualToString:@"kongjian"]){
        waytype = UMShareToQzone;
        UMSocialData * socialdata =[UMSocialData defaultData];
        socialdata.extConfig.qzoneData.url = url;
        socialdataservice.socialData = socialdata;
    }else if ([way isEqualToString:@"qq"]){
        waytype = UMShareToQQ;
        UMSocialData * socialdata =[UMSocialData defaultData];
        socialdata.extConfig.qqData.url = url;
        socialdataservice.socialData = socialdata;
    }

    //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
    NSString *snsName = title;
    NSString *shareText =  [desc stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *shareImage = [self getImageFromURL:imageurl];
    
    
    if (shareImage) {
        [socialdataservice postSNSWithTypes:@[waytype] content:shareText image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
                [functionShare callWithArguments:@[[NSString stringWithFormat:@"{\"result\":true}"]]];
                
            } else if(response.responseCode != UMSResponseCodeCancel) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];

                [functionShare callWithArguments:@[[NSString stringWithFormat:@"{\"result\":false}"]]];
            }
        }];
        
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
#pragma mark --open
-(void)openWebWith:(NSString *)stringURL{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
}
#pragma mark --jsExport
-(void)shareWithjson:(NSString *)string{
    NSString * contentstring = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData * data =  [contentstring dataUsingEncoding:NSUTF8StringEncoding];
    // 解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([NSJSONSerialization isValidJSONObject:contentstring]) {
        NSLog(@"--");
    }
    //调用分享
    NSString * title = [dic objectForKey:@"titlle"];
    NSString * desc = [dic objectForKey:@"describe"];
    NSString * imageurl = [dic objectForKey:@"image"];
    NSString * way = [dic objectForKey:@"way"];
    NSString * url = [dic objectForKey:@"url"];
    [self sharewith:title with:imageurl with:desc with:way withURL:url];
}
#pragma mark  设置配网设备
-(void)showNetWorkDevice{
    [self showDeviceConfigNet];
}
#pragma mark  扫描二维码
-(void)showQRScanView{
    [self showQRReader:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"JavaScriptInterface"] = self;

    //获取javascript 显示配网结果的方法
    functionJS = [self.context objectForKeyedSubscript:@"AppWIFIConfigCallBack"];

    //获取javascript 显示二维码扫描结果的方法
    functionQR = [self.context objectForKeyedSubscript:@"AppQrcodeCallBack"];
    
    //获取分享的结果方法
    functionShare = [self.context objectForKeyedSubscript:@"AppShareCallBack"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)showDeviceConfigNet{
    DeviceNetViewController * devicevct = [[DeviceNetViewController alloc] initWithNibName:@"DeviceNetViewController" bundle:nil];
    devicevct.blockResult = ^(NSString * result){
        [functionJS callWithArguments:@[result]];
        
    };
    UINavigationController * navdevice = [[UINavigationController alloc] initWithRootViewController:devicevct];
    [self presentViewController:navdevice animated:YES completion:nil];
}
// 读二维码
- (void)showQRReader:(id)sender {
    // 扫描二维码
    // 1. init ViewController
    QRReaderViewController *VC = [[QRReaderViewController alloc] init];
    
    // 2. configure ViewController
    VC.delegate = self;

    // 3. show ViewController
//    [self.navigationController pushViewController:VC animated:YES];
    [self presentViewController:VC animated:YES completion:^{
        
    }];
}
#pragma mark - QRReaderViewControllerDelegate

- (void)didFinishedReadingQR:(NSString *)string {
    NSLog(@"result string: %@", string);
    
    [functionQR callWithArguments:@[string]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

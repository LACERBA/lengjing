//
//  DeviceNetViewController.m
//  WebFrame
//
//  Created by muomeng on 11/14/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "DeviceNetViewController.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface DeviceNetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ssid;
@property (weak, nonatomic) IBOutlet UITextField *pswd;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@end

@implementation DeviceNetViewController
{
    HFSmartLink * smtlk;
    BOOL isconnecting;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    smtlk = [HFSmartLink shareInstence];
    smtlk.isConfigOneDevice = true;
    isconnecting = false;
    self.progress.progress = 0.0;
    self.switcher.on = false;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
    
}
#pragma mark  关闭页面
-(void)closeView{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [self showWifiSsid];
    self.pswd.text = [self getspwdByssid:self.ssid.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [smtlk closeWithBlock:^(NSString *closeMsg, BOOL isOK) {
        if(!isOK)
            NSLog(@"%@",closeMsg);
    }];
}
- (IBAction)connectPress:(id)sender {
    NSString * pswdStr = self.pswd.text;
    self.progress.progress = 0.0;
    if(!isconnecting){
        [smtlk startWithKey:pswdStr processblock:^(NSInteger process) {
            self.progress.progress = process/18.0;
        } successBlock:^(HFSmartLinkDeviceInfo *dev) {
//            [self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
            [self showAlertWithMsg:[NSString stringWithFormat:@"{\"result\":true,\"mac\":\"%@\",\"ip\":\"%@\"}",dev.mac,dev.ip] title:nil];
        } failBlock:^(NSString *failmsg) {
//            [self  showAlertWithMsg:failmsg title:@"error"];
            [self showAlertWithMsg:[NSString stringWithFormat:@"{\"result\":false}"] title:nil];
        } endBlock:^(NSDictionary *deviceDic) {
            isconnecting  = false;
            [self.connectBtn setTitle:@"connect" forState:UIControlStateNormal];
        }];
        isconnecting = true;
        [self.connectBtn setTitle:@"connecting" forState:UIControlStateNormal];
    }else{
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            if(isOk){
                isconnecting  = false;
                [self.connectBtn setTitle:@"connect" forState:UIControlStateNormal];
//                [self showAlertWithMsg:stopMsg title:@"OK"];
            }else{
//                [self showAlertWithMsg:stopMsg title:@"error"];
            }
        }];
    }
}
- (IBAction)swichPressed:(id)sender {
    if(self.switcher.on){
        smtlk.isConfigOneDevice = true;
    }else{
        smtlk.isConfigOneDevice = false;
    }
}

-(void)showAlertWithMsg:(NSString *)msg
                  title:(NSString*)title{
    
    
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
//    [alert show];
    [self dismissViewControllerAnimated:YES completion:^{
        _blockResult(msg);
    }];
    
}

- (void)showWifiSsid
{
    BOOL wifiOK= FALSE;
    NSDictionary *ifs;
    NSString *ssid;
    UIAlertView *alert;
    if (!wifiOK)
    {
        ifs = [self fetchSSIDInfo];
        ssid = [ifs objectForKey:@"SSID"];
        if (ssid!= nil)
        {
            wifiOK= TRUE;
            self.ssid.text = ssid;
        }
        else
        {
            alert= [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"请连接Wi-Fi"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            alert.delegate=self;
            [alert show];
        }
    }
}

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

-(void)savePswd{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def setObject:self.pswd.text forKey:self.ssid.text];
}
-(NSString *)getspwdByssid:(NSString * )mssid{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:mssid];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

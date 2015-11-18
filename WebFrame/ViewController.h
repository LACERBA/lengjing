//
//  ViewController.h
//  WebFrame
//
//  Created by banggo on 3/6/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GesturePasswordController.h"
#import "QRReaderViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptInterfaceExport <JSExport>
-(void)shareWithjson:(NSString*)string;
-(void)openWebWith:(NSString *)stringURL;
-(void)showNetWorkDevice;
-(void)showQRScanView;
@end

@interface ViewController : UIViewController<UIWebViewDelegate,JavaScriptInterfaceExport,QRReaderViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webFrameView;
@property (strong, nonatomic) JSContext *context;

@end


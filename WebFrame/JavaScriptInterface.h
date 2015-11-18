//
//  JavaScriptInterface.h
//  WebFrame
//
//  Created by 张海博 on 5/13/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptInterfaceExport <JSExport>
-(void)shareWithjson:(NSString*)string;
-(void)openWebWith:(NSString *)stringURL;
-(void)showNetWorkDevice;
-(void)showQRScanView;
@end
@interface JavaScriptInterface : NSObject<JavaScriptInterfaceExport>


@end

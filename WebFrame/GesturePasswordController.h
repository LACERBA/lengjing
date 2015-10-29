//
//  ZJWViewController.h
//  键盘锁Demo
//
//  Created by zhangjiwen on 14-9-30.
//  Copyright (c) 2014年 concise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAmeview.h"
@interface GesturePasswordController : UIViewController<PasswordDelegate>
@property (nonatomic,assign) BOOL isPasswordExist;
@end

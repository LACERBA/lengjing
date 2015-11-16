//
//  DeviceNetViewController.h
//  WebFrame
//
//  Created by muomeng on 11/14/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BlockResult)(NSString * result);
@interface DeviceNetViewController : UIViewController

@property(nonatomic, strong)BlockResult blockResult;
@end

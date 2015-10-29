//
//  NAmeview.h
//  ADDD
//
//  Created by 206 on 13-7-9.
//  Copyright (c) 2013年 吴丁虎. All rights reserved.
//

#import <UIKit/UIKit.h>

//密码视图协议
@protocol PasswordDelegate <NSObject>

-(void)theResoutOfInput:(NSString *)alertSender withResult:(NSString *)resultSender;

@end





typedef enum ePasswordSate {
    ePasswordUnset,//未设置
    ePasswordExist//密码设置成功
}ePasswordSate;
@interface NAmeview : UIView<UIAlertViewDelegate>{
    ePasswordSate state;
    NSMutableArray *mutalearray;
    NSMutableArray *mutag;
    CGPoint curentpoint;
    UITextField *resulttext;
    NSString *resultStr;
    NSString *str;          
    NSString *tempStr;      //创建和重置密码时第一次绘制结果
    NSString *tempStr1;     //创建和重置密码时第二次绘制结果
    BOOL isReset;           //创建和重置密码时是否已经绘制一次标示
    NSMutableArray *getArray;
    BOOL isOver;
}
@property (nonatomic,weak) id<PasswordDelegate> delegate;
//重置密码
-(void)resetPassword;
@end

//
//  ZJWViewController.m
//  键盘锁Demo
//
//  Created by zhangjiwen on 14-9-30.
//  Copyright (c) 2014年 concise. All rights reserved.
//

#import "GesturePasswordController.h"
#import "Tool.h"
@interface GesturePasswordController ()
{
    NAmeview *a;
    UILabel *alertLabel;                        //提示标签
    UILabel *resultLabel;                       //结果标签
    UIButton *forgetButton;                     //忘记密码按钮
    NSMutableArray *selectedArray;
    BOOL _isError;                              //两次输入结果是否一致
    BOOL _isPasswordError;                      //密码输错
}
@end

@implementation GesturePasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    _isError = NO;
    
    selectedArray = [[NSMutableArray alloc]init];
    [self createAlertLabel];
    
    [self createResetButton];
    
    a = [[NAmeview alloc]initWithFrame:CGRectMake(0, 200 , self.view.frame.size.width, self.view.frame.size.width)];
    a.delegate = self;
    [self.view addSubview:a];

//    resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 84, 200, 44)];
//    resultLabel.backgroundColor = [UIColor lightGrayColor];
//    resultLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:resultLabel];
    
//    检测是否已经有密码存在
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"payPassword"]) {
        alertLabel.text = @"请创建一个手势密码";
        [self createSmallView:selectedArray];
    }else{
        alertLabel.text = @"请输入手势密码";
        NSLog(@"zhang");
        [self createForgetButton];
    }
    self.view.backgroundColor = [UIColor whiteColor];
}
//  提示标签
-(void)createAlertLabel{
    alertLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)*0.5 , 114, 300, 44)];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.textColor = _isPasswordError ? [UIColor redColor] : [Tool colorWithHexString:@"#726c71"];
    alertLabel.font = [UIFont systemFontOfSize:22];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertLabel];
}
//    重置按钮
-(void)createResetButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(220, 40, 90, 44);
    [button setTitle:@"重置密码" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGrayColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
//重置按钮的点击事件
-(void)action{
    [a resetPassword];
}
//忘记密码按钮
-(void)createForgetButton{
    forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(5,self.view.bounds.size.height-108, 100, 44);
    [forgetButton setTitle:@"忘记手势密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetButton addTarget:self action:@selector(forgetButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
}
#warning mark ----添加忘记密码的点击事件
//忘记密码按钮的点击事件
-(void)forgetButtonAction{
    NSLog(@"忘记手势密码");
}
// 用于记录第一次设置的手势密码的小视图
-(void)createSmallView:(NSMutableArray *) array{
    for (int i=0; i<9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(143 + (i % 3) * (5 + 8), 40 + (i / 3) * (8 + 5), 8, 8);
        [button setBackgroundImage:[UIImage imageNamed:@"littledot_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"dot-selected"] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;     //用户交互
        button.alpha = 0.9;
        button.tag = i+10000;
        if (_isError) {
            button.selected = NO;
        }else{
            [self setSelectes:button with:array];
        }
        [self.view addSubview:button];
    }
}

-(void)setSelectes:(UIButton *)button with:(NSMutableArray *)array{
    if (array.count != 0) {
        for (int j = 0; j < array.count; j++) {
            if ((button.tag - 9999) == [array[j] integerValue]) {
                button.selected = YES;
            }
        }
    }
}
#pragma mark PasswordDelegate
-(void)theResoutOfInput:(NSString *)alertSender withResult:(NSString *)resultSender
{
    alertLabel.text = alertSender;
    if ([alertSender isEqualToString:@"两次不一致,请重新输入"]){
        _isError = YES;
    }else if ([alertSender hasPrefix:@"密码错误"]){
        _isPasswordError = YES;
    }else{
        _isError = NO;
        _isPasswordError = NO;
    }
    resultLabel.text = resultSender;
    [self setButtonsSelectedState:resultSender];
}
//将返回过来的手势密码字符串分解成数组保存
-(void)setButtonsSelectedState:sender{
    NSInteger selectedNumber = [sender integerValue];
    while (selectedNumber) {
        int temp = selectedNumber % 10 ;
        selectedNumber = selectedNumber / 10;
        [selectedArray addObject:[NSString stringWithFormat:@"%d",temp]];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"payPassword"]){
       [self createSmallView:selectedArray];
    }
    [selectedArray removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

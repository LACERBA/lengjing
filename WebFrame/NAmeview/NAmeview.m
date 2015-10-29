//
//  NAmeview.m
//  ADDD
//
//  Created by 206 on 13-7-9.
//  Copyright (c) 2013年 吴丁虎. All rights reserved.

#import "NAmeview.h"
#import "NSString+MD5Addition.h"
#import "Tool.h"

@implementation NAmeview
{
    float buttonsWidth;             //九宫格中按钮的宽度
    float buttonsHight;             //九宫格中按钮的高度
    float buttonToEdgeDistance;      //按钮到边界的距离
    float buttonToButtonDistancce;   //按钮之间的距离
    BOOL isTimeOVer;                //计时是否已到
    NSTimer *timer;                 //定时器
    NSInteger count;                //定时时间
    BOOL isPasswordError;           //输入的密码是否正确
    NSInteger errorCount;           //允许密码输错的次数
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%@",NSHomeDirectory());
//        初始化字段
        count = 0;
        errorCount = 5;
        isPasswordError = YES;
        mutalearray = [[NSMutableArray alloc]init];
        mutag = [[NSMutableArray alloc]init ];
        tempStr = [[NSString alloc]init];
        tempStr1 = [[NSString alloc]init];
        
        buttonsWidth = 5.0/32*frame.size.width;
        buttonsHight = buttonsWidth;
        buttonToEdgeDistance = 47.0/320*frame.size.width;
        buttonToButtonDistancce = 38.0/320*frame.size.width;

        resulttext = [[UITextField alloc]init];
        state = [self achievePasswordState];
        self.backgroundColor = [UIColor clearColor];
        isReset = NO;
        [self createPasswordView];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(timerRepeat) userInfo:nil repeats:YES];
        [timer setFireDate:[NSDate distantFuture]];
    }
    return self;
}
//获取state的状态
-(ePasswordSate)achievePasswordState{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"payPassword"]) {
        return ePasswordUnset;
    }else{
        return ePasswordExist;
    }
}
//创建九宫格密码视图
-(void)createPasswordView
{
    for (int i=0; i<9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonToEdgeDistance + (i % 3) * (buttonToButtonDistancce + buttonsWidth), (i / 3) * (buttonsHight + buttonToButtonDistancce), buttonsWidth, buttonsHight);

        NSLog(@"%@", NSStringFromCGRect(button.frame));
        [button setBackgroundImage:[UIImage imageNamed:@"dot-normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"dot-selected"] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;//用户交互
        button.alpha = 0.9;
        button.tag = i+10000;
        [self addSubview:button];
        [mutalearray addObject:button];
    }
}
//密码重置
-(void)resetPassword{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"payPassword"];
    state = ePasswordUnset;
    isReset = NO;
    errorCount = 5;
    [self callBack:@"请重置密码" withResult:nil];
}
//回调
-(void)callBack:(NSString *) string  withResult:(NSString *)resultString  {
    if ([_delegate respondsToSelector:@selector(theResoutOfInput:withResult:)]) {
        [_delegate theResoutOfInput:string withResult:resultString];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (int i = 0; i < mutalearray.count; i++) {
        UIButton *button = mutalearray[i];
        button.selected = NO;
    }
    CGPoint begainpoint=[[touches anyObject]locationInView:self];
    for (UIButton *thisbutton in mutalearray)
    {
    CGFloat xdiff =begainpoint.x - thisbutton.center.x;
    CGFloat ydiff=begainpoint.y - thisbutton.center.y;
    
        if (fabsf(xdiff) < buttonsWidth/2 && fabsf (ydiff) < buttonsHight/2 && fabsf(xdiff) < 0 && fabsf (ydiff) < 0)
        {
            if (!thisbutton.selected)
            {
                thisbutton.selected = YES;
                [mutag  addObject:thisbutton];
            }
        }
    }
    [self setNeedsDisplay];
    [self addstring];
    isOver = NO;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point= [[touches anyObject]locationInView:self];
    curentpoint = point;
    for (UIButton *thisbutton in mutalearray)
    {
        CGFloat xdiff =point.x-thisbutton.center.x;
        CGFloat ydiff=point.y - thisbutton.center.y;
        //按钮点击成功
        if (fabsf(xdiff) < buttonsWidth/2 && fabsf (ydiff) < buttonsHight/2)
        {
            resulttext.text = [NSString stringWithFormat:@"%ld",(long)thisbutton.tag-9999];
            resulttext.text = [resulttext.text stringByAppendingString:resulttext.text];
            if (!thisbutton.selected)
            {
                thisbutton.selected = YES;
                [mutag  addObject:thisbutton];
            }
        }
    }
    [self setNeedsDisplay];
    [self addstring];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self waitSomeTime];
    if (getArray.count == 0) {
        isOver = NO;
    }else{
        isOver = YES;
    }
    [timer setFireDate:[NSDate date]];
}
//定时器执行方法
-(void)timerRepeat{
    count ++;
    if (count % 20 == 0) {
        isTimeOVer = YES;
        [self setNeedsDisplay];
        [timer setFireDate:[NSDate distantFuture]];
    }
}
- (void)waitSomeTime
{
    if (([resulttext.text length] == 0 ) || ([resulttext.text length] < 4)) {
        isPasswordError = NO;
        [self callBack:@"密码不能少于四位" withResult:resulttext.text];
    }
    else if (state == ePasswordUnset){
        if (!isReset) {
            tempStr = resulttext.text;
            isReset = YES;
            [self callBack:@"请再次确认密码" withResult:resulttext.text];
        }else{
            tempStr1 = resulttext.text;
            if ([tempStr isEqualToString:tempStr1]) {
                [self callBack:@"创建密码成功" withResult:resulttext.text];
                tempStr = [tempStr stringFromMD5];
                [[NSUserDefaults standardUserDefaults]setObject:tempStr forKey:@"payPassword"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                state = ePasswordExist;
//添加创建密码成功后添加的视图
                
            }else{
                [self callBack:@"两次不一致,请重新输入" withResult:resulttext.text];
                isPasswordError = NO;
                isReset = NO;
            }
        }
    }
    else if (state == ePasswordExist){
        tempStr = [resulttext.text stringFromMD5];

        tempStr1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"payPassword"];
        if ([tempStr1 isEqualToString:tempStr]) {
            [self callBack:@"输入密码正确" withResult:resulttext.text];
        }
        else{
            isPasswordError = NO;
            errorCount -- ;
            NSString *errorStr = [NSString stringWithFormat:@"密码错误,还可以再输入%d次",errorCount];
            [self callBack:errorStr withResult:resulttext.text];
            if (errorCount == 0) {
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"你已连续输错手势,手势密码已关闭，请重新设置密码。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertV.tag = 100;
                [alertV show];
            }
        }
    }
    getArray = [[NSMutableArray alloc]init];
    getArray = [mutag mutableCopy];
    [mutag removeAllObjects];
    [self setNeedsDisplay];
}
//绘图
-(void)drawRect:(CGRect)rect
{
    CGContextRef contextref = UIGraphicsGetCurrentContext();
    if (isOver && !isTimeOVer) {
        [self isOverDraw:contextref];
    }else if(isTimeOVer){
        for (UIButton *thisButton in mutalearray){
            [thisButton setSelected:NO];
        }
        isTimeOVer = NO;
        isPasswordError = YES;
        [self setButtonSelectedImage:isPasswordError];
    }
    else{
        [self startDraw:contextref];
    }
    CGContextStrokePath(contextref);
}
//设置正确和错误两种状态下,按钮被选中的图片
-(void)setButtonSelectedImage:(BOOL)sender{
    for (int i = 0; i < getArray.count; i++) {
        UIButton *btn = getArray[i];
        sender ? [btn setBackgroundImage:[UIImage imageNamed:@"dot-selected"] forState:UIControlStateSelected] : [btn setBackgroundImage:[UIImage imageNamed:@"dot-wrong"] forState:UIControlStateSelected];
    }
}
//绘图结束,根据结果正确与否,来用相应的颜色重新绘制
-(void)isOverDraw:(CGContextRef) contextref{
    if (!isPasswordError) {
        [self setButtonSelectedImage:isPasswordError];
    }
        for (int i = 0; i < getArray.count - 1; i++) {
        UIButton *getlast = [getArray objectAtIndex:i];
        UIButton *getnext = [getArray objectAtIndex:i+1];
        isPasswordError ? [[Tool colorWithHexString:@"#488bca"] set] : [[UIColor redColor]set];
        CGContextSetLineWidth(contextref, 2);
        CGContextSetLineJoin(contextref, kCGLineJoinRound);
        CGContextSetLineCap(contextref, kCGLineCapRound);
        CGContextMoveToPoint(contextref, getlast.center.x, getlast.center.y);
        CGContextAddLineToPoint(contextref, getnext.center.x, getnext.center.y);
    }
}

-(void)startDraw:(CGContextRef) contextref{
    UIButton *buttonn;
    UIButton *buttonn1;
    if (mutag.count != 0) {
        buttonn = mutag[0];
        [[Tool colorWithHexString:@"#488bca"] set];
        CGContextSetLineWidth(contextref, 2);
        CGContextSetLineJoin(contextref, kCGLineJoinRound);
        CGContextSetLineCap(contextref, kCGLineCapRound);
        CGContextMoveToPoint(contextref, buttonn.center.x, buttonn.center.y);
        for (int t = 1; t < mutag.count; t++) {
            buttonn1 = mutag[t];
            CGContextAddLineToPoint(contextref, buttonn1.center.x, buttonn1.center.y);
        }
        CGContextAddLineToPoint(contextref, curentpoint.x, curentpoint.y);
    }
}
//记录走过的路线
-(void)addstring
{
    UIButton *strbutton;
    NSString *string=@"";
    
    for (int t=0; t<mutag.count; t++) {
        strbutton = mutag[t];
         string= [string stringByAppendingFormat:@"%ld",(long)(strbutton.tag-9999)];
    }
    resulttext.text = string;
}
#pragma mark ---UIAlertViewDelegate
#warning mark --- 添加点击确定按钮后弹出来的视图
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100 && buttonIndex == 0) {
        NSLog(@"你已连续输错手势,手势密码已关闭,请重新设置密码");
    }
}
@end

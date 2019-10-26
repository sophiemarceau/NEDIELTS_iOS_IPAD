//
//  Sys_SuggestView.m
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "Sys_SuggestView.h"

#define kSugTopViewHegiht  75
#define kTextShow @"有什么想说的,尽管来咆哮"
@interface Sys_SuggestView ()<UITextViewDelegate>

@property (nonatomic,strong)  UIView *topView;  //顶部视图
@property (nonatomic,strong)  UILabel *titleLabel;  //标题
@property (nonatomic,strong)  UIButton *suggestButton; //建议按钮
@property (nonatomic,strong)  UIView *bodyView; //内容视图背景
@property (nonatomic,strong)  UITextView *suggestTextView; //输入框、
@property (nonatomic,strong)  UILabel *uilabel; //预显示文字

@property (nonatomic,strong) UIControl *maskControlView; //控制收起搜索框搜索框

@end

@implementation Sys_SuggestView
@synthesize topView,titleLabel,suggestButton,bodyView,suggestTextView,uilabel;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    //1.创建头部视图
    [self _initTopView];
    //2.设置文本框
    [self _initBodyView];
}
#pragma mark - 初始化视图
- (void)_initTopView
{
    topView = [[UIView alloc]initWithFrame:CGRectZero];
    topView.backgroundColor = [UIColor whiteColor];
    
    //标题
    titleLabel = [ZCControl createLabelWithFrame:CGRectZero Font:20.0 Text:@"意见反馈"];
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = TABBAR_BACKGROUND_SELECTED;
    [topView addSubview:titleLabel];
    
    //发送按钮
    suggestButton = [ZCControl createButtonWithFrame:CGRectZero ImageName:@"btn1_blank.png" Target:self Action:@selector(suggestAction:) Title:@"发送"];
    [suggestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topView addSubview:suggestButton];
    
    [self addSubview:topView];
}

- (void)_initBodyView
{
    bodyView = [[UIView alloc]initWithFrame:CGRectZero];
    bodyView.backgroundColor = [UIColor clearColor];
    
    //文本框设置
    suggestTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    suggestTextView.textColor = [UIColor blackColor];
    
    suggestTextView.font = [UIFont fontWithName:@"Arial" size:18.0];
    suggestTextView.delegate = self; //代理
//    textView.returnKeyType = UIReturnKeySend;
//    textView.keyboardType
    suggestTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [bodyView addSubview:suggestTextView];
    
    //创建文本框预显示文字
    uilabel = [ZCControl createLabelWithFrame:CGRectZero Font:18.0 Text:kTextShow];
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.backgroundColor = [UIColor clearColor];
    uilabel.textColor = [UIColor lightGrayColor];
    [suggestTextView addSubview:uilabel];
    [self addSubview:bodyView];
}

#pragma mark - 页面布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    topView.frame = CGRectMake(0, 0, self.width, kSugTopViewHegiht);
    titleLabel.frame = CGRectMake((self.width-100)/2, (kSugTopViewHegiht-40)/2, 100, 40);
    suggestButton.frame = CGRectMake(self.width-85, (kSugTopViewHegiht-35)/2, 65, 35);

    bodyView.frame = CGRectMake(10, kSugTopViewHegiht+10, self.width-20, kScreenHeight-kSugTopViewHegiht-20);
    suggestTextView.frame = bodyView.bounds;
    uilabel.frame =CGRectMake(5,0, 400, 30);
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    [self _initMask:textView];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self maskControlView:_maskControlView];
    return YES;
}
//添加预显示文字
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        uilabel.text = kTextShow;
    }else{
        uilabel.text = @"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=1000)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
    return YES;
}

#pragma mark - 实现点击键盘以外都收起键盘
- (void)_initMask:(UITextView *)textView
{
    //创建点击视图
    if (_maskControlView == nil) {
        _maskControlView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_maskControlView addTarget:self action:@selector(maskControlView:) forControlEvents:UIControlEventTouchUpInside];
        _maskControlView.backgroundColor = [UIColor clearColor];
        
        [self.viewController.view insertSubview:_maskControlView belowSubview:textView];
    }
}
//隐藏alert
- (void)maskControlView:(UIControl *)maskView
{
    [_maskControlView removeFromSuperview];
    _maskControlView = nil;
    
    [suggestTextView resignFirstResponder];
    
}


#pragma mark - 发送意见反馈按钮
- (void)suggestAction:(UIButton *)button
{
    NDLog(@"%@",suggestTextView.text);
    NSString *content = suggestTextView.text.length > 0 ? suggestTextView.text : @"";
    if ([content isEqualToString:@""]) {
        [[RusultManage shareRusultManage]tipAlert:@"请输入意见反馈内容" viewController:self.viewController.parentViewController.parentViewController];
        return;
    }
    [[RusultManage shareRusultManage]sysSuggestController:self.viewController contentText:content SuccessData:^(NSDictionary *result) {
        suggestTextView.text = @"";
        uilabel.text = kTextShow;
        [[RusultManage shareRusultManage]tipAlert:@"反馈成功，谢谢您反馈的建议和意见~~" viewController:self.viewController.parentViewController.parentViewController];
    }];
}


@end

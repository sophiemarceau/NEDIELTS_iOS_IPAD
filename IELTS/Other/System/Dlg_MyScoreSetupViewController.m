//
//  Dlg_MyScoreSetupViewController.m
//  IELTS
//
//  Created by melp on 14/12/2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "Dlg_MyScoreSetupViewController.h"
#import "BaseFillBlankView.h"


@interface Dlg_MyScoreSetupViewController ()<UITextFieldDelegate,BaseFillBlankViewDelegate>


@property (nonatomic,strong)UILabel *submitLabel;
@property (nonatomic,strong)NSArray *array;

@end

@implementation Dlg_MyScoreSetupViewController
@synthesize submitLabel,array;

- (void)viewDidLoad {
    [super viewDidLoad];
//    [ZCControl presentNavController:self Width:480 Height:320];

    //保存数据
//    static float listens = 5.0;
//    static float speaks = 5.0;
//    static float reads = 5.0;
//    static float writes = 5.0;
//    static float subValues = 0.0;
    
    self.tipLabel.textColor = TABBAR_BACKGROUND_SELECTED;
    self.tipLabel.hidden = YES;
    
    array = @[@"听力",@"阅读",@"写作",@"口语"];
    self.view.backgroundColor = [UIColor whiteColor];
    for (int i= 0; i<array.count; i++) {
        
        UILabel *listen  = [[UILabel alloc]initWithFrame:CGRectMake(20+i*95, 105, 50, 30)];
        listen.text =array[i];
        [self.view addSubview:listen];
        
        BaseFillBlankView *fillBlank = [[BaseFillBlankView alloc]initWithFrame:CGRectMake(60+i*95, 40, 90, 150)];
        fillBlank.fillBlankWidth = 50;
        fillBlank.delegate = self;
        fillBlank.fillBlankName =array[i];
        switch (i) {
            case 0:
            {
              fillBlank.defaultValue = self.listens;
            }
                break;
            case 1:
            {
               fillBlank.defaultValue = self.reads;
            }
                break;

            case 2:
            {
               fillBlank.defaultValue = self.writes;
            }
                break;
            case 3:
            {
                fillBlank.defaultValue = self.speaks;
            }
                break;

            default:
                break;
        }
        
        fillBlank.valueType = ValueTypeNum;
        [self.view addSubview:fillBlank];
    }
    
    submitLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+4*95, 105, 100, 30)];
    submitLabel.text = [NSString stringWithFormat:@"总分: %.1f",_subValues];
    [self.view addSubview:submitLabel];

}

#pragma mark -BaseFillBlankViewDelegate
- (void)selectNum:(NSString *)value selectFillBlank:(NSString *)fillBlank
{
    if ([array containsObject:fillBlank]) {
        NSUInteger integet = [array indexOfObject:fillBlank];
        switch (integet) {
            case 0:
            {
                NDLog(@"听力");
                self.listens = [value floatValue];
            }
                break;
            case 1:
            {
                NDLog(@"阅读");
                self.reads = [value floatValue];
            }
                break;
                
            case 2:
            {
                NDLog(@"写作");
                self.writes = [value floatValue];
            }
                break;
            case 3:
            {
                NDLog(@"口语");
                self.speaks = [value floatValue];
            }
                break;

            default:
                break;
        }
    }
    _subValues =_listens+_speaks+_reads+_writes;
    if (_subValues != 0.0) {
        float totalValue = _subValues/4.0f;
        NSInteger totalInt = _subValues/4.0f;
        
        float totalFlaot = totalValue -(float)totalInt;
        if (totalFlaot>=0.25 && totalFlaot<0.75) {
            totalFlaot = 0.5;
        }else if (totalFlaot>=0.75)
        {
            totalFlaot = 1.0;
        }else if (totalFlaot<0.25)
        {
            totalFlaot = 0.0;
        }
        float value = totalFlaot+(float)totalInt;
        submitLabel.text = [NSString stringWithFormat:@"总分: %.1f",value];
    }else
    {
        submitLabel.text = [NSString stringWithFormat:@"总分: 0.0"];
    }
    
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbersPeriod] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    switch (textField.tag) {
        case 10:
        {
            if ([string isEqualToString:@""] && range.length > 0) {  //输入是空，则删除一位
                _textString1 = [_textString1 substringToIndex:_textString1.length-1];
            }else
            {
                BOOL basic = [string isEqualToString:filtered];
                if (basic) {
                    _textString1 = [NSString stringWithFormat:@"%@%@",_textString1,string];
                    if ([_textString1 floatValue]<=9.0 && [_textString1 floatValue] >= 0) {  //在0~9之类
                        if (_textString1.length > 3) {
                            _textString1 = [_textString1 substringToIndex:_textString1.length-1];
                            return NO;
                        }
                    }else //
                    {
                        _textString1 = [_textString1 substringToIndex:_textString1.length-1];
                        return NO;
                    }
                }
               return basic;
            }
        }
            break;
        case 11:
        {
            if ([string isEqualToString:@""] && range.length > 0) {  //输入是空，则删除一位
                _textString2 = [_textString2 substringToIndex:_textString2.length-1];
            }else
            {
                BOOL basic = [string isEqualToString:filtered];
                if (basic) {
                    _textString2 = [NSString stringWithFormat:@"%@%@",_textString2,string];
                    if ([_textString2 floatValue]<=9.0 && [_textString2 floatValue] >= 0) {  //在0~9之类
                        if (_textString2.length > 3) {
                            _textString2 = [_textString2 substringToIndex:_textString2.length-1];
                            return NO;
                        }
                        
                    }else //
                    {
                        _textString2 = [_textString2 substringToIndex:_textString2.length-1];
                        return NO;
                    }
                }
                return basic;
            }
        }
            break;
        case 12:
        {
            
            if ([string isEqualToString:@""] && range.length > 0) {  //输入是空，则删除一位
                _textString3 = [_textString3 substringToIndex:_textString3.length-1];
            }else
            {
                BOOL basic = [string isEqualToString:filtered];
                if (basic) {
                    _textString3 = [NSString stringWithFormat:@"%@%@",_textString3,string];
                    if ([_textString3 floatValue]<=9.0 && [_textString3 floatValue] >= 0) {  //在0~9之类
                        if (_textString3.length > 3) {
                            _textString3 = [_textString3 substringToIndex:_textString3.length-1];
                            return NO;
                        }
                    }else //
                    {
                        _textString3 = [_textString3 substringToIndex:_textString3.length-1];
                        return NO;
                    }
                }
                return basic;
            }
        }
            break;
        case 13:
        {
            if ([string isEqualToString:@""] && range.length > 0) {  //输入是空，则删除一位
                _textString4 = [_textString4 substringToIndex:_textString4.length-1];
            }else
            {
                BOOL basic = [string isEqualToString:filtered];
                if (basic) {
                    _textString4 = [NSString stringWithFormat:@"%@%@",_textString4,string];
                    if ([_textString4 floatValue]<=9.0 && [_textString4 floatValue] >= 0) {  //在0~9之类
                        if (_textString4.length > 3) {
                            _textString4 = [_textString4 substringToIndex:_textString4.length-1];
                            return NO;
                        }
                    }else //
                    {
                        _textString4 = [_textString4 substringToIndex:_textString4.length-1];
                        return NO;
                    }
                }
                return basic;
            }
            
        }
            break;
            
        default:
            break;
    }
    return YES;
}
*/

- (IBAction)onSubmit:(id)sender {

    NSString *lisent = [NSString stringWithFormat:@"%.1f",_listens];
    NSString *speak = [NSString stringWithFormat:@"%.1f",_speaks];
    NSString *read = [NSString stringWithFormat:@"%.1f",_reads];
    NSString *write = [NSString stringWithFormat:@"%.1f",_writes];
    if ([lisent isEqualToString:@""]) {
        self.tipLabel.hidden = NO;
        self.tipLabel.text = @"提示:请输入听力成绩";
        return;
    }else
    {
        self.tipLabel.hidden = YES;
        self.tipLabel.text = @"";
    }
    
    if ([read isEqualToString:@""]) {
        self.tipLabel.hidden = NO;
        self.tipLabel.text = @"提示:请输入阅读成绩";
        return;
    }else
    {
        self.tipLabel.hidden = YES;
        self.tipLabel.text = @"";
    }
    
    if ([speak isEqualToString:@""]) {
        self.tipLabel.hidden = NO;
        self.tipLabel.text = @"提示:请输入口语成绩";
        return;
    }else
    {
        self.tipLabel.hidden = YES;
        self.tipLabel.text = @"";
    }
    
    
    if ([write isEqualToString:@""]) {
        self.tipLabel.hidden = NO;
        self.tipLabel.text = @"提示:请输入写作成绩";
        return;
    }else
    {
        self.tipLabel.hidden = YES;
        self.tipLabel.text = @"";
    }
    
//修改目标成绩
    [[RusultManage shareRusultManage]sysTargetController:nil
                                                  Lisent:lisent
                                                   Speak:speak
                                                    Read:read
                                                   write:write
                                             SuccessData:^(NSDictionary *result) {
                                                 NSString *floatTotalScore = [[[result objectForKey:@"Data"] objectForKey:@"floatTotalScore"]stringValue];
                                                 NSDictionary *dic = @{@"lisent":lisent,
                                                                       @"speak":speak,
                                                                       @"read":read,
                                                                       @"wright":write,
                                                                       @"floatTotalScore":floatTotalScore};
                                                 if (self.delegate && [self.delegate respondsToSelector:@selector(myScoreSetupRusult:)]) {
                                                     [self.delegate myScoreSetupRusult:dic];
                                                 }
//                                                 [self dismissViewControllerAnimated:YES completion:nil];
                                                 [self shutMysoreSelf];
                                                 
//                                                 //初始化默认值
//                                                 listens = 5.0;
//                                                 speaks = 5.0;
//                                                 reads = 5.0;
//                                                 writes = 5.0;
//                                                 subValues = 0.0;
                                                 
                                             }];
}





- (IBAction)onCancel:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self shutMysoreSelf];
}

- (void)shutMysoreSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shutMyScoreView)]) {
        [self.delegate shutMyScoreView];
    }
}

@end

//
//  XDFGuideView3.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-9.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFGuideView3.h"
#import "BaseFillBlankView.h"
@interface XDFGuideView3()<BaseFillBlankViewDelegate>

@property (nonatomic,strong)UILabel *submitLabel;
@property (nonatomic,strong)NSArray *array;

@end

@implementation XDFGuideView3
@synthesize submitLabel,array;

- (void)awakeFromNib
{
    [super awakeFromNib];
    //1.创建视图
    [self _initView];
}
- (void)_initView
{
    array = @[@"听力",@"阅读",@"写作",@"口语"];
    self.vauleBgView.backgroundColor = [UIColor clearColor];
    for (int i= 0; i<array.count; i++) {
        
        UILabel *listen  = [[UILabel alloc]initWithFrame:CGRectMake(100+i*120, 50+15, 50, 30)];
        listen.text =array[i];
        [self.vauleBgView addSubview:listen];
        
        BaseFillBlankView *fillBlank = [[BaseFillBlankView alloc]initWithFrame:CGRectMake(140+i*120, 0, 50, 150)];
        fillBlank.fillBlankWidth = 50;
        fillBlank.delegate = self;
        fillBlank.fillBlankName =array[i];
        fillBlank.defaultValue = 5.0;
        fillBlank.valueType = ValueTypeNum;
        [self.vauleBgView addSubview:fillBlank];
    }
    
    submitLabel = [[UILabel alloc]initWithFrame:CGRectMake(100+4*120, 50+15, 100, 30)];
    submitLabel.text = @"总分: 5.0";
    [self.vauleBgView addSubview:submitLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark -BaseFillBlankViewDelegate
- (void)selectNum:(NSString *)value selectFillBlank:(NSString *)fillBlank
{
    //保存数据
   static float listen = 5.0;
   static float speak = 5.0;
   static float read = 5.0;
   static float write = 5.0;
   static float subValue = 0.0;

    if ([array containsObject:fillBlank]) {
        NSUInteger integet = [array indexOfObject:fillBlank];
        switch (integet) {
            case 0:
            {
                NSLog(@"听力");
                listen = [value floatValue];
            }
                break;
            case 1:
            {
                NSLog(@"阅读");
                 read = [value floatValue];
            }
                break;

            case 2:
            {
                NSLog(@"写作");
                write = [value floatValue];
            }
                break;
            case 3:
            {
                NSLog(@"口语");
                speak = [value floatValue];
            }
                break;

            default:
                break;
        }
    }
    subValue =listen+speak+read+write;
    if (subValue != 0.0) {
        float totalValue = subValue/4.0f;
        NSInteger totalInt = subValue/4.0f;
        
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
    
    /*
     NSDictionary *contentDic = @{@"lisent":lisent,
     @"speak":speak,
     @"read":read,
     @"write":write};

     */
    NSNumber *listenNum = [[NSNumber alloc]initWithFloat:listen];
    NSNumber *speakNum = [[NSNumber alloc]initWithFloat:speak];
    NSNumber *readNum = [[NSNumber alloc]initWithFloat:read];
    NSNumber *writeNum = [[NSNumber alloc]initWithFloat:write];
    [kUserDefaults setObject:listenNum forKey:@"lisent"];
    [kUserDefaults setObject:speakNum forKey:@"speak"];
    [kUserDefaults setObject:readNum forKey:@"read"];
    [kUserDefaults setObject:writeNum forKey:@"write"];
    [kUserDefaults synchronize];

}

@end

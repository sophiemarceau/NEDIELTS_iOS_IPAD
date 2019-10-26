//
//  BaseFillBlankView.m
//  vauleSelectDemo
//
//  Created by 李牛顿 on 14-12-10.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "BaseFillBlankView.h"
@interface BaseFillBlankView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) UIPickerView *pickView;

@end
@implementation BaseFillBlankView
@synthesize pickView;

- (id)init
{
    if (self = [super init]) {
        [self _initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}
//初始化视图
- (void)_initView
{
    /* 计算当前月的天数
     [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
     */
    
    
    //创建pickView
    pickView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    pickView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.backgroundColor = [UIColor clearColor];
    pickView.showsSelectionIndicator = YES;
    [self addSubview:pickView];
    
}

//布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    pickView.frame = CGRectMake(0.0, 0.0,self.fillBlankWidth, self.frame.size.height);
    
    switch (self.valueType) {
        case ValueTypeNum:
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Value" ofType:@"plist"];
            _data = [[NSArray alloc] initWithContentsOfFile:filePath];

        }
            break;
//        case ValueTypeYear:
//        {
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Year" ofType:@"plist"];
//            _data = [[NSArray alloc] initWithContentsOfFile:filePath];
//        }
//            break;
//            
//        case ValueTypeMonth:
//        {
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Month" ofType:@"plist"];
//            _data = [[NSArray alloc] initWithContentsOfFile:filePath];
//        }
//            break;
//        case ValueTypeDay:
//        {
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Day" ofType:@"plist"];
//            _data = [[NSArray alloc] initWithContentsOfFile:filePath];
//            
//        }
//            break;
//
        default:
            break;
    }
     NSString *delfault = [NSString stringWithFormat:@"%.1f",self.defaultValue];
     NSDictionary *dic = @{@"state":delfault};
     NSInteger index = [_data indexOfObject:dic];
     [pickView selectRow:index inComponent:0 animated:YES];
//    if (self.defaultValue == 0.0) {
//        [pickView selectRow:0 inComponent:0 animated:YES];
//    }else
//    {
//       
//    }

  }

//1.返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//2.返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    NSDictionary *dic = [_data objectAtIndex:row];
    NSString *state = [dic objectForKey:@"state"];
    return state;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {

    NSString *num  =  [_data[row] objectForKey:@"state"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(selectNum:selectFillBlank:)]) {
        [self.delegate selectNum:num selectFillBlank:self.fillBlankName];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myComl = view ? (UILabel *)view :[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.fillBlankWidth, 30)];
    NSString *num  =  [_data[row] objectForKey:@"state"];
    myComl.text = num;
    myComl.textAlignment = NSTextAlignmentCenter;
    myComl.font = [UIFont systemFontOfSize:16.0f];
    myComl.backgroundColor = [UIColor clearColor];
    
    return myComl;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.fillBlankWidth;
}





@end

//
//  Dlg_AddExamTimeViewController.h
//  IELTS
//
//  Created by melp on 14/12/2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TypeTimeNone,
    TypeTimeAboadDate,   //留学
    TypeTimeTestDate     //考试
}TypeTimes;

@protocol Dlg_AddExamTimeViewControllerDelegate <NSObject>

- (void)typeDate:(NSString *)string  typeTime:(TypeTimes)type resultDic:(NSDictionary *)resultDic;
@optional
- (void)shutAddExamTimeView;

@end

@interface Dlg_AddExamTimeViewController : UIViewController

@property (nonatomic,assign)TypeTimes typeTime; //类型
@property (nonatomic,unsafe_unretained)id<Dlg_AddExamTimeViewControllerDelegate>delegate;  //枚举

- (IBAction)onSubmit:(id)sender;
- (IBAction)onCancel:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *tipLabelExamTime;

@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;

@property (weak, nonatomic) IBOutlet UILabel *titlLabel;

@property (nonatomic,strong)NSString *tDate_ID;

@property (nonatomic,strong)NSString *abroadTimes;

@end

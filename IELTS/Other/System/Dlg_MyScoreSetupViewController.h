//
//  Dlg_MyScoreSetupViewController.h
//  IELTS
//
//  Created by melp on 14/12/2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Dlg_MyScoreSetupViewControllerDelegate<NSObject>

- (void)myScoreSetupRusult:(NSDictionary *)rusultDic;
@optional
- (void)shutMyScoreView;

@end
@interface Dlg_MyScoreSetupViewController : UIViewController

@property (nonatomic,unsafe_unretained)id<Dlg_MyScoreSetupViewControllerDelegate>delegate;

- (IBAction)onCancel:(id)sender;
- (IBAction)onSubmit:(id)sender;

@property (nonatomic,assign)float listens;
@property (nonatomic,assign)float speaks;
@property (nonatomic,assign)float reads;
@property (nonatomic,assign)float writes;
@property (nonatomic,assign)float subValues;



@property (weak, nonatomic) IBOutlet UILabel *tipLabel;


@end

//
//  MaterialTableViewCell.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-27.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "MaterialTableViewCell.h"

@interface MaterialTableViewCell()
@property (nonatomic,strong)UIImageView *imageViews;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIButton *conllentButton;
@end
@implementation MaterialTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initData];
    }
    return self;
}

- (void)_initData
{
    
    //图片
    _imageViews = [[UIImageView alloc]init];
    [self.contentView addSubview:_imageViews];
    //主标题
    _titleLabel = [ZCControl createLabelWithFrame:CGRectZero Font:16.0f Text:@""];
    [self.contentView addSubview:_titleLabel];
    
    //副标题
    _detailLabel = [ZCControl createLabelWithFrame:CGRectZero Font:14.0f Text:@""];
    [self.contentView addSubview:_detailLabel];
    
    //收藏按钮  favorite.png   favorited.png
    if (_conllentButton == nil) {
        _conllentButton = [ZCControl createButtonWithFrame:CGRectZero ImageName:@"favorite.png" Target:self Action:@selector(collentButtonActions:) Title:@""];
        [_conllentButton setBackgroundImage:[UIImage imageNamed:@"favorited.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:_conllentButton];

    }
}

- (void)collentButtonActions:(UIButton *)button
{
    NSNumber *num = [NSNumber numberWithBool:!button.selected];
    NSDictionary *dic = @{@"mateId":[_dicData objectForKey:@"Mate_ID"],
                          @"optType":num};
    button.selected = !button.selected;
    //添加收藏、取消收藏
    [[RusultManage shareRusultManage]studyCancelAndAddCollectRusult:dic viewController:self.viewController successData:^(NSDictionary *result) {
        NDLog(@"%@",result);
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelCollent)]) {
            [self.delegate cancelCollent];
        }
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    NDLog(@"%@",self.dicData);
    _imageViews.frame = CGRectMake(25, (self.height-39)/2, 39, 39);

    //判断是否为收藏
    NSString *collentMF = [_dicData objectForKey:@"MF_ID"];
    if (![collentMF isKindOfClass:[NSNull class]]) {
        _conllentButton.selected = YES;
    }else
    {
        _conllentButton.selected = NO;
    }
    //标题
    _titleLabel.frame = CGRectMake(_imageViews.right+20, (self.height-50)/2, self.width-200, 30);
    _titleLabel.text = [_dicData objectForKey:@"Name"];
    
    //副标题
    _detailLabel.frame = CGRectMake(_imageViews.right+20, _titleLabel.bottom-10, self.width-200, 30);
    
    //看过之后至灰
    if ([[_dicData objectForKey:@"TF_ID"] isKindOfClass:[NSNull class]]) {
        _titleLabel.textColor = [UIColor darkGrayColor];
        _detailLabel.textColor = [UIColor darkGrayColor];
    }else
    {
        _titleLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.textColor = [UIColor lightGrayColor];
    }
//    [_dicData objectForKey:@"CreateTime"];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *st = [format stringFromDate:date];

    if (![[_dicData objectForKey:@"nLessonNo"] isKindOfClass:[NSNull class]]) {
        NSString *nLessonNo =  [[_dicData objectForKey:@"nLessonNo"] stringValue];
        if (nLessonNo.length > 0 && nLessonNo != nil) {
            NSString *time = [ZCControl changeCreatTime:[_dicData objectForKey:@"CreateTime"]];
            NSString *string = [NSString stringWithFormat:@"科目:%@ | 上传者:%@ | 课次:%@ | 发布时间: %@",[_dicData objectForKey:@"catagoryName"],[_dicData objectForKey:@"NickName"],nLessonNo,time];
            _detailLabel.text = string;
        }else
        {
            NSString *time = [ZCControl changeCreatTime:[_dicData objectForKey:@"CreateTime"]];
            NSString *string = [NSString stringWithFormat:@"科目:%@ | 上传者:%@ | 发布时间: %@",[_dicData objectForKey:@"catagoryName"],[_dicData objectForKey:@"NickName"],time];
            _detailLabel.text = string;
        }
    }else
    {
        NSString *time = [ZCControl changeCreatTime:[_dicData objectForKey:@"CreateTime"]];
        NSString *string = [NSString stringWithFormat:@"科目:%@ | 上传者:%@ | 发布时间: %@",[_dicData objectForKey:@"catagoryName"],[_dicData objectForKey:@"NickName"],time];
        _detailLabel.text = string;
    }
    
    //收藏按钮布局
    _conllentButton.frame = CGRectMake(self.width-80, (self.height-45)/2, 45, 45);
    
    if (![[_dicData objectForKey:@"StorePoint"] isKindOfClass:[NSNull class]]) {
        NSString *storePoint = [[_dicData objectForKey:@"StorePoint"] stringValue];
        if (kStringEqual(storePoint, @"1")) {
            
            NSString *fileType = [_dicData objectForKey:@"FileType"];
            if ([fileType isEqualToString:@"docx"] || [fileType isEqualToString:@"doc"]) {
                _imageViews.image = [UIImage imageNamed:@"icon_world.png"];
            }else if ([fileType isEqualToString:@"ppt"] || [fileType isEqualToString:@"pptx"])
            {
                _imageViews.image = [UIImage imageNamed:@"icon_ppt.png"];
                
            }else if ([fileType isEqualToString:@"pdf"])
            {
                _imageViews.image = [UIImage imageNamed:@"icon_pdf.png"];
            }else if ([fileType isEqualToString:@"xlsx"] || [fileType isEqualToString:@"xls"])
            {
                _imageViews.image = [UIImage imageNamed:@"icon_excel.png"];
            }
            
        }else if (kStringEqual(storePoint, @"2"))
        {
            _imageViews.image = [UIImage imageNamed:@"icon_video.png"];
        }
    }

}






@end

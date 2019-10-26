
#import "Cell1.h"

@interface Cell1()

@property (nonatomic,strong)UILabel *arrowLabel;

@end

@implementation Cell1
@synthesize titleLabel,arrowImageView,arrowLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _initView];
    
}
- (void)_initView
{    
    UIImage *image = [ZCControl createImageWithColor:[UIColor redColor]];
    self.arrowImageView.image = image;
    
    arrowLabel =  [ZCControl createLabelWithFrame:CGRectZero Font:18.0f Text:@""];
    arrowLabel.textColor =[UIColor whiteColor];
    arrowLabel.textAlignment = NSTextAlignmentCenter;
    [self.arrowImageView addSubview:arrowLabel];
    

    self.titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

    self.arrowImageView.frame = CGRectMake(self.width-20-30, (self.contentView.height-30)/2, 30, 30);
    self.arrowImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.arrowImageView.layer.borderWidth = 1;
    self.arrowImageView.layer.cornerRadius = self.arrowImageView.width/2;
    self.arrowImageView.layer.masksToBounds = YES;

    arrowLabel.frame = CGRectMake(0, 0, self.arrowImageView.width, self.arrowImageView.height);
    arrowLabel.text = _numLie;
    
    self.titleLabel.frame = CGRectMake(20, (self.contentView.height-40)/2, self.width-100, 40);
    self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    
}


- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.hidden = YES;
        self.backgroundColor = TABBAR_BACKGROUNDLight;
        self.titleLabel.textColor = [UIColor whiteColor];
    }else
    {
        self.arrowImageView.hidden = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor darkGrayColor];
    }
}

@end

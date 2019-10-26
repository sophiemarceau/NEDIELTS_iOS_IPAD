
#import <UIKit/UIKit.h>

@interface Cell1 : UITableViewCell


@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;

//显示个数
@property (nonatomic,strong)NSString *numLie;

@end

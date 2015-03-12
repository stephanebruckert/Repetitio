#import <UIKit/UIKit.h>

typedef void (^TSPToDoCellDidTapButtonBlock)();

@interface RPToDoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (copy, nonatomic) TSPToDoCellDidTapButtonBlock didTapButtonBlock;

@end

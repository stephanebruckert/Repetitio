#import "RPToDoCell.h"

@implementation RPToDoCell

#pragma mark -
#pragma mark Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Setup View
    [self setupView];
}

#pragma mark -
#pragma mark View Methods
- (void)setupView {
    UIImage *imageNormal = [UIImage imageNamed:@"button-done-normal"];
    UIImage *imageSelected = [UIImage imageNamed:@"button-done-selected"];
    
    [self.doneButton setImage:imageNormal forState:UIControlStateNormal];
    [self.doneButton setImage:imageNormal forState:UIControlStateDisabled];
    [self.doneButton setImage:imageSelected forState:UIControlStateSelected];
    [self.doneButton setImage:imageSelected forState:UIControlStateHighlighted];
    [self.doneButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark Actions
- (void)didTapButton:(UIButton *)button {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock();
    }
}

@end

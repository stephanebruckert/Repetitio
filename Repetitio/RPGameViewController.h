#import <UIKit/UIKit.h>

@interface RPGameViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

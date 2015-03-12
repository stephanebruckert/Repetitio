#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface RPAddToDoViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

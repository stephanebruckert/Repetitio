#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface RPUpdateToDoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSManagedObject *record;

@end

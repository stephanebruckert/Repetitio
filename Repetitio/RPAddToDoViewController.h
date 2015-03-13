#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PAYFormBuilder.h"

@interface RPAddToDoViewController : PAYFormTableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

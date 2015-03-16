#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PAYFormBuilder.h"

@interface RPUpdateToDoViewController : PAYFormTableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSManagedObject *record;

@end

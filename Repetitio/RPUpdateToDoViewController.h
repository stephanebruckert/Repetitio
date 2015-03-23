#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PAYFormBuilder.h"
#import "RPWord.h"

@interface RPUpdateToDoViewController : PAYFormTableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) RPWord *record;

@end

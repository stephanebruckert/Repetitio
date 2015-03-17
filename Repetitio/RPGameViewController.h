#import <UIKit/UIKit.h>
#import "PAYFormBuilder.h"

@interface RPGameViewController : PAYFormTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *success;

@end

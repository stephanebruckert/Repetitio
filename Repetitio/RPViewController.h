#import <UIKit/UIKit.h>
#import "UINavigationController+SGProgress.h"

@interface RPViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

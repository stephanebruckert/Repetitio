#import "RPViewController.h"

#import <CoreData/CoreData.h>

#import "RPToDoCell.h"
#import "RPAddToDoViewController.h"
#import "RPUpdateToDoViewController.h"
#import "RPGameViewController.h"
#import "DOPDropDownMenu.h"
#import "RPWord.h"

@interface RPViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSIndexPath *selection;
@property (nonatomic, copy) NSArray *lists;
@property (nonatomic, copy) NSArray *languages;
@property (nonatomic, copy) NSArray *difficulties;
@property (nonatomic, copy) NSArray *originalArray;
@property (nonatomic, copy) NSArray *results;

@end

@implementation RPViewController

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDemoWords];
    self.navigationController.toolbarHidden=NO;
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RPItem"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
  
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }

    //Sorting
    self.lists = @[NSLocalizedString(@"List", @"city1"),
                   NSLocalizedString(@"c", @"c"),
                   NSLocalizedString(@"city3", @"city3")];
    self.languages = @[NSLocalizedString(@"Language", @"all"),
                   NSLocalizedString(@"English", @"english"),
                   NSLocalizedString(@"Spanish", @"spanish")];
    self.difficulties = @[NSLocalizedString(@"Difficulty", @"all dif"),
                       NSLocalizedString(@"Hard", @"english"),
                       NSLocalizedString(@"Medium", @"english"),
                       NSLocalizedString(@"Easy", @"spanish")];
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addToDoViewController"]) {
        // Obtain Reference to View Controller
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        RPAddToDoViewController *vc = (RPAddToDoViewController *)[nc topViewController];
        
        // Configure View Controller
        [vc setManagedObjectContext:self.managedObjectContext];
        
    } else if ([segue.identifier isEqualToString:@"updateToDoViewController"]) {
        // Obtain Reference to View Controller
        RPUpdateToDoViewController *vc = (RPUpdateToDoViewController *)[segue destinationViewController];
        
        // Configure View Controller
        [vc setManagedObjectContext:self.managedObjectContext];
        
        if (self.selection) {
            // Fetch Record
            RPWord *record = [self.fetchedResultsController objectAtIndexPath:self.selection];
            
            if (record) {
                [vc setRecord:record];
            }
            
            // Reset Selection
            [self setSelection:nil];
        }
    } else if ([segue.identifier isEqualToString:@"gameViewController"]) {
        RPGameViewController *vc = (RPGameViewController *)[segue destinationViewController];
        
        // Configure View Controller
        [vc setManagedObjectContext:self.managedObjectContext];
    }
}

#pragma mark -
#pragma mark Fetched Results Controller Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:(RPToDoCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RPToDoCell *cell = (RPToDoCell *)[tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    
    // Configure Table View Cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(RPToDoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Fetch Record
    NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Update Cell
    [cell.nameLabel setText:[record valueForKey:@"word"]];
    [cell.doneButton setSelected:[[record valueForKey:@"done"] boolValue]];
    
    [cell setDidTapButtonBlock:^{
        BOOL isDone = [[record valueForKey:@"done"] boolValue];
        
        // Update Record
        [record setValue:@(!isDone) forKey:@"done"];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (record) {
            [self.fetchedResultsController.managedObjectContext deleteObject:record];
        }
    }
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Store Selection
    [self setSelection:indexPath];
    
    // Perform Segue
    [self performSegueWithIdentifier:@"updateToDoViewController" sender:self];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RPItem"];
    NSString *prediStr1;
    NSString *title = [menu titleForRowAtIndexPath:indexPath];

    switch (indexPath.column) {
        case 0: {
            if (indexPath.row == 0) {
                prediStr1 = @"ANY trans LIKE '*'";
            } else {
                prediStr1 = [NSString stringWithFormat:@"ANY trans BEGINSWITH '%@'", title];
            }
            // Add Sort Descriptors
            [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"trans" ascending:YES]]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",prediStr1]];
            [fetchRequest setPredicate:predicate];
            break;
        }
        case 1: {
            if (indexPath.row == 0) {
                prediStr1 = @"ANY trans LIKE '*'";
            } else {
                prediStr1 = [NSString stringWithFormat:@"ANY trans BEGINSWITH '%@'", title];
            }
            // Add Sort Descriptors
            [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"trans" ascending:YES]]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",prediStr1]];
            [fetchRequest setPredicate:predicate];
            break;
        }
        case 2: {
            if (indexPath.row == 0) {
                prediStr1 = @"ANY trans LIKE '*'";
            } else {
                prediStr1 = [NSString stringWithFormat:@"ANY trans BEGINSWITH '%@'", title];
            }
            // Add Sort Descriptors
            [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"trans" ascending:YES]]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",prediStr1]];
            [fetchRequest setPredicate:predicate];
            break;
        }
        default:
            break;
    }

    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    [self.tableView reloadData];
}


- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0: return self.languages[indexPath.row];
            break;
        case 1: return self.lists[indexPath.row];
            break;
        case 2: return self.difficulties[indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return 3;
}

- (void)addDemoWords {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"RPItem" inManagedObjectContext:self.managedObjectContext]];
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    NSError *err;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&err];
    
    if(count == NSNotFound) {
        //Handle error
    }
    if (count == 0) {
        // Create Entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"RPItem" inManagedObjectContext:self.managedObjectContext];
        
        NSArray *myArray = @[
                             @[ @"abate", @"se calmer"],
                             @[ @"gainsay", @"réfuter"],
                             @[ @"garrulous", @"bavard"],
                             @[ @"goad", @"provoquer"],
                             @[ @"abscond", @"s'enfuir"],
                             @[ @"cogent", @"convaincant"],
                             @[ @"gouge", @"creuser"],
                             @[ @"abstemious", @"sobre"],
                             @[ @"levity", @"légèreté"],
                             @[ @"admonish", @"réprimander"],
                             @[ @"compendium", @"collection"],
                             @[ @"gregarious", @"sociable"],
                             @[ @"guileless", @"franc"],
                             ];
        for (int i = 0; i < myArray.count; i++) {
            // Initialize Record
            NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
            
            // Populate Record
            [record setValue:myArray[i][0] forKey:@"word"];
            [record setValue:myArray[i][1] forKey:@"trans"];
            [record setValue:[NSDate date] forKey:@"createdAt"];
            
            // Save Record
            NSError *error = nil;
            
            if ([self.managedObjectContext save:&error]) {
                // Dismiss View Controller
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                if (error) {
                    NSLog(@"Unable to save record.");
                    NSLog(@"%@, %@", error, error.localizedDescription);
                }
            }
        }
    }
}

@end

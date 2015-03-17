#import <CoreData/CoreData.h>

#import "RPGameViewController.h"
#import "MWKProgressIndicator.h"
#import "RPWord.h"
#import "RPGame.h"

@interface RPGameViewController ()

@property(nonatomic, getter = isCanceled) BOOL canceled;

@property (nonatomic, retain) PAYFormTableBuilder *tableBuilder;
@property (strong, nonatomic) RPGame *currentGame;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RPGameViewController

float progress = 0.0f;
int step = 0;

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Actions
- (IBAction)cancel:(id)sender {
    // Pop View Controller
    [MWKProgressIndicator dismiss];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)forward:(id)sender {
    progress += 0.1f;
    [MWKProgressIndicator updateProgress:progress];
    [MWKProgressIndicator updateMessage:@"Test 2/10"];
}

- (void)loadStructure:(PAYFormTableBuilder *)tableBuilder {
    _tableBuilder = tableBuilder;
    [MWKProgressIndicator show];
    [MWKProgressIndicator updateProgress:progress];
    [MWKProgressIndicator updateMessage:@"Test 1/10"];
    self.currentGame = [[RPGame alloc] initWithManagedObjectContext:self.managedObjectContext];
    RPWord* selectedWord = [self.currentGame getRandomQuestion];
    
    PAYHeaderView* header = [[PAYHeaderView alloc]initWithFrame:self.view.frame];
    header.iconImage = [UIImage imageNamed:@"header"];
    header.title = [selectedWord valueForKey:@"word"];
    header.subTitle = @"What does it mean?";
    
    self.tableView.tableHeaderView = header;

    [tableBuilder addSectionWithName:@"Your choice" contentBlock:^(PAYFormSectionBuilder * sectionBuilder) {
        [sectionBuilder addButtonGroupWithMultiSelection:NO contentBlock:^(PAYFormButtonGroupBuilder *groupBuilder) {
            for (id w in [self.currentGame getUpTo4RandomAnswers:selectedWord]) {
                [groupBuilder addOption:w withText:[w valueForKey:@"trans"]];
            }
            groupBuilder.required = YES;
        }];
    }];
    
    tableBuilder.validationBlock =  ^NSError *{
        // Here you could add a validation for the complete form
        return nil;
    };
    tableBuilder.formSuccessBlock = ^{
        UIAlertView *alertView  = [[UIAlertView alloc]initWithTitle:@"Success"
                                                            message:@"Well done!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
        [alertView show];
    };

}

@end

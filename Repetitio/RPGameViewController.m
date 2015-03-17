#import <CoreData/CoreData.h>

#import "RPGameViewController.h"
#import "MWKProgressIndicator.h"
#import "RPWord.h"
#import "RPGame.h"

@interface RPGameViewController ()

@property(nonatomic, getter = isCanceled) BOOL canceled;

@property (nonatomic, retain) PAYFormTableBuilder *tableBuilder;
@property (strong, nonatomic) RPGame *currentGame;
@property (strong, nonatomic) RPWord *currentAnswer;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) PAYFormButtonGroup *answerGroup;

@end

@implementation RPGameViewController

float progress = 0.1f;
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
    // Check if answer selected set
    if (self.answerGroup.value) {
        // Check answer
        if ([_currentAnswer isEqual:self.answerGroup.value]) {
            NSLog(@"%@", self.answerGroup.value);
        }
        // Next card
        if (step == 9) {
            [MWKProgressIndicator updateMessage:[NSString stringWithFormat:@"Last Question!"]];
            progress += 0.1f;
        } else if (step > 9) {
            
        } else {
            progress += 0.1f;
            [self reloadStructure];
        }
        [MWKProgressIndicator updateProgress:progress];

    } else {
        // Do nothing but alert
        [MWKProgressIndicator updateMessage:[NSString stringWithFormat:@"Choose an answer!"]];
    }
}

- (void)loadStructure:(PAYFormTableBuilder *)tableBuilder {
    // Next card
    step++;
    _tableBuilder = tableBuilder;
    [MWKProgressIndicator show];
    [MWKProgressIndicator updateProgress:progress];
    [MWKProgressIndicator updateMessage:[NSString stringWithFormat:@"Test %i/10", step]];
    self.currentGame = [[RPGame alloc] initWithManagedObjectContext:self.managedObjectContext];
    _currentAnswer = [self.currentGame getRandomQuestion];
    
    PAYHeaderView* header = [[PAYHeaderView alloc]initWithFrame:self.view.frame];
    header.iconImage = [UIImage imageNamed:@"header"];
    header.title = [_currentAnswer valueForKey:@"word"];
    header.subTitle = @"What does it mean?";
    
    self.tableView.tableHeaderView = header;

    [tableBuilder addSectionWithName:@"Your choice" contentBlock:^(PAYFormSectionBuilder * sectionBuilder) {
        self.answerGroup = [sectionBuilder addButtonGroupWithMultiSelection:NO contentBlock:^(PAYFormButtonGroupBuilder *groupBuilder){
            for (id w in [self.currentGame getUpTo4RandomAnswers:_currentAnswer]) {
                [groupBuilder addOption:w withText:[w valueForKey:@"trans"]];
            }
            groupBuilder.required = YES;
        }];
    }];
}

@end

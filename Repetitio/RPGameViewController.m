#import <CoreData/CoreData.h>

#import "RPGameViewController.h"
#import "MWKProgressIndicator.h"
#import "RPWord.h"
#import "RPGame.h"

@interface RPGameViewController ()

@property(nonatomic, getter = isCanceled) BOOL canceled;

@property (strong, nonatomic) RPGame *currentGame;
@property (strong, nonatomic) RPWord *currentAnswer;
@property (strong, nonatomic) NSArray *last_answers;
@property (strong, nonatomic) NSMutableArray *wrongArray;

@property (nonatomic, retain) PAYFormTableBuilder *tableBuilder;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) PAYFormButtonGroup *answerGroup;

@end

@implementation RPGameViewController

float progress = 0.1f;
int step = 1;
int wrong_answers = 0;
int successful_answers = 0;
BOOL last_was_success = YES;

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
            _wrongArray = nil;
            successful_answers++;
            step++;
            last_was_success = YES;
             if (step == 9) {
                 [MWKProgressIndicator updateMessage:[NSString stringWithFormat:@"Last Question!"]];
                 progress += 0.1f;
             } else if (step > 9) {

             } else {
                 progress += 0.1f;
                 [self reloadStructure];
             }
        } else {
            wrong_answers++;
            if (_wrongArray == nil) _wrongArray = [NSMutableArray array];
            [_wrongArray addObject:self.answerGroup.value];
            last_was_success = NO;
            [self reloadStructure];
        }
        float success = 100 * successful_answers/(step-1+wrong_answers);
        [_success setTitle:[NSString stringWithFormat:@"Success: %.0f %%", success]];
    } else {
        // Do nothing but alert
        [MWKProgressIndicator updateMessage:[NSString stringWithFormat:@"Choose an answer!"]];
    }
}

- (void)loadStructure:(PAYFormTableBuilder *)tableBuilder {
    // Next card
    _tableBuilder = tableBuilder;
    [MWKProgressIndicator show];
    [MWKProgressIndicator updateProgress:progress];
    [MWKProgressIndicator updateMessage:[NSString stringWithFormat:@"Test %i/10", step]];
    self.currentGame = [[RPGame alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    if (last_was_success) {
        _currentAnswer = [self.currentGame getRandomQuestion];
        _last_answers = [self.currentGame getUpTo4RandomAnswers:_currentAnswer];
    }
    
    PAYHeaderView* header = [[PAYHeaderView alloc]initWithFrame:self.view.frame];
    header.iconImage = [UIImage imageNamed:@"header"];
    header.title = [_currentAnswer valueForKey:@"word"];
    header.subTitle = @"What does it mean?";
    
    self.tableView.tableHeaderView = header;

    [tableBuilder addSectionWithName:@"Your choice" contentBlock:^(PAYFormSectionBuilder * sectionBuilder) {
        self.answerGroup = [sectionBuilder addButtonGroupWithMultiSelection:NO contentBlock:^(PAYFormButtonGroupBuilder *groupBuilder){
            BOOL selectable;
            for (id w in _last_answers) {
                if (_wrongArray == nil) {
                    selectable = YES;
                } else if ([_wrongArray containsObject:w]) {
                    selectable = NO;
                } else {
                    selectable = YES;
                }
                [groupBuilder addOption:w withText:[w valueForKey:@"trans"] icon:[UIImage imageNamed:@"usa"] selectionBlock:nil selectable:selectable];
            }
            groupBuilder.required = YES;
        }];
    }];
}

@end

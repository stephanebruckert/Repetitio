#import <CoreData/CoreData.h>

#import "RPGameViewController.h"
#import "MWKProgressIndicator.h"
#import "RPWord.h"
#import "RPGame.h"

@interface RPGameViewController ()

@property(nonatomic, getter = isCanceled) BOOL canceled;

@property (strong, nonatomic) RPWord *currentAnswer;
@property (strong, nonatomic) NSArray *last_answers;
@property (strong, nonatomic) NSMutableArray *wrongArray;

@property (nonatomic, retain) PAYFormTableBuilder *tableBuilder;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) PAYFormButtonGroup *answerGroup;

@end

@implementation RPGameViewController

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
    [[self currentGame] endGame];
}

- (IBAction)forward:(id)sender {
    // Check if answer selected set
    if (self.answerGroup.value) {
        if ([_currentAnswer isEqual:self.answerGroup.value]) {
            /* Success */
            _wrongArray = nil;
            [self currentGame].successful_answers++;
            [self currentGame].step++;
            [self currentGame].last_was_success = YES;
            [_currentAnswer update:4];
            NSLog(@"%@", _currentAnswer);
             if ([self currentGame].step <= [self currentGame].maxSteps) {
                 /* Next question */
                 [[self currentGame] incrementProgress];
                 [self reloadStructure];
             } else {
                 /* End of the game */
                 [MWKProgressIndicator showSuccessMessage:@"Congrats!"];
                 [self.navigationController popViewControllerAnimated:NO];
                 [[self currentGame] endGame];
                 return;
             }
        } else {
            /* Fail */
            [_currentAnswer update:2];
            NSLog(@"%@", _currentAnswer);
            [self currentGame].wrong_answers++;
            if (_wrongArray == nil) _wrongArray = [NSMutableArray array];
            [_wrongArray addObject:self.answerGroup.value];
            [self currentGame].last_was_success = NO;
            [self reloadStructure];
        }
        float success = 100 * [self currentGame].successful_answers/([self currentGame].step-1+[self currentGame].wrong_answers);
        [_success setTitle:[NSString stringWithFormat:@"Success: %.0f %%", success]];
    } else {
        // Do nothing but alert
        [MWKProgressIndicator updateMessage:[NSString stringWithFormat:@"Choose an answer!"]];
    }
}

- (RPGame*)currentGame {
    return [RPGame sharedManager:self.managedObjectContext];
}

- (void)loadStructure:(PAYFormTableBuilder *)tableBuilder {
    // Next card
    _tableBuilder = tableBuilder;
    [MWKProgressIndicator show];
    [MWKProgressIndicator updateProgress:[self currentGame].progress];
    [MWKProgressIndicator updateMessage:[NSString stringWithFormat:@"Test %i/%i", [self currentGame].step, [self currentGame].maxSteps]];
    
    if ([self currentGame].last_was_success) {
        _currentAnswer = [[self currentGame] getRandomQuestion];
        NSLog(@"%@", _currentAnswer);
        _last_answers = [[self currentGame] getUpTo4RandomAnswers:_currentAnswer];
    }
    
    PAYHeaderView* header = [[PAYHeaderView alloc]initWithFrame:self.view.frame];
    header.iconImage = [UIImage imageNamed:@"header"];
    header.title = [_currentAnswer valueForKey:@"word"];
    
    self.tableView.tableHeaderView = header;

    [tableBuilder addSectionWithName:@"What does it mean?" contentBlock:^(PAYFormSectionBuilder * sectionBuilder) {
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

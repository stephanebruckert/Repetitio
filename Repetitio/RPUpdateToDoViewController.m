#import "RPUpdateToDoViewController.h"

@interface RPUpdateToDoViewController ()

@property (retain, nonatomic) PAYFormSingleLineTextField *textField;
@property (retain, nonatomic) PAYFormSingleLineTextField *textFieldTrans;

@end

@implementation RPUpdateToDoViewController

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.record) {
        // Update Text Field
        [self.textField.textField setText:[self.record valueForKey:@"word"]];
        [self.textFieldTrans.textField setText:[self.record valueForKey:@"trans"]];
    }
}

#pragma mark -
#pragma mark Actions
- (IBAction)cancel:(id)sender {
    // Pop View Controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    // Helpers
    NSString *name = self.textField.textField.text;
    NSString *trans = self.textFieldTrans.textField.text;
    
    if (name && name.length) {
        // Populate Record
        [self.record setValue:name forKey:@"word"];
        [self.record setValue:trans forKey:@"trans"];
        
        // Save Record
        NSError *error = nil;
        
        if ([self.managedObjectContext save:&error]) {
            // Pop View Controller
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            if (error) {
                NSLog(@"Unable to save record.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            // Show Alert View
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    } else {
        // Show Alert View
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do needs a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)loadStructure:(PAYFormTableBuilder *)tableBuilder {
    [tableBuilder addSectionWithName:@"Translations"
                        contentBlock:^(PAYFormSectionBuilder * sectionBuilder) {
                            self.textField = [sectionBuilder addFieldWithName:@"English" placeholder:@"compulsory"];
                            self.textFieldTrans = [sectionBuilder addFieldWithName:@"French" placeholder:@"can be filled later"];
                        }];
    
    NSArray *countries = @[@[@"United States", @"usa"], @[@"Germany", @"de"], @[@"Spain", @"es"]];
    
    [tableBuilder addSectionWithName:@"Suggestions by Wordreference.com"
                        contentBlock:^(PAYFormSectionBuilder * sectionBuilder) {
                            [sectionBuilder addButtonGroupWithMultiSelection:NO
                                                                contentBlock:^(PAYFormButtonGroupBuilder *buttonGroupBuilder) {
                                                                    for (NSArray *country in countries) {
                                                                        [buttonGroupBuilder addOption:country[1]
                                                                                             withText:country[0]
                                                                                                 icon:[UIImage imageNamed:country[1]]];
                                                                    }
                                                                    [buttonGroupBuilder select:@"usa"];
                                                                }];
                        }];
    
    tableBuilder.formSuccessBlock = ^{
        // NSLog(@"%@", self.countryButtonGroup.values);
        // NSLog(@"%@", self.formSwitch.value ? @"YES" : @"NO");
        // [self performSegueWithIdentifier:@"next" sender:self];
    };
}

@end

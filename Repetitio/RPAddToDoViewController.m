#import "RPAddToDoViewController.h"

@interface RPAddToDoViewController ()

@property (retain, nonatomic) PAYFormSingleLineTextField *textField;
@property (retain, nonatomic) PAYFormSingleLineTextField *textFieldTrans;

@end

@implementation RPAddToDoViewController

#pragma mark -
#pragma mark Actions
- (IBAction)cancel:(id)sender {
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    // Helpers
    NSString *word = self.textField.textField.text;
    NSString *trans = self.textFieldTrans.textField.text;

    if (word && word.length) {
        // Create Entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"RPItem" inManagedObjectContext:self.managedObjectContext];
        
        // Initialize Record
        NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Populate Record
        [record setValue:word           forKey:@"word"];
        [record setValue:trans          forKey:@"trans"];
        [record setValue:[NSDate date]  forKey:@"createdAt"];
        
        // Repetition values
        [record setValue:[NSDate date]  forKey:@"smNextDate"];
        [record setValue:[NSDate date]  forKey:@"smPrevDate"];
        [record setValue:[NSNumber numberWithInt:0]  forKey:@"smInterval"];
        [record setValue:[NSNumber numberWithInt:0]  forKey:@"smReps"];
        [record setValue:[NSNumber numberWithFloat:2.5]  forKey:@"smEF"];
        
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

#import "RPGameViewController.h"
#import "MWKProgressIndicator.h"

@interface RPGameViewController ()
//@property (strong, nonatomic) NSArray *pickerData;
@property(nonatomic, getter = isCanceled) BOOL canceled;

@property (nonatomic, retain) PAYFormSingleLineTextField *userNameField;
@property (nonatomic, retain) PAYFormSingleLineTextField *passwordField1;
@property (nonatomic, retain) PAYFormSingleLineTextField *passwordField2;

@property (nonatomic, retain) PAYFormSingleLineTextField *streetTextField;
@property (nonatomic, retain) PAYFormSingleLineTextField *postalCodeTextField;
@property (nonatomic, retain) PAYFormSingleLineTextField *cityTextField;

@property (nonatomic, retain) PAYFormButtonGroup *countryButtonGroup;
@property (nonatomic, retain) PAYFormSwitch *formSwitch;

@end

@implementation RPGameViewController

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [MWKProgressIndicator show];
    [MWKProgressIndicator updateProgress:0.1f];
    // Initialize Data
    //_pickerData = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    // Connect data
    //self.picker.dataSource = self;
    //self.picker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//// The number of rows of data
//- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return _pickerData.count;
//}
//
//// The data to return for the row and component (column) that's being passed in
//- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return _pickerData[row];
//}

#pragma mark -
#pragma mark Actions
- (IBAction)cancel:(id)sender {
    // Pop View Controller
    [MWKProgressIndicator dismiss];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)loadStructure:(PAYFormTableBuilder *)tableBuilder {
    [tableBuilder addSectionWithName:nil
                          labelStyle:PAYFormTableLabelStyleNone
                        contentBlock:^(PAYFormSectionBuilder *sectionBuilder) {
                            self.userNameField = [sectionBuilder addFieldWithName:@"Username" placeholder:@"your username"
                                                                   configureBlock:^(PAYFormSingleLineTextField *formField) {
                                                                       formField.required = YES;
                                                                       formField.minTextLength = 4;
                                                                   }];
                            
                            self.passwordField1 = [sectionBuilder addFieldWithName:@"Password" placeholder:@"your password"
                                                                    configureBlock:^(PAYFormSingleLineTextField *formField) {
                                                                        [formField activateSecureInput];
                                                                    }];
                            self.passwordField2 = [sectionBuilder addFieldWithName:@"Password 2"
                                                                       placeholder:@"repeat your password"
                                                                    configureBlock:^(PAYFormSingleLineTextField *formField) {
                                                                        [formField activateSecureInput];
                                                                    }];
                        }];
    
    
    [tableBuilder addSectionWithName:@"Address"
                          labelStyle:PAYFormTableLabelStyleSimple
                        contentBlock:^(PAYFormSectionBuilder *sectionBuilder) {
                            self.streetTextField = [sectionBuilder addFieldWithName:@"Street" placeholder:@"your street"
                                                                     configureBlock:^(PAYFormSingleLineTextField *formField) {
                                                                         formField.required = YES;
                                                                         formField.expanding  = YES;
                                                                     }];
                            
                            self.postalCodeTextField = [sectionBuilder addFieldWithName:@"Postal code"
                                                                            placeholder:@"your postal code"
                                                                         configureBlock:^(PAYFormSingleLineTextField *formField) {
                                                                             formField.required = YES;
                                                                             formField.cleanBlock = ^id(PAYFormField *formField, id value) {
                                                                                 NSString *strValue = value;
                                                                                 return [strValue stringByReplacingOccurrencesOfString:@" "
                                                                                                                            withString:@""];
                                                                             };
                                                                         }];
                            self.cityTextField = [sectionBuilder addFieldWithName:@"City" placeholder:@"your city"
                                                                   configureBlock:^(PAYFormSingleLineTextField *formField) {
                                                                       formField.required = YES;
                                                                   }];
                        }];
    
    
    
    [tableBuilder addSectionWithName:@"Terms and Conditions"
                        contentBlock:^(PAYFormSectionBuilder *sectionBuilder) {
                            self.formSwitch = [sectionBuilder addSwitchWithName:@"Accept"
                                                                 configureBlock:^(PAYFormSwitch *formSwitch) {
                                                                     formSwitch.required = YES;
                                                                     
                                                                     [formSwitch setErrorMessage:[PAYFormErrorMessage errorMessageWithTitle:@"Accept"
                                                                                                                                    message:@"Please accept the terms and conditions to continue"]
                                                                                    forErrorCode:PAYFormMissingErrorCode];
                                                                 }];
                        }];
    
    tableBuilder.finishOnLastField = YES;
    tableBuilder.selectFirstField = YES;
    
    tableBuilder.validationBlock =  ^NSError *{
        if (![self.passwordField1.value isEqualToString:self.passwordField2.value]) {
            return [NSError validationErrorWithTitle:@"Password wrong" 
                                             message:@"Please enter the same password again" 
                                             control:self.passwordField2];
        }
        return nil;
    };
    
    tableBuilder.formSuccessBlock = ^{
        NSString *msg = [NSString stringWithFormat:@"Well done, %@. Here your cleaned postal code: %@. Country code: %@",
                         self.userNameField.value, self.postalCodeTextField.cleanedValue, self.countryButtonGroup.value];
        
        UIAlertView *alertView  = [[UIAlertView alloc]initWithTitle:@"Success"
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
        [alertView show];
    };
}

@end

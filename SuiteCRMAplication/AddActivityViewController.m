//
//  AddActivityViewController.m
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/1/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import "AddActivityViewController.h"
#import "Meeting+CoreDataClass.h"
#import "AppDelegate.h"

@interface AddActivityViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIDatePicker *datePickerStartDate;
    UIDatePicker *datePickerEndDate;
}

@property (weak, nonatomic) IBOutlet UITextField *subjectField;
@property (weak, nonatomic) IBOutlet UITextField *dateStartActField;
@property (weak, nonatomic) IBOutlet UITextField *dateEndActField;
@property (weak, nonatomic) IBOutlet UITextField *durationActField;
@property (weak, nonatomic) IBOutlet UITextField *statusActField;
@property (weak, nonatomic) IBOutlet UITextField *relatedToActField;
@property (weak, nonatomic) IBOutlet UITextField *placeActField;
@property (weak, nonatomic) IBOutlet UITextField *descActField;

@property (nonatomic, strong) UIPickerView *pickerViewDuration;
@property (nonatomic, strong) NSArray *pickerNamesDuration;

@property (nonatomic, strong) UIPickerView *pickerViewStatus;
@property (nonatomic, strong) NSArray *pickerNamesStatus;

@property (nonatomic, strong) UIPickerView *pickerViewRelatedTo;
@property (nonatomic, strong) NSArray *pickerNamesRelatedTo;

@end

@implementation AddActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //first Data Picker
    datePickerStartDate = [[UIDatePicker alloc] init];
    datePickerStartDate.datePickerMode = UIDatePickerModeDateAndTime;
    [self.dateStartActField setInputView:datePickerStartDate];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedStartDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dateStartActField setInputAccessoryView:toolBar];
    
    //second Data Picker
    datePickerEndDate = [[UIDatePicker alloc] init];
    datePickerEndDate.datePickerMode = UIDatePickerModeDateAndTime;
    [self.dateEndActField setInputView:datePickerEndDate];
    
    UIToolbar *toolBar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar2 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedEndDate)];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar2 setItems:[NSArray arrayWithObjects:space2,doneBtn2, nil]];
    [self.dateEndActField setInputAccessoryView:toolBar2];
    
    //PickerViewDuration
    
    self.pickerViewDuration =[[UIPickerView alloc] init];
    self.pickerNamesDuration = [[NSArray alloc] initWithObjects:    @"None",
                                                                    @"15 minutes",
                                                                    @"30 minutes",
                                                                    @"45 minutes",
                                                                    @"1 hour",
                                                                    @"1,5 hour",
                                                                    @"2 hour",
                                                                    @"3 hour",
                                                                    @"6 hour",
                                                                    @"1 day",
                                                                    @"1 day 1 hour",
                                                                    @"2 days",
                                                                    @"3 days",
                                                                    @"1 week", nil];
    self.pickerViewDuration.delegate= self;
    self.pickerViewDuration.dataSource = self;
    self.pickerViewDuration.showsSelectionIndicator = YES;
    [self.durationActField setInputView:self.pickerViewDuration];
    
    UIToolbar *toolBar3 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar3 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn3 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedDuration)];
    UIBarButtonItem *space3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar3 setItems:[NSArray arrayWithObjects:space3,doneBtn3, nil]];
    [self.durationActField setInputAccessoryView:toolBar3];
    
    //PickerViewStatus
    
    self.pickerViewStatus = [[UIPickerView alloc] init];
    self.pickerNamesStatus = [[NSArray alloc] initWithObjects:  @"Planned",
                                                                @"Held",
                                                                @"Not Held", nil];
    self.pickerViewStatus.delegate= self;
    self.pickerViewStatus.dataSource = self;
    self.pickerViewStatus.showsSelectionIndicator = YES;
    [self.statusActField setInputView:self.pickerViewStatus];
    
    UIToolbar *toolBar4 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar4 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn4 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedStatus)];
    UIBarButtonItem *space4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar4 setItems:[NSArray arrayWithObjects:space4,doneBtn4, nil]];
    [self.statusActField setInputAccessoryView:toolBar4];
    
    //PickerViewRelatedTo
    
    self.pickerViewRelatedTo = [[UIPickerView alloc] init];
    self.pickerNamesRelatedTo = [[NSArray alloc] initWithObjects:   @"Account",
                                                                    @"Contact",
                                                                    @"Task",
                                                                    @"Opportunity",
                                                                    @"Bug",
                                                                    @"Case",
                                                                    @"Lead",
                                                                    @"Project",
                                                                    @"Project Task",
                                                                    @"Target",nil];
    self.pickerViewRelatedTo.delegate= self;
    self.pickerViewRelatedTo.dataSource = self;
    self.pickerViewRelatedTo.showsSelectionIndicator = YES;
    [self.relatedToActField setInputView:self.pickerViewRelatedTo];
    
    UIToolbar *toolBar5 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar5 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn5 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedRelatedTo)];
    UIBarButtonItem *space5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar5 setItems:[NSArray arrayWithObjects:space5,doneBtn5, nil]];
    [self.relatedToActField setInputAccessoryView:toolBar5];

}


//Method Selected

- (void) showSelectedStartDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm"];
    self.dateStartActField.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:datePickerStartDate.date]];
    [self.dateStartActField resignFirstResponder];
}

- (void) showSelectedEndDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm"];
    self.dateEndActField.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:datePickerEndDate.date]];
    [self.dateEndActField resignFirstResponder];
}

- (void) showSelectedDuration {
    [self.durationActField resignFirstResponder];
}

- (void) showSelectedStatus {
    [self.statusActField resignFirstResponder];
}

- (void) showSelectedRelatedTo {
    [self.relatedToActField resignFirstResponder];
}

#pragma mark - UIPickerViewDataSource

// #3
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.pickerViewDuration) {
        return 1;
    } if (pickerView == self.pickerViewStatus) {
        return 1;
    } if (pickerView == self.pickerViewRelatedTo) {
        return 1;
    }
    
    return 0;
}

// #4
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.pickerViewDuration) {
        return [self.pickerNamesDuration count];
    } if (pickerView == self.pickerViewStatus) {
        return [self.pickerNamesStatus count];
    } if (pickerView == self.pickerViewRelatedTo) {
        return [self.pickerNamesRelatedTo count];
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

// #5
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.pickerViewDuration) {
        return self.pickerNamesDuration[row];
    } if (pickerView == self.pickerViewStatus) {
        return self.pickerNamesStatus[row];
    } if (pickerView == self.pickerViewRelatedTo) {
        return self.pickerNamesRelatedTo[row];
    }
    
    return nil;
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.pickerViewDuration) {
        self.durationActField.text = self.pickerNamesDuration[row];
    } if (pickerView == self.pickerViewStatus) {
        self.statusActField.text = self.pickerNamesStatus[row];
    } if (pickerView == self.pickerViewRelatedTo) {
        self.relatedToActField.text = self.pickerNamesRelatedTo[row];
    }
}


- (IBAction)saveButt:(UIBarButtonItem *)sender {
    
    NSString* sf = self.subjectField.text;
    NSString* pl = self.placeActField.text;
    NSString* rt = self.relatedToActField.text;
    NSString* dr = self.durationActField.text;
    NSString* st = self.statusActField.text;
    NSString* ds = self.descActField.text;

    Meeting *meeting = [[Meeting alloc] initWithContext:self.context];
    meeting.subject = sf;
    meeting.place = pl;
    meeting.relatedTo = rt;
    meeting.dateStart = datePickerStartDate.date;
    meeting.dateEnd = datePickerEndDate.date;
    meeting.duration = dr;
    meeting.status = st;
    meeting.desc = ds;
    
    
    [self showMessage:@"" withTitle:@"Do you really want to save?"];
}

- (void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [self.delegate saveContext];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end

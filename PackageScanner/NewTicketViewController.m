//
//  NewTicketViewController.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/25/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "NewTicketViewController.h"
#import "Ticket.h"
#import "TicketController.h"
#import <Parse/Parse.h>

@interface NewTicketViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *carrierSegmentedControl;

@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (weak, nonatomic) IBOutlet UITextField *optionalLocationTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) NSArray *carriers;

@end

@implementation NewTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    self.locationPicker.delegate = self;
    
    //set contents of pickerView
    self.locations = @[@"Customer Cage", @"Shared Cage", @"Recieving Dock", @"Other"];
    
    self.carriers = @[@"UPS", @"FedExGround", @"FedExAir", @"USPS", @"Other"];
    
    self.carrierSegmentedControl = [[UISegmentedControl alloc]initWithItems:self.carriers];
    

}

-(void)viewWillAppear:(BOOL)animated{
    //set timeStamp
    Ticket *ticket = [Ticket new];
    NSString *date = [ticket convertDatetoString:[NSDate date]];
    self.timeStampLabel.text = date;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return self.locations.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [self.locations objectAtIndex:row];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)clearButtonTapped:(id)sender {
    self.trackingNumberTextField.text = @"";
    self.optionalLocationTextField.text = @"";
}

- (IBAction)unwindToNewTicketViewController:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"unwindToNewTicketView"]) {
        
        ScanTrackingNumberViewController *scanTrackingNumberView = segue.sourceViewController;
        self.trackingNumberTextField.text = scanTrackingNumberView.trackingNumberString;
        
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    
    if ([self.trackingNumberTextField.text isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Information" message:@"Please make sure all fields are entered" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDestructive handler:nil]];
        
        [self.tabBarController presentViewController:alert animated:YES completion:nil];
        return;
    }
    //grab the index that is currently selected by the locationPicker
    NSInteger selectedLocation = [self.locationPicker selectedRowInComponent:0];
    
    //grab the index that is currently selected by the segmentedControl
     NSInteger selectedSegment = [self.carrierSegmentedControl selectedSegmentIndex];
    
    PFObject *newTicket = [PFObject objectWithClassName:[Ticket parseClassName]];
    newTicket[@"TimeStamp"] = [NSDate date];
    newTicket[@"Carrier"] = [self.carrierSegmentedControl titleForSegmentAtIndex:selectedSegment];
    newTicket[@"Employee"] = self.employeeLabel.text;
    newTicket[@"Location"] = [self.locations objectAtIndex:selectedLocation];
    newTicket[@"SubLocation"] = self.optionalLocationTextField.text;
    newTicket[@"TrackingNumber"] = self.trackingNumberTextField.text;
    [newTicket saveInBackground];
    
    //push an alert that tells the user the object was saved.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ticket Saved!" message:@"The Ticket was saved to the database" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self.tabBarController presentViewController:alert animated:YES completion:nil];
    
    [self clearButtonTapped:sender];
}

-(void)dismissKeyboard {
    
    [self.trackingNumberTextField resignFirstResponder];
    [self.optionalLocationTextField resignFirstResponder];
    [self.trackingNumberTextField resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

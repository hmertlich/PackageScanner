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
#import <MessageUI/MessageUI.h>
#import "NewTicketController.h"
#import "AppearanceController.h"

@interface NewTicketViewController ()<UIPickerViewDataSource, UIPickerViewDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@property (strong, nonatomic) IBOutlet UISegmentedControl *carrierSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (weak, nonatomic) IBOutlet UITextField *optionalLocationTextField;


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
    
    //set contents of pickerView
    self.locations = @[@"Customer Cage", @"Shared Cage", @"Recieving Dock", @"Other"];
    
    UIImage* logoImage = [UIImage imageNamed:@"navBarLogo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
     [self.navigationItem.titleView setCenter:self.navigationItem.titleView.center];
    
    
    //Creates a bottom border of navigationBar that has a orange color
    UIColor *orange = [UIColor colorWithRed:240/255. green:119/255. blue:36/255. alpha:1];
    
     UINavigationBar* navigationBar = self.navigationController.navigationBar;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,navigationBar.frame.size.height-1,navigationBar.frame.size.width, 2)];
   
    [navBorder setBackgroundColor:orange];
    [navigationBar addSubview:navBorder];
    
    //set border color to the theme orange
    self.locationButton.layer.borderColor = orange.CGColor;
    self.submitButton.layer.borderColor = orange.CGColor;
    self.selectButton.layer.borderColor = orange.CGColor;
    
    [[UITabBar appearance] setTintColor:orange];
}

-(void)viewWillAppear:(BOOL)animated{
    //set timeStamp to current date and time
}

#pragma mark - Location Picker DataSource

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

#pragma mark - Text editing methods. Resigning textField, Clear Button, Dismiss Keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)clearButtonTapped:(id)sender {
    self.trackingNumberTextField.text = @"";
    self.optionalLocationTextField.text = @"";
    [self.locationButton setTitle:@"Select Location" forState:UIControlStateNormal];
    [self.optionalLocationTextField setHidden:YES];
    [self.view setNeedsDisplay];
}
-(void)dismissKeyboard {
    
    [self.trackingNumberTextField resignFirstResponder];
    [self.optionalLocationTextField resignFirstResponder];
    [self.trackingNumberTextField resignFirstResponder];
}

#pragma mark - Location view animation/selection methods

- (IBAction)selectLocation:(id)sender {
    self.pickerView.hidden = NO;
    [self.locationButton setEnabled:NO];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.fromValue = @(self.pickerView.center.y);
    animation.toValue = @(self.pickerView.center.y - 280);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.pickerView.layer addAnimation:animation forKey:@"moveUpAnimation"];
    self.pickerView.layer.position = CGPointMake(self.pickerView.layer.position.x, self.pickerView.layer.position.y - 280);
    
}

- (IBAction)pickerDoneButtonPressed:(id)sender {
    [self.locationButton setEnabled:YES];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.fromValue = @(self.pickerView.center.y);
    animation.toValue = @(self.pickerView.center.y + 280);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.pickerView.layer addAnimation:animation forKey:@"moveDownAnimation"];
    self.pickerView.layer.position = CGPointMake(self.pickerView.layer.position.x, self.pickerView.layer.position.y +280);
    
    //grab the index that is currently selected by the locationPicker
   
    NSInteger selectedLocation = [self.locationPicker selectedRowInComponent:0];
    
    if ([self.locationButton.titleLabel.text isEqualToString:[self.locations objectAtIndex:selectedLocation]]) {
        return;
    } else {
        [self.locationButton setTitle:[self.locations objectAtIndex:selectedLocation] forState:UIControlStateNormal];
        [self.locationButton.titleLabel sizeToFit];
    }
    if ([[self.locations objectAtIndex:selectedLocation] isEqualToString:@"Other"]) {
        [self.optionalLocationTextField setHidden:NO];
    } else {
        [self.optionalLocationTextField setHidden:YES];
    }
}

#pragma mark - Save Button tasks

- (IBAction)saveButtonPressed:(id)sender {
    
    //check if a location has been selected
    if ([self.locationButton.titleLabel.text isEqualToString:@"Select Location"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Information" message:@"Please Select a Location" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDestructive handler:nil]];
        
        [self.tabBarController presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //grab the index that is currently selected by the locationPicker
    NSInteger selectedLocation = [self.locationPicker selectedRowInComponent:0];
    
    //grab the index that is currently selected by the segmentedControl
    NSInteger selectedSegment = [self.carrierSegmentedControl selectedSegmentIndex];

    //grab the data
    NSDate *timeStamp = [NSDate date];
    NSString *carrier =[self.carrierSegmentedControl titleForSegmentAtIndex:selectedSegment];
#warning add employee name
    NSString *employee = @"";//self.employeeLabel.text;
    NSString *trackingNum = self.trackingNumberTextField.text;
    NSString *location = [self.locations objectAtIndex:selectedLocation];
    NSString *subLocation = self.optionalLocationTextField.text;
    
    //save ticket to parse
    NewTicketController *newTicketController = [NewTicketController new];
    [newTicketController savePFObjectToParseWithTime:timeStamp andTrackingNumber:trackingNum andCarrier:carrier andEmployee:employee andLocation:location andSubLocation:subLocation];
    
    [self createEmailWithTicket:timeStamp andTrackingNumber:trackingNum andCarrier:carrier andEmployee:employee andLocation:location andSubLocation:subLocation];
    
    [self.optionalLocationTextField setHidden:YES];
    
    [self clearButtonTapped:sender];
}

#pragma mark - Email creation methods

- (void)createEmailWithTicket:(NSDate *)timeStamp andTrackingNumber:(NSString *)trackingNumber andCarrier:(NSString *)carrier
                  andEmployee:(NSString *)employee
                  andLocation:(NSString *)location
               andSubLocation:(NSString *)subLocation{
    
    //Create an email to send to c7.com
    // Email Subject
    NSString *emailTitle = [NSString stringWithFormat:@"Tracking #: %@",trackingNumber];
    
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:(@"Time Stamp: %@\n Carrier: %@\n Tracking #: %@\n Employee: %@\n Location: %@\n SubLocation: %@"),[self convertDatetoString:timeStamp],carrier,trackingNumber,employee,location,subLocation];
    
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@c7.com"];
    
    //Create email message
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    [self presentViewController:mc animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ticket Saved!" message:@"The Ticket was saved to the database" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self.tabBarController presentViewController:alert animated:YES completion:nil];
}

- (NSString *)convertDatetoString:(NSDate *)date{
    NSString *dateString;
    
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateStyle: NSDateFormatterMediumStyle];
    [format setTimeStyle: NSDateFormatterShortStyle];
    
    dateString =  [format stringFromDate:date];

    return dateString;
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
    NSInteger selectedSegment = [self.carrierSegmentedControl selectedSegmentIndex];
     
     ScanTrackingNumberViewController *scanTrackingNumberView = [segue destinationViewController];
     scanTrackingNumberView.carrier = [self.carrierSegmentedControl titleForSegmentAtIndex:selectedSegment];
 }

- (IBAction)unwindToNewTicketViewController:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"unwindToNewTicketView"]) {
        
        ScanTrackingNumberViewController *scanTrackingNumberView = segue.sourceViewController;
        self.trackingNumberTextField.text = scanTrackingNumberView.trackingNumberString;
        
    }
}
@end

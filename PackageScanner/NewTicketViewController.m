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

@interface NewTicketViewController ()<UIPickerViewDataSource, UIPickerViewDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *carrierSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;


@property (weak, nonatomic) IBOutlet UILabel *selectedLocation;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
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
    
    self.scanButton.layer.cornerRadius = 10;
    self.scanButton.clipsToBounds = YES;
    
    UIImage* logoImage = [UIImage imageNamed:@"navBarLogo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
     [self.navigationItem.titleView setCenter:self.navigationItem.titleView.center];
    
    
    //Creates a bottom border of navigationBar that has a orange color
    UIColor *orange = [UIColor colorWithRed:240/255. green:119/255. blue:36/255. alpha:1];
    
     UINavigationBar* navigationBar = self.navigationController.navigationBar;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,navigationBar.frame.size.height-1,navigationBar.frame.size.width, 2)];
   
    [navBorder setBackgroundColor:orange];
    [navigationBar addSubview:navBorder];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //set timeStamp
    self.timeStampLabel.text = [self convertDatetoString:[NSDate date]];
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
#pragma mark - Text editing methods. Resigning textField, Clear Button, Dismiss Keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)clearButtonTapped:(id)sender {
    self.trackingNumberTextField.text = @"";
    self.optionalLocationTextField.text = @"";
}
-(void)dismissKeyboard {
    
    [self.trackingNumberTextField resignFirstResponder];
    [self.optionalLocationTextField resignFirstResponder];
    [self.trackingNumberTextField resignFirstResponder];
}

- (IBAction)unwindToNewTicketViewController:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"unwindToNewTicketView"]) {
        
        ScanTrackingNumberViewController *scanTrackingNumberView = segue.sourceViewController;
        self.trackingNumberTextField.text = scanTrackingNumberView.trackingNumberString;
        
    }
}
- (IBAction)selectLocation:(id)sender {
    self.pickerView.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.fromValue = @(self.pickerView.center.y);
    animation.toValue = @(self.pickerView.center.y - 290);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.pickerView.layer addAnimation:animation forKey:@"moveUpAnimation"];
    self.pickerView.layer.position = CGPointMake(self.pickerView.layer.position.x, self.pickerView.layer.position.y - 290);
    
}
- (IBAction)pickerDoneButtonPressed:(id)sender {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.fromValue = @(self.pickerView.center.y);
    animation.toValue = @(self.pickerView.center.y + 290);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.pickerView.layer addAnimation:animation forKey:@"moveDownAnimation"];
    self.pickerView.layer.position = CGPointMake(self.pickerView.layer.position.x, self.pickerView.layer.position.y +290);
    
    //grab the index that is currently selected by the locationPicker
    NSInteger selectedLocation = [self.locationPicker selectedRowInComponent:0];
    self.selectedLocation.text = [self.locations objectAtIndex:selectedLocation];
    
}

#pragma mark - Save Button tasks

- (IBAction)saveButtonPressed:(id)sender {
    
    if ([self.selectedLocation.text isEqualToString:@""])
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
    NSString *employee = @"";//self.employeeLabel.text;
    NSString *trackingNum = self.trackingNumberTextField.text;
    NSString *location = [self.locations objectAtIndex:selectedLocation];
    NSString *subLocation = self.optionalLocationTextField.text;
    
    //save ticket to parse
    NewTicketController *newTicketController = [NewTicketController new];
    [newTicketController savePFObjectToParseWithTime:timeStamp andTrackingNumber:trackingNum andCarrier:carrier andEmployee:employee andLocation:location andSubLocation:subLocation];
    
    [self createEmailWithTicket:timeStamp andTrackingNumber:trackingNum andCarrier:carrier andEmployee:employee andLocation:location andSubLocation:subLocation];
        
    // Present mail view controller on screen
    
    
    //push an alert that tells the user the object was saved.
    
    [self clearButtonTapped:sender];
    
    
}

- (void)createEmailWithTicket:(NSDate *)timeStamp andTrackingNumber:(NSString *)trackingNumber andCarrier:(NSString *)carrier andEmployee:(NSString *)employee andLocation:(NSString *)location andSubLocation:(NSString *)subLocation{
    
    //Create an email to send to c7.com
    // Email Subject
    NSString *emailTitle = [NSString stringWithFormat:@"Tracking #: %@",trackingNumber];
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:(@"Time Stamp: %@\n Carrier: %@\n Tracking #: %@\n Employee: %@\n Location: %@\n SubLocation: %@"),[self convertDatetoString:timeStamp],carrier,trackingNumber,employee,location,subLocation];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@c7.com"];
    
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


@end

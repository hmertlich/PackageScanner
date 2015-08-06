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

@import AVFoundation;
@interface NewTicketViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UITextField *toAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromAddressTextField;

@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *employeeTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation NewTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
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
    self.toAddressTextField.text = @"";
    self.fromAddressTextField.text = @"";
    self.trackingNumberTextField.text = @"";
    self.locationTextField.text = @"";
    self.employeeTextField.text = @"";
    self.datePicker.date = [NSDate date];
}

- (IBAction)unwindToNewTicketViewController:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"unwindToNewTicketView"]) {
        
        ScanTrackingNumberViewController *scanTrackingNumberView = segue.sourceViewController;
        self.trackingNumberTextField.text = scanTrackingNumberView.trackingNumberString;
        
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    
    if ([self.toAddressTextField.text isEqualToString:@""] ||
        [self.fromAddressTextField.text isEqualToString:@""] ||
        [self.employeeTextField.text isEqualToString:@""] ||
        [self.locationTextField.text isEqualToString:@""] ||
        [self.trackingNumberTextField.text isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Information" message:@"Please make sure all fields are entered" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDestructive handler:nil]];
        
        [self.tabBarController presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    PFObject *newTicket = [PFObject objectWithClassName:@"Ticket"];
    newTicket[@"ToAddress"] = self.toAddressTextField.text;
    newTicket[@"FromAddress"] = self.fromAddressTextField.text;
    newTicket[@"createdAt"] = self.datePicker.date;
    newTicket[@"Employee"] = self.employeeTextField.text;
    newTicket[@"Location"] = self.locationTextField.text;
    newTicket[@"TrackingNumber"] = self.trackingNumberTextField.text;
    
    
    [self clearButtonTapped:sender];
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

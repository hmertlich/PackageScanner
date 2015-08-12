//
//  UpdateTicketViewController.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/28/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "UpdateTicketViewController.h"
#import "Ticket.h"

@interface UpdateTicketViewController ()

@property (weak, nonatomic) IBOutlet UILabel *updateTimeStampLabel;
@property (weak, nonatomic) IBOutlet UITextField *toAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromAddressTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (weak, nonatomic) IBOutlet UITextField *subLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *employeeTextField;
@property (weak, nonatomic) IBOutlet UITextField *trackingNumberTextField;


@end

@implementation UpdateTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clearButtonPressed:(id)sender {
    self.toAddressTextField.text = @"";
    self.fromAddressTextField.text = @"";
    self.trackingNumberTextField.text = @"";
    self.subLocationTextField.text = @"";
    self.employeeTextField.text = @"";
    self.updateTimeStampLabel.text = [self convertDatetoString:[NSDate date]];
}
-(NSString *)convertDatetoString:(NSDate *)date{
    NSString *dateString;
    
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateStyle: NSDateFormatterMediumStyle];
    [format setTimeStyle: NSDateFormatterShortStyle];
    
    dateString =  [format stringFromDate:date];
    return dateString;
    
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

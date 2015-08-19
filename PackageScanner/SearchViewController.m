//
//  SearchViewController.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/25/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsViewController.h"
#import "SearchViewDataSource.h"
#import "SearchViewDataSourceController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *trackingNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.searchButton setEnabled:YES];
    
    self.datePicker.maximumDate = [NSDate date];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.datePickerMode = daylight;
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
- (IBAction)searchButtonPressed:(id)sender {
    [self.searchButton setEnabled:NO];

    //creates a loading indicator
    self.activityIndicator.center=self.view.center;
    
    [self.activityIndicator startAnimating];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(handleSearchTimeout:) userInfo:nil repeats:NO];
    
    NSDate *timeStamp = self.datePicker.date;
    timeStamp = [self dateAtBeginningOfDayForDate:timeStamp];
    
    [[SearchViewDataSourceController sharedInstance]queryParseWithDate:timeStamp andTrackingNumber:self.trackingNumberTextField.text withCompletion:^{
        [timer invalidate];
#pragma warning -need to check if query is complete, then send segue.
        [self performSegueWithIdentifier:@"searchResultsSegue" sender:self];
        [self.activityIndicator stopAnimating];
        
    }];
    
   
}

- (void)handleSearchTimeout:(NSTimer *)aTimer {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Poor Connection" message:@"Please Check Your Connection" preferredStyle:UIAlertControllerStyleAlert];
    
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDestructive handler:nil]];
        [self.tabBarController presentViewController:alert animated:YES completion:nil];
        [self.searchButton setEnabled:YES];
        [self.activityIndicator stopAnimating];
}

- (IBAction)clearButtonTapped:(id)sender {
    self.trackingNumberTextField.text = @"";
    self.datePicker.date = [NSDate date];
}

-(void)dismissKeyboard {
   
    [self.trackingNumberTextField resignFirstResponder];
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSString *)convertDatetoString:(NSDate *)date{
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

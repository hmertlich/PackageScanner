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
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *selectDateButton;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UIImage* logoImage = [UIImage imageNamed:@"navBarLogo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    //Creates a bottom border of navigationBar that has a orange color
    UIColor *orange = [UIColor colorWithRed:240/255. green:119/255. blue:36/255. alpha:1];
    
    UINavigationBar* navigationBar = self.navigationController.navigationBar;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,navigationBar.frame.size.height-1,navigationBar.frame.size.width, 2)];
    
    [navBorder setBackgroundColor:orange];
    [navigationBar addSubview:navBorder];
    
    //set button border color to theme orange
    self.clearButton.layer.borderColor = orange.CGColor;
    self.dateButton.layer.borderColor = orange.CGColor;
    self.selectDateButton.layer.borderColor = orange.CGColor;
    
    self.datePicker.tintColor = [UIColor colorWithRed:77/255. green:77/255. blue:77/255. alpha:1];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

-(void)dismissKeyboard {
    
    [self.trackingNumberTextField resignFirstResponder];
}

- (IBAction)clearButtonTapped:(id)sender {
    self.trackingNumberTextField.text = @"";
    self.datePicker.date = [NSDate date];
    [self.dateButton setTitle:@"Select Date" forState:UIControlStateNormal];
}

- (IBAction)selectDateButtonPressed:(id)sender {
    self.dateView.hidden = NO;
    [self.dateButton setEnabled:NO];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.fromValue = @(self.dateView.center.y);
    animation.toValue = @(self.dateView.center.y - 310);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.datePicker.layer addAnimation:animation forKey:@"moveUpAnimation"];
    self.dateView.layer.position = CGPointMake(self.dateView.layer.position.x, self.dateView.layer.position.y - 310);
}

- (IBAction)dateSelectButtonPressed:(id)sender {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.fromValue = @(self.dateView.center.y);
    animation.toValue = @(self.dateView.center.y + 310);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.dateView.layer addAnimation:animation forKey:@"moveDownAnimation"];
    self.dateView.layer.position = CGPointMake(self.dateView.layer.position.x, self.dateView.layer.position.y + 310);
    
    NSString *dateString;
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateStyle: NSDateFormatterLongStyle];
    dateString = [format stringFromDate:self.datePicker.date];
    
    [self.dateButton setTitle:dateString forState:UIControlStateNormal];
    [self.dateButton.titleLabel sizeToFit];
    [self.dateButton setEnabled:YES];
}

- (IBAction)searchButtonPressed:(id)sender {
    [self.searchButton setEnabled:NO];
    
    [self.activityIndicator startAnimating];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(handleSearchTimeout:) userInfo:nil repeats:NO];
    
    NSDate *timeStamp = self.datePicker.date;
    timeStamp = [self dateAtBeginningOfDayForDate:timeStamp];
    
    [[SearchViewDataSourceController sharedInstance]queryParseWithDate:timeStamp andTrackingNumber:self.trackingNumberTextField.text withCompletion:^{
        [timer invalidate];
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

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Converts the date components (year, month, day) of the input date
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
    
    dateString = [format stringFromDate:date];
    
    return dateString;
    
}

@end

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
#pragma error-Check the tracking text info.

//    if ([self.trackingNumberTextField.text isEqualToString:@""]) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Information" message:@"Please Make Sure Tracking # Is Entered" preferredStyle:UIAlertControllerStyleAlert];
//        
//        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDestructive handler:nil]];
//        
//        [self.tabBarController presentViewController:alert animated:YES completion:nil];
//        [self.searchButton setEnabled:YES];
//        return;
//
//    }

    //creates a loading indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=self.view.center;
    
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
     NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(handleSearchTimeout:) userInfo:nil repeats:NO];
    
        [[SearchViewDataSourceController sharedInstance]queryAllTicketDataWithDate:self.datePicker.date andTrackingNumber:self.trackingNumberTextField.text withCompletion:^{
        
            [timer invalidate];
            
            [self performSegueWithIdentifier:@"searchResultsSegue" sender:self];
            
            [activityIndicator stopAnimating];
    }];
        
    
   
}
- (void)handleSearchTimeout:(NSTimer *)aTimer {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Poor Connection" message:@"Please Check Your Connection" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDestructive handler:nil]];
    [self.tabBarController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)clearButtonTapped:(id)sender {
    self.trackingNumberTextField.text = @"";
    self.datePicker.date = [NSDate date];
}

-(void)dismissKeyboard {
   
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

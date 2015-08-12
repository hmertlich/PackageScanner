//
//  DetailTicketViewController.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/28/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "DetailTicketViewController.h"

@interface DetailTicketViewController ()


@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *whoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carrierLabel;

@end

@implementation DetailTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateWithTicket:self.ticket];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateWithTicket:(Ticket *)ticket{
    
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *timeStamp = [[self.ticket objectForKey:@"TimeStamp"] dateByAddingTimeInterval:timeZoneSeconds+21600];
    
    self.carrierLabel.text = [self.ticket objectForKey:@"Carrier"];
    self.locationLabel.text = [self.ticket objectForKey:@"Location"];
    self.subLocationLabel.text = [self.ticket objectForKey:@"SubLocation"];
    self.whoLabel.text = [self.ticket objectForKey:@"Employee"];
    self.dateLabel.text = [self convertDatetoString:timeStamp];
    self.trackingNumberLabel.text = [self.ticket objectForKey:@"TrackingNumber"];

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

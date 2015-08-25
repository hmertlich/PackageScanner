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
    
    UIImage* logoImage = [UIImage imageNamed:@"navBarLogo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    //Creates a bottom border of navigationBar that has a orange color
    UIColor *orange = [UIColor colorWithRed:240/255. green:119/255. blue:36/255. alpha:1];
    
    UINavigationBar* navigationBar = self.navigationController.navigationBar;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,navigationBar.frame.size.height-1,navigationBar.frame.size.width, 2)];
    
    [navBorder setBackgroundColor:orange];
    [navigationBar addSubview:navBorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateWithTicket:(Ticket *)ticket{
    
    NSDate *timeStamp = [self.ticket objectForKey:@"TimeStamp"];
    
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

@end

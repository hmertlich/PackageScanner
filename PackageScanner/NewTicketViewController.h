//
//  NewTicketViewController.h
//  PackageScanner
//
//  Created by Skyler Tanner on 7/25/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "ScanTrackingNumberViewController.h"

@interface NewTicketViewController : UIViewController

//creates an entry Instance of an Entry.
@property (strong, nonatomic) Ticket *ticket;

@property (weak, nonatomic) IBOutlet UITextField *trackingNumberTextField;

@end

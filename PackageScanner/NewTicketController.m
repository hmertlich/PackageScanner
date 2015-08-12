//
//  NewTicketController.m
//  PackageScanner
//
//  Created by Skyler Tanner on 8/11/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "NewTicketController.h"
#import "NewTicketViewController.h"
#import <Parse/Parse.h>

@interface NewTicketController() 

@end

@implementation NewTicketController


- (void)savePFObjectToParseWithTime:(NSDate *)timeStamp andTrackingNumber:(NSString *)trackingNumber andCarrier:(NSString *)carrier andEmployee:(NSString *)employee andLocation:(NSString *)location andSubLocation:(NSString *)subLocation{
    
    //Create a object to be stored.
    PFObject *newTicket = [PFObject objectWithClassName:[Ticket parseClassName]];
    newTicket[@"TimeStamp"] = timeStamp;
    newTicket[@"Carrier"] = carrier;
    newTicket[@"Employee"] = employee;
    newTicket[@"Location"] = location;
    newTicket[@"SubLocation"] = subLocation;
    newTicket[@"TrackingNumber"] = trackingNumber;
    [newTicket saveInBackground];
    
}


@end

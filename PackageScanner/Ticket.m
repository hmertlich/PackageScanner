//
//  Ticket.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/26/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

//@dynamic tells compiler to use parse for getter and setter methods
@dynamic timeStamp;
@dynamic toAddress;
@dynamic fromAddress;
@dynamic location;
@dynamic employee;
@dynamic trackingNumber;


-(NSString *)convertDatetoString:(NSDate *)date{
    NSString *dateString;
    
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateStyle: NSDateFormatterMediumStyle];
    [format setTimeStyle: NSDateFormatterShortStyle];
    
    dateString =  [format stringFromDate:date];
    return dateString;
    
}

@end

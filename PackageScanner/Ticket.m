//
//  Ticket.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/26/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "Ticket.h"
#import <Parse/PFObject+Subclass.h>

@implementation Ticket

+ (void)load {
    [self registerSubclass];
}
//@dynamic tells compiler to use parse for getter and setter methods
@dynamic timeStamp;
@dynamic employee;
@dynamic location;
@dynamic trackingNumber;

+ (NSString *)parseClassName {
    return @"Ticket";
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        if (dictionary[@"TimeStamp"]) {
            self.timeStamp = dictionary[@"TimeStamp"];
        }
        if (dictionary[@"Employee"]) {
            self.employee = dictionary[@"Employee"];
        }
        if (dictionary[@"Location"]) {
            self.location = dictionary[@"Location"];
        }
        if (dictionary[@"TrackingNumber"]) {
            self.trackingNumber = dictionary[@"TrackingNumber"];
        }
    }
    return self;
}

-(NSString *)convertDatetoString:(NSDate *)date{
    NSString *dateString;
    
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateStyle: NSDateFormatterMediumStyle];
    [format setTimeStyle: NSDateFormatterShortStyle];
    
    dateString =  [format stringFromDate:date];
    return dateString;
    
}

@end

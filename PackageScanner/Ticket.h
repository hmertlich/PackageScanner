//
//  Ticket.h
//  PackageScanner
//
//  Created by Skyler Tanner on 7/26/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Ticket : NSObject

@property (strong, nonatomic) NSDate *timeStamp;
@property (strong, nonatomic) NSString *toAddress;
@property (strong, nonatomic) NSString *fromAddress;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *employee;
@property (strong, nonatomic) NSString *trackingNumber;

-(NSString*)convertDatetoString:(NSDate*)date;


@end

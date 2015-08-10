//
//  Ticket.h
//  PackageScanner
//
//  Created by Skyler Tanner on 7/26/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Ticket : PFObject<PFSubclassing>

@property (strong, nonatomic) NSDate *timeStamp;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *employee;
@property (retain) NSString *trackingNumber;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSString*)convertDatetoString:(NSDate*)date;
+ (NSString *)parseClassName;

@end

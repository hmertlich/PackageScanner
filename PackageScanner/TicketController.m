//
//  TicketController.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/27/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "TicketController.h"
@interface TicketController()

@property (strong, nonatomic)NSArray *tickets;

@end
@implementation TicketController 

+ (TicketController*)sharedInstance{
    static TicketController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [TicketController new];
        sharedInstance.tickets = [NSArray new];
    });
    return sharedInstance;
}

+(void)removeTicket:(Ticket *)ticket{
    
}
@end

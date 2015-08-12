//
//  TicketController.h
//  PackageScanner
//
//  Created by Skyler Tanner on 7/27/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"

@interface TicketController : NSObject

@property (strong, nonatomic, readonly)NSArray *tickets;

//Read(Singleton)
+ (TicketController *)sharedInstance;

//Remove
+(void) removeTicket:(Ticket *)ticket;


@end

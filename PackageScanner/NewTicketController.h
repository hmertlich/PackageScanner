//
//  NewTicketController.h
//  PackageScanner
//
//  Created by Skyler Tanner on 8/11/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewTicketViewController.h"

@interface NewTicketController : NSObject 

- (void)savePFObjectToParseWithTime:(NSDate *)timeStamp andTrackingNumber:(NSString *)trackingNumber andCarrier:(NSString *)carrier andEmployee:(NSString *)employee andLocation:(NSString *)location andSubLocation:(NSString *)subLocation;

@end

//
//  SearchViewDataSourceController.h
//  PackageScanner
//
//  Created by Skyler Tanner on 8/6/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"

@interface SearchViewDataSourceController : NSObject

@property (strong,nonatomic) NSMutableArray *searchResults;

+ (SearchViewDataSourceController*)sharedInstance;

- (void)queryParseWithDate:(NSDate *)date andTrackingNumber:(NSString *)trackingNumber withCompletion:(void (^)(void))completion;


@end

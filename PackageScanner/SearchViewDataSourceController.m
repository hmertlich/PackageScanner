//
//  SearchViewDataSourceController.m
//  PackageScanner
//
//  Created by Skyler Tanner on 8/6/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "SearchViewDataSourceController.h"

@interface SearchViewDataSourceController()


@end
@implementation SearchViewDataSourceController

+ (SearchViewDataSourceController*)sharedInstance{
    static SearchViewDataSourceController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SearchViewDataSourceController new];
        sharedInstance.searchResults = [NSMutableArray new];
    });
    return sharedInstance;
}

- (void)queryAllTicketDataWithDate:(NSDate *)date andTrackingNumber:(NSString *)trackingNumber withCompletion:(void (^)(void))completion{
    NSDate *date2 = [date dateByAddingTimeInterval:-1*24*60*60];
    
    PFQuery *getTickets = [PFQuery queryWithClassName:[Ticket parseClassName]];
    [getTickets whereKey:@"TimeStamp" greaterThanOrEqualTo:date2];
    [getTickets whereKey:@"TimeStamp" lessThanOrEqualTo:date];
//    [getTickets whereKey:@"TrackingNumber" containsString:trackingNumber];
    [getTickets orderByAscending:@"TimeStamp"];
    [getTickets findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error){
        NSLog(@"%@",results);
        
        [SearchViewDataSourceController sharedInstance].searchResults = [results mutableCopy];
        completion();
    }];

}
@end

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
    
    NSDate *endOfDay = [self dateAtEndOfDayForDate:date];
    NSDate *beginningOfDay = [self dateAtBeginningOfDayForDate:date];
    
    PFQuery *getTickets = [PFQuery queryWithClassName:[Ticket parseClassName]];
    [getTickets whereKey:@"TimeStamp" greaterThan:beginningOfDay];
    [getTickets whereKey:@"TimeStamp" lessThan:endOfDay];
//    [getTickets whereKey:@"TrackingNumber" containsString:trackingNumber];
    [getTickets orderByAscending:@"TimeStamp"];
    [getTickets findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error){
        NSLog(@"%@",results);
        
        [SearchViewDataSourceController sharedInstance].searchResults = [results mutableCopy];
        completion();
    }];

}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateAtEndOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:23];
    [dateComps setMinute:59];
    [dateComps setSecond:59];
    
    // Convert back
    NSDate *endOfDay = [calendar dateFromComponents:dateComps];
    return endOfDay;
}

- (NSString *)convertDatetoString:(NSDate *)date{
    NSString *dateString;
    
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateStyle: NSDateFormatterMediumStyle];
    [format setTimeStyle: NSDateFormatterShortStyle];
    
    dateString =  [format stringFromDate:date];
    
    return dateString;
    
}
@end

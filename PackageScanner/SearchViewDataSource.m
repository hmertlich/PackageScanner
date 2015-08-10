//
//  SearchViewDataSource.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/28/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "SearchViewDataSource.h"
#import "TicketController.h"
#import "SearchViewDataSourceController.h"

@implementation SearchViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [SearchViewDataSourceController sharedInstance].searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    }
    
    Ticket *ticket = [[Ticket alloc]initWithDictionary:[[SearchViewDataSourceController sharedInstance].searchResults objectAtIndex:indexPath.row]];
    
    NSString *ticketDate = [ticket convertDatetoString:ticket.timeStamp];
    
    cell.detailTextLabel.text = ticketDate;
    cell.textLabel.text = ticket.trackingNumber;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Ticket *ticket = [[SearchViewDataSourceController sharedInstance].searchResults objectAtIndex:indexPath.row];
            [ticket deleteInBackground];
            [[SearchViewDataSourceController sharedInstance].searchResults removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        
    }
    
    
}

@end

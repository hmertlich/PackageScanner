//
//  SearchViewDataSource.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/28/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "SearchViewDataSource.h"
#import "TicketController.h"

@implementation SearchViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TicketController sharedInstance].tickets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    Ticket *ticket = [TicketController sharedInstance].tickets[indexPath.row];
    
    NSString *ticketTitle = ticket.fromAddress;
    NSString *ticketDate = [ticket convertDatetoString:ticket.timeStamp];
    
    cell.textLabel.text = ticketTitle;
    cell.detailTextLabel.text = ticketDate;
    
    return cell;
}

@end

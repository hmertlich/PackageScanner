//
//  SearchResultsViewController.m
//  PackageScanner
//
//  Created by Skyler Tanner on 7/28/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "Ticket.h"
#import "TicketController.h"
#import "DetailTicketViewController.h"
#import "SearchViewDataSourceController.h"


@interface SearchResultsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //reloads this tableView everytime it appears.
    [self.tableView reloadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"detailTicketView"]) {
        
        //creates a index path that is equal to the cell that is selected.
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        //specifies an instance of the view we are segueing to.
        DetailTicketViewController *detailTicketViewController = segue.destinationViewController;
        
        //creates a new entry and sets it to the sharedInstance classes --> entries array --> index where the user clicked on this tableView.
         Ticket *ticket =[SearchViewDataSourceController sharedInstance].searchResults[path.row];
        
        //sets the detailViewController instances entry = to the entry that was selected.
        detailTicketViewController.ticket = ticket;
        
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

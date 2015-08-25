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

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage* logoImage = [UIImage imageNamed:@"navBarLogo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    //Creates a bottom border of navigationBar that has a orange color
    UIColor *orange = [UIColor colorWithRed:240/255. green:119/255. blue:36/255. alpha:1];
    
    UINavigationBar* navigationBar = self.navigationController.navigationBar;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,navigationBar.frame.size.height-1,navigationBar.frame.size.width, 2)];
    
    [navBorder setBackgroundColor:orange];
    [navigationBar addSubview:navBorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //reloads this tableView everytime it appears.
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"detailTicketViewSegue"]) {
        
        //creates a index path that is equal to the cell that is selected.
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        //specifies an instance of the view we are segueing to.
        DetailTicketViewController *detailTicketViewController = segue.destinationViewController;
        
        //creates a new ticket and sets it to the sharedInstance classes --> searchResults array --> index where the user clicked on this tableView.
         Ticket *ticket =[SearchViewDataSourceController sharedInstance].searchResults[path.row];
        
        //sets the detailViewController instances ticket = to the ticket that was selected.
        detailTicketViewController.ticket = ticket;
    }
}

@end

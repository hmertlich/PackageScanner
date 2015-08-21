//
//  AppearanceController.m
//  PackageScanner
//
//  Created by Skyler Tanner on 8/20/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "AppearanceController.h"

@implementation AppearanceController

+ (void)initializeAppearanceDefaults:(UINavigationController *)navigationController
{
//sets logo in navigation bar
    UIImage* logoImage = [UIImage imageNamed:@"navBarLogo"];
    navigationController.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    [navigationController.navigationItem.titleView setCenter:navigationController.navigationItem.titleView.center];

//Creates a bottom border of navigationBar that has a orange color
    UIColor *orange = [UIColor colorWithRed:240/255. green:119/255. blue:36/255. alpha:1];

    UINavigationBar* navigationBar = navigationController.navigationController.navigationBar;

    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,navigationBar.frame.size.height-1,navigationBar.frame.size.width, 2)];

    [navBorder setBackgroundColor:orange];
    [navigationBar addSubview:navBorder];

}
@end

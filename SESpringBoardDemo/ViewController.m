//
//  ViewController.m
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//

#import "ViewController.h"
#import "ChildViewController.h"
#import "SESpringBoard.h"


@implementation ViewController

@synthesize vc1, vc2;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vc1 = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:nil];
    vc2 = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:nil];
    // Create or reference more view controllers here
	// ...
    
    
    // Create an array of SEMenuItem objects
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[SEMenuItem menuItemWithTitle:@"facebook" image:[UIImage imageNamed:@"facebook"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"twitter" image:[UIImage imageNamed:@"facebook"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"youtube" image:[UIImage imageNamed:@"facebook"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"linkedin" image:[UIImage imageNamed:@"facebook"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"rss" image:[UIImage imageNamed:@"facebook"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"google" image:[UIImage imageNamed:@"google"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"stumbleupon" image:[UIImage imageNamed:@"su"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"digg" image:[UIImage imageNamed:@"digg"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"technorati" image:[UIImage imageNamed:@"technorati"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"facebook" image:[UIImage imageNamed:@"facebook"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"twitter" image:[UIImage imageNamed:@"twitter"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"youtube" image:[UIImage imageNamed:@"youtube"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"linkedin" image:[UIImage imageNamed:@"linkedin"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"rss" image:[UIImage imageNamed:@"rss"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"google" image:[UIImage imageNamed:@"google"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"stumbleupon" image:[UIImage imageNamed:@"su"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"digg" image:[UIImage imageNamed:@"digg"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"technorati" image:[UIImage imageNamed:@"technorati"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"facebook" image:[UIImage imageNamed:@"facebook"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"twitter" image:[UIImage imageNamed:@"twitter"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"youtube" image:[UIImage imageNamed:@"youtube"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"linkedin" image:[UIImage imageNamed:@"linkedin"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"rss" image:[UIImage imageNamed:@"rss"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"google" image:[UIImage imageNamed:@"google"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"stumbleupon" image:[UIImage imageNamed:@"su"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"digg" image:[UIImage imageNamed:@"digg"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"technorati" image:[UIImage imageNamed:@"technorati"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"facebook" image:[UIImage imageNamed:@"facebook"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"twitter" image:[UIImage imageNamed:@"twitter"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"youtube" image:[UIImage imageNamed:@"youtube"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"linkedin" image:[UIImage imageNamed:@"linkedin"] andViewController:vc2]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"rss" image:[UIImage imageNamed:@"rss"] andViewController:vc1]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"google" image:[UIImage imageNamed:@"google"] andViewController:vc2]];
//    [items addObject:[SEMenuItem menuItemWithTitle:@"stumbleupon" image:[UIImage imageNamed:@"su"] andViewController:vc1]];
//    [items addObject:[SEMenuItem menuItemWithTitle:@"digg" image:[UIImage imageNamed:@"digg"] andViewController:vc2]];
//    [items addObject:[SEMenuItem menuItemWithTitle:@"technorati" image:[UIImage imageNamed:@"technorati"] andViewController:vc1]];
    
    // Pass the array to a newly created SESpringBoard and add it to your view.
    // The launcher image is the image for the button on the top left corner of the view controller that is gonna appear in the screen
    // after a SEMenuItem is tapped. It is used for going back to the home screen
    
    SESpringBoard *board = [[SESpringBoard alloc] initWithTitle:@"Welcome" items:items andLauncherImage:[UIImage imageNamed:@"navbtn_home.png"]];

//    board.itemRectForRetinaDisplay = CGRectMake(30, 30, 100, 100);
    [self.view addSubview:board];
}

@end

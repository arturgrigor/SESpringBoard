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
    [items addObject:[SEMenuItem menuItemWithTitle:@"facebook" image:[UIImage imageNamed:@"facebook"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"twitter" image:[UIImage imageNamed:@"facebook"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"youtube" image:[UIImage imageNamed:@"facebook"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"linkedin" image:[UIImage imageNamed:@"facebook"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"rss" image:[UIImage imageNamed:@"facebook"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"google" image:[UIImage imageNamed:@"google"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"stumbleupon" image:[UIImage imageNamed:@"su"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"digg" image:[UIImage imageNamed:@"digg"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"technorati" image:[UIImage imageNamed:@"technorati"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"facebook" image:[UIImage imageNamed:@"facebook"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"twitter" image:[UIImage imageNamed:@"twitter"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"youtube" image:[UIImage imageNamed:@"youtube"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"linkedin" image:[UIImage imageNamed:@"linkedin"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"rss" image:[UIImage imageNamed:@"rss"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"google" image:[UIImage imageNamed:@"google"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"stumbleupon" image:[UIImage imageNamed:@"su"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"digg" image:[UIImage imageNamed:@"digg"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"technorati" image:[UIImage imageNamed:@"technorati"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"facebook" image:[UIImage imageNamed:@"facebook"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"twitter" image:[UIImage imageNamed:@"twitter"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"youtube" image:[UIImage imageNamed:@"youtube"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"linkedin" image:[UIImage imageNamed:@"linkedin"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"rss" image:[UIImage imageNamed:@"rss"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"google" image:[UIImage imageNamed:@"google"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"stumbleupon" image:[UIImage imageNamed:@"su"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"digg" image:[UIImage imageNamed:@"digg"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"technorati" image:[UIImage imageNamed:@"technorati"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"facebook" image:[UIImage imageNamed:@"facebook"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"twitter" image:[UIImage imageNamed:@"twitter"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"youtube" image:[UIImage imageNamed:@"youtube"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"linkedin" image:[UIImage imageNamed:@"linkedin"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"rss" image:[UIImage imageNamed:@"rss"]]];
    [items addObject:[SEMenuItem menuItemWithTitle:@"google" image:[UIImage imageNamed:@"google"]]];
//    [items addObject:[SEMenuItem menuItemWithTitle:@"stumbleupon" image:[UIImage imageNamed:@"su"]]];
//    [items addObject:[SEMenuItem menuItemWithTitle:@"digg" image:[UIImage imageNamed:@"digg"]]];
//    [items addObject:[SEMenuItem menuItemWithTitle:@"technorati" image:[UIImage imageNamed:@"technorati"]]];
    
    // Pass the array to a newly created SESpringBoard and add it to your view.
    // The launcher image is the image for the button on the top left corner of the view controller that is gonna appear in the screen
    // after a SEMenuItem is tapped. It is used for going back to the home screen
    
    SESpringBoard *board = [[SESpringBoard alloc] initWithTitle:@"Welcome" items:items andDelegate:self];

    board.itemSize = CGSizeMake(50, 50);
    board.numberOfItemsVertically = 5;
    board.numberOfItemsHorizontally = 3;
    board.itemLabelColor = [UIColor whiteColor];
    
    [self.view addSubview:board];
}

#pragma mark - Spring Board Delegate Methods

- (void)springBoard:(id)aSpringBoard didSelectItemWithTag:(NSUInteger)tag
{
    UIViewController *viewController = ((tag % 2 == 0) ? self.vc1 : self.vc2);
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.view addSubview:navigationController.view];
    [navigationController release];
}

@end

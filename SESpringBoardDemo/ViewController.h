//
//  ViewController.h
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SESpringBoard.h"

@interface ViewController : UIViewController<SESpringBoardDelegate>

@property(nonatomic, retain) UIViewController *vc1;
@property(nonatomic, retain) UIViewController *vc2;

@end

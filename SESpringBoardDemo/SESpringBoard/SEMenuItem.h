//
//  SEMenuItem.h
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//
//  Modified by Artur Grigor on 21/01/12.
//

#import <UIKit/UIKit.h>

#import "SEViewController.h"

@interface SEMenuItem : NSObject {
    UIImage *image;
    NSString *title;
    NSUInteger badge;
    SEViewController *viewController;
    
    NSUInteger tag;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSUInteger badge;
@property (nonatomic, retain) SEViewController *viewController;

@property (nonatomic, assign) NSUInteger tag;

- (id)initWithTitle:(NSString *)aTitle image:(UIImage *)aImage andViewController:(SEViewController *)aViewController;
+ (SEMenuItem *)menuItemWithTitle:(NSString *)aTitle image:(UIImage *)aImage andViewController:(SEViewController *)aViewController;

@end
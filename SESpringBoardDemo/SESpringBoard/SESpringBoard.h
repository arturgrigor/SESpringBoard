//
//  SESpringBoard.h
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//
//  Modified by Artur Grigor on 21/01/12.
//

#import <UIKit/UIKit.h>

#import "SEMenuItem.h"

#define kItemLabelTopMargin         2.f
#define kItemLabelHeight            16.f

#define kTopBarHeight               44.f
#define kPageControlHeight          20.f
#define kPageControlTopMargin       27.f

#define kNotificationNameCloseView  @"closeView"

@interface SESpringBoard : UIView<UIScrollViewDelegate>
{
    int displayScale;
    
    NSString *title;
    UIImage *launcherImage;
    NSMutableArray *items;
    
    NSUInteger numberOfItemsHorizontally;
    NSUInteger numberOfItemsVertically;
    
    CGSize itemSize;
    UIColor *itemLabelColor;
    UIColor *itemLabelShadowColor;
    CGPoint itemLabelShadowOffset;
    
    UIView *topBar;
    UILabel *topBarTitleLabel;
    UINavigationController *navigationController;
    UIScrollView *itemsContainer;
    UIPageControl *pageControl;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIImage *launcherImage;
@property (nonatomic, retain) NSMutableArray *items;

@property (nonatomic, retain) UIColor *itemLabelColor;
@property (nonatomic, retain) UIColor *itemLabelShadowColor;
@property (nonatomic, assign) CGPoint itemLabelShadowOffset;

@property (nonatomic, assign) NSUInteger numberOfItemsHorizontally;
@property (nonatomic, assign) NSUInteger numberOfItemsVertically;
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, readonly) UIView *topBar;
@property (nonatomic, readonly) UILabel *topBarTitleLabel;
@property (nonatomic, readonly) UIScrollView *itemsContainer;
@property (nonatomic, retain) UIPageControl *pageControl;

- (id)initWithTitle:(NSString *)aTitle items:(NSMutableArray *)someItems andLauncherImage:(UIImage *)aLauncherImage;
- (id)initWithItems:(NSMutableArray *)someItems andLauncherImage:(UIImage *)aLauncherImage;

@end

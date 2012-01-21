//
//  SESpringBoard.m
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//
//  Modified by Artur Grigor on 21/01/12.
//

#import "SESpringBoard.h"

#import "SEViewController.h"
#import "MKNumberBadgeView.h"

@interface SEMenuItemView : UIView {
    SEMenuItem *menuItem;
    SESpringBoard *springBoard;
}

@property (nonatomic, retain) SEMenuItem *menuItem;
@property (nonatomic, retain) SESpringBoard *springBoard;

- (id)initWithMenuItem:(SEMenuItem *)aMenuItem andSpringBoard:(SESpringBoard *)aSpringBoard;

@end

@interface SESpringBoard ()

@property (nonatomic, retain) UINavigationController *navigationController;

@end

@interface SESpringBoard (Private)

- (void)launchWithTag:(NSUInteger)tag andViewController:(SEViewController *)aViewController;

- (BOOL)isRetinaDisplay;
- (NSUInteger)displayScale;
- (CGSize)itemSizeWithSeparator;

- (NSUInteger)nrOfItemsHorizontally;
- (NSUInteger)nrOfItemsVertically;
- (NSUInteger)nrOfItemsOnPage;

- (BOOL)isTopBarVisible;
- (BOOL)isPageControlVisible;

- (void)setupTopBar;
- (void)setupItemsContainer;

- (void)closeViewEventHandler:(NSNotification *)notification;

@end

@implementation SESpringBoard

#pragma mark - Properties

@synthesize itemSizeForRetinaDisplay, items, title, launcherImage;

@synthesize itemLabelColor, itemLabelShadowColor, itemLabelShadowOffset;

@synthesize topBar, topBarTitleLabel, navigationController, itemsContainer, pageControl;

- (CGSize)itemSize
{
    return (self.isRetinaDisplay ? self.itemSizeForRetinaDisplay : CGSizeMake(self.itemSizeForRetinaDisplay.width / 2, self.itemSizeForRetinaDisplay.height / 2));
}

- (CGSize)itemSizeWithSeparator
{
    return CGSizeMake(self.itemSize.width + (kLeftItemMargin * 2 * self.displayScale), self.itemSize.height + (kTopBarHeight * 2 * self.displayScale));
}

- (void)setItemSizeForRetinaDisplay:(CGSize)anItemSize
{
    itemSizeForRetinaDisplay = anItemSize;
    
    [self setupItemsContainer];
}

#pragma mark - Private

- (BOOL)isRetinaDisplay
{
    __block BOOL result = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0);
    });
    
    return result;
}

- (NSUInteger)displayScale
{
    return (self.isRetinaDisplay ? 2 : 1);
}

- (NSUInteger)nrOfItemsHorizontally
{
    CGFloat widthToSubstract = 0;    
    
    CGFloat widthWithSeparator = self.itemSizeWithSeparator.width;
    return (NSUInteger)((self.frame.size.width - widthToSubstract) / widthWithSeparator);
}

- (NSUInteger)nrOfItemsVertically
{
    CGFloat heightToSubstract = 0;
    if (self.isTopBarVisible)
        heightToSubstract += self.topBar.frame.size.height;
    if (self.isPageControlVisible)
        heightToSubstract += self.pageControl.frame.size.height;
    
    CGFloat heightWithSeparator = self.itemSizeWithSeparator.height;
    return (NSUInteger)((self.frame.size.height - heightToSubstract) / heightWithSeparator);
}

- (NSUInteger)nrOfItemsOnPage
{
    return (NSUInteger)(self.nrOfItemsHorizontally * self.nrOfItemsVertically);
}

- (BOOL)isTopBarVisible
{
    return (self.topBar.superview != nil);
}

- (BOOL)isPageControlVisible
{
    return (self.pageControl.superview != nil);
}

- (void)setupTopBar
{
    topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kTopBarHeight)];
    topBarTitleLabel = [[UILabel alloc] initWithFrame:self.topBar.frame];
    
    self.topBar.backgroundColor = [UIColor blackColor];
    self.topBarTitleLabel.textColor = [UIColor whiteColor];
    self.topBarTitleLabel.backgroundColor = [UIColor clearColor];
    self.topBarTitleLabel.textAlignment = UITextAlignmentCenter;
    self.topBarTitleLabel.text = self.title;
    [self.topBar addSubview:self.topBarTitleLabel];
    
    if (self.isTopBarVisible)
    {
        [self addSubview:topBar];
    }
}

- (void)setupItemsContainer
{
    CGFloat y = (self.isTopBarVisible ? self.topBar.frame.size.height : 0);
    
    if (itemsContainer != nil) {
        [itemsContainer removeFromSuperview];
        [itemsContainer release];
    }
    
    itemsContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, self.frame.size.height - y)];
    self.itemsContainer.delegate = self;
    self.itemsContainer.scrollEnabled = YES;
    self.itemsContainer.pagingEnabled = YES;
    self.itemsContainer.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.itemsContainer];
    
    int counter = 0;
    
    int horizontalGap = 0;
    int verticalGap = 0;
    
    NSUInteger numberOfItemsHorizontally = self.nrOfItemsHorizontally;
    //        NSUInteger numberOfItemsVertically = self.nrOfItemsVertically;
    NSUInteger numberOfItemsOnPage = self.nrOfItemsOnPage;
    int numberOfPages = (ceil((float)self.items.count / numberOfItemsOnPage));
    int currentPage = 0;
    for (SEMenuItem *item in self.items) {
        SEMenuItemView *itemView = [[SEMenuItemView alloc] initWithMenuItem:item andSpringBoard:self];
        currentPage = counter / numberOfItemsOnPage;
        itemView.tag = counter;
        CGRect frame = CGRectMake(kLeftItemMargin + horizontalGap + (currentPage * self.frame.size.width), verticalGap + kTopItemMargin, self.itemSize.width + kLeftItemMargin, self.itemSize.height + kTopItemMargin + kItemLabelHeight);
        itemView.frame = frame;
        [itemsContainer addSubview:itemView];
        horizontalGap = (self.itemSize.width + kLeftItemMargin) * (counter + 1) + (kLeftItemMargin * counter);
        counter = counter + 1;
        if(counter % numberOfItemsHorizontally == 0) {
            verticalGap = verticalGap + self.itemSize.height + kTopItemMargin;
            horizontalGap = 0;
        }
        if (counter % numberOfItemsOnPage == 0) {
            verticalGap = 0;
        }
        [itemView release];
    }
    
    self.itemsContainer.contentSize = CGSizeMake((numberOfPages * self.frame.size.width), itemsContainer.frame.size.height);
    
    // Add a page control representing the page the scrollview controls
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kPageControlHeight - kPageControlTopMargin, self.frame.size.width, kPageControlHeight)];
    if (numberOfPages > 1) {
        self.pageControl.numberOfPages = numberOfPages;
        self.pageControl.currentPage = 0;
        
        // Substract page control's height from items container
        self.itemsContainer.frame = CGRectMake(self.itemsContainer.frame.origin.x, self.itemsContainer.frame.origin.y, self.frame.size.width, self.frame.size.height - self.pageControl.frame.size.height);
        
        [self addSubview:self.pageControl];
    }
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [itemLabelColor release];
    [itemLabelShadowColor release];
    
    [items release];
    [launcherImage release];
    [title release];
    
    [topBarTitleLabel release];
    [topBar release];
    [navigationController release];
    [itemsContainer release];
    [pageControl release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameCloseView object:nil];
    
    [super dealloc];
}

- (id)initWithTitle:(NSString *)aTitle items:(NSMutableArray *)someItems andLauncherImage:(UIImage *)aLauncherImage
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        self.itemLabelColor = [UIColor blackColor];
        self.itemLabelShadowColor = [UIColor grayColor];
        self.itemLabelShadowOffset = CGPointMake(0, 0);
        
        itemSizeForRetinaDisplay = CGSizeMake(128.f, 128.f);
        
        self.title = aTitle;
        self.items = someItems;
        self.launcherImage = aLauncherImage;
        
        [self setupTopBar];
        [self setupItemsContainer];
        
        // Add listener to detect close view events
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeViewEventHandler:) name:kNotificationNameCloseView object:nil];
    }
    return self;
}

- (id)initWithItems:(NSMutableArray *)someItems andLauncherImage:(UIImage *)aLauncherImage
{
    self = [self initWithTitle:nil items:someItems andLauncherImage:aLauncherImage];
    if (self) {
        
    }
    
    return self;
}

// Transition animation function required for the springboard look & feel
- (CGAffineTransform)offscreenQuadrantTransformForView:(UIView *)theView
{
    CGPoint parentMidpoint = CGPointMake(CGRectGetMidX(theView.superview.bounds), CGRectGetMidY(theView.superview.bounds));
    CGFloat xSign = (theView.center.x < parentMidpoint.x) ? -1.f : 1.f;
    CGFloat ySign = (theView.center.y < parentMidpoint.y) ? -1.f : 1.f;
    return CGAffineTransformMakeTranslation(xSign * parentMidpoint.x, ySign * parentMidpoint.y);
}

- (void)launchWithTag:(NSUInteger)tag andViewController:(SEViewController *)aViewController
{
    SEViewController *viewController = aViewController;
    viewController.launcherImage = self.launcherImage;
    
    // Create a navigation bar
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.navigationController.view.alpha = 0.f;
    self.navigationController.view.transform = CGAffineTransformMakeScale(.1f, .1f);
    [self addSubview:self.navigationController.view];
    
    [UIView animateWithDuration:.3f  animations:^{
        // Fade out the buttons
        for (SEMenuItemView *itemView in self.itemsContainer.subviews) {
            itemView.transform = [self offscreenQuadrantTransformForView:itemView];
            itemView.alpha = 0.f;
        }
        
        // Fade in the selected view
        self.navigationController.view.alpha = 1.f;
        self.navigationController.view.transform = CGAffineTransformIdentity;
        [self.navigationController.view setFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
        
        // Fade out the top bar
        [self.topBar setFrame:CGRectMake(0, -kTopBarHeight, self.frame.size.width, kTopBarHeight)];
    }];
}

#pragma mark - Notifications

- (void)closeViewEventHandler:(NSNotification *)notification
{
    UIView *viewToRemove = (UIView *)notification.object;    
    [UIView animateWithDuration:.3f animations:^{
        viewToRemove.alpha = 0.f;
        viewToRemove.transform = CGAffineTransformMakeScale(.1f, .1f);
        for (SEMenuItemView *itemView in self.itemsContainer.subviews) {
            itemView.transform = CGAffineTransformIdentity;
            itemView.alpha = 1.f;
        }
        [self.topBar setFrame:CGRectMake(0, 0, self.frame.size.width, kTopBarHeight)];
    } completion:^(BOOL finished) {
        [viewToRemove removeFromSuperview];
    }];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.itemsContainer.frame.size.width;
    int page = floor((itemsContainer.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

@end

@implementation SEMenuItemView

#pragma mark - Properties

- (SEMenuItem *)menuItem
{
    return menuItem;
}

- (void)setMenuItem:(SEMenuItem *)aMenuItem
{
    if (menuItem != nil)
        [menuItem release];
    
    menuItem = [aMenuItem retain];
}

- (SESpringBoard *)springBoard
{
    return springBoard;
}

- (void)setSpringBoard:(SESpringBoard *)aSpringBoard
{
    if (springBoard != nil)
        [springBoard release];
    
    springBoard = [aSpringBoard retain];
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [menuItem release];
    [springBoard release];
    
    [super dealloc];
}

- (id)initWithMenuItem:(SEMenuItem *)aMenuItem andSpringBoard:(SESpringBoard *)aSpringBoard;
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.menuItem = aMenuItem;
        self.springBoard = aSpringBoard;
        
        self.frame = CGRectMake(0, 0, aSpringBoard.itemSize.width, aSpringBoard.itemSize.height + kItemLabelHeight);
    }
            
    return self;
}
            
#pragma mark - Other Methods
            
- (void)drawRect:(CGRect)rect
{    
    // Draw the icon image
    [self.menuItem.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kItemLabelHeight)];
    
    if (self.menuItem.badge > 0) {
        MKNumberBadgeView *badgeView = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 28)];
        badgeView.shadow = NO;
        badgeView.value = self.menuItem.badge;
        badgeView.alignment = UITextAlignmentRight;
        [badgeView drawRect:badgeView.frame];
        [badgeView release];
    }
    
    UIFont *bold14 = [UIFont boldSystemFontOfSize:14.f];
    // Draw the menu item title shadow
    if (self.springBoard.itemLabelShadowOffset.x != 0 && self.springBoard.itemLabelShadowOffset.y != 0) {
        NSString *shadowText = self.menuItem.title;
        [self.springBoard.itemLabelShadowColor set];
        [shadowText drawInRect:CGRectMake(self.springBoard.itemLabelShadowOffset.x, self.frame.size.height - kItemLabelHeight + self.springBoard.itemLabelShadowOffset.y, self.frame.size.width, kItemLabelHeight) withFont:bold14 lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
    }
    
    // Draw the menu item title
    NSString *text = self.menuItem.title;
    [self.springBoard.itemLabelColor set];
    [text drawInRect:CGRectMake(0, self.frame.size.height - kItemLabelHeight, self.frame.size.width, kItemLabelHeight) withFont:bold14 lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
    
    // Place a clickable button on top of everything
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = self.menuItem.tag;
    [self addSubview:button];
}

- (void)clickItem:(id)sender
{
    UIButton *theButton = (UIButton *)sender;
    [self.springBoard launchWithTag:theButton.tag andViewController:self.menuItem.viewController];
}

@end

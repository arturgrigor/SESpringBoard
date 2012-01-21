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

@synthesize itemRectForRetinaDisplay, items, title, launcherImage;

@synthesize itemLabelColor, itemLabelShadowColor, itemLabelShadowOffset;

@synthesize topBar, topBarTitleLabel, navigationController, itemsContainer, pageControl;

- (CGRect)itemRect
{
    return (self.isRetinaDisplay ? self.itemRectForRetinaDisplay : CGRectMake(self.itemRectForRetinaDisplay.origin.x / 2, self.itemRectForRetinaDisplay.origin.y / 2, self.itemRectForRetinaDisplay.size.width / 2, self.itemRectForRetinaDisplay.size.height / 2));
}

- (CGSize)itemSizeWithSeparator
{
    return CGSizeMake(self.itemRect.size.width + (self.itemRect.origin.x * 2 * self.displayScale), self.itemRect.size.height + (self.itemRect.origin.y * 2 * self.displayScale));
}

- (void)setItemRectForRetinaDisplay:(CGRect)anItemRect
{
    itemRectForRetinaDisplay = anItemRect;
    
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
    
    CGFloat heightWithSeparator = self.itemSizeWithSeparator.height + kItemLabelTopMargin + kItemLabelHeight;
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
    self.itemsContainer.showsVerticalScrollIndicator = NO;
    
    [self addSubview:self.itemsContainer];
    
    int counter = 0;
    
    int horizontalGap;
    int verticalGap = 0;
    int rowIndex = 0;
    int columnIndex = 0;
    
    NSUInteger numberOfItemsHorizontally = self.nrOfItemsHorizontally;
    NSUInteger numberOfItemsVertically = self.nrOfItemsVertically;
    NSUInteger numberOfItemsOnPage = self.nrOfItemsOnPage;
    int numberOfPages = (ceil((float)self.items.count / numberOfItemsOnPage));
    int currentPage = 0;
    
    for (SEMenuItem *item in self.items)
    {
        currentPage = counter / numberOfItemsOnPage;
        columnIndex = counter % numberOfItemsHorizontally;
        rowIndex = (counter / numberOfItemsHorizontally) % numberOfItemsHorizontally;
        
        if (rowIndex >= numberOfItemsVertically)
            rowIndex = 0;
        if (columnIndex >= numberOfItemsHorizontally)
            columnIndex = 0;
        
        if (columnIndex == 0)
            horizontalGap = 0;
        
        horizontalGap = (self.itemRect.size.width + self.itemRect.origin.x) * (columnIndex) + (self.itemRect.origin.x * columnIndex);
        verticalGap = (self.itemRect.size.height + self.itemRect.origin.y + self.itemRect.origin.y + kItemLabelHeight + kItemLabelTopMargin) * rowIndex;
        
        SEMenuItemView *itemView = [[SEMenuItemView alloc] initWithMenuItem:item andSpringBoard:self];
        itemView.tag = counter;
        CGRect frame = CGRectMake(self.itemRect.origin.x + horizontalGap + (currentPage * self.frame.size.width), verticalGap + self.itemRect.origin.y, self.itemRect.size.width + self.itemRect.origin.x, self.itemRect.size.height + self.itemRect.origin.y + kItemLabelHeight + kItemLabelTopMargin);
        itemView.frame = frame;
        
        [itemsContainer addSubview:itemView];
        [itemView release];
        
        counter++;
    }
    
    self.itemsContainer.contentSize = CGSizeMake((numberOfPages * self.frame.size.width), itemsContainer.frame.size.height);
    
    // Add a page control representing the page the scrollview controls
    CGRect pageControlFrame = CGRectMake(0, self.frame.size.height - kPageControlHeight - kPageControlTopMargin, self.frame.size.width, kPageControlHeight);
    pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    if (numberOfPages > 1) {
        self.pageControl.numberOfPages = numberOfPages;
        self.pageControl.currentPage = 0;
        
        // Substract page control's height from items container
        self.itemsContainer.frame = CGRectMake(self.itemsContainer.frame.origin.x, self.itemsContainer.frame.origin.y, self.frame.size.width, self.frame.size.height - self.pageControl.frame.size.height);
        self.itemsContainer.contentSize = CGSizeMake((numberOfPages * self.frame.size.width), itemsContainer.frame.size.height);

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
        
        itemRectForRetinaDisplay = CGRectMake(50.f, 50.f, 100.f, 100.f);
        
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
        
        self.frame = CGRectMake(0, 0, aSpringBoard.itemRect.size.width, aSpringBoard.itemRect.size.height + kItemLabelHeight);
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

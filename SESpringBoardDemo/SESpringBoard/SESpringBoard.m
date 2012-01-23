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

@property (nonatomic, readonly) CGRect itemRect;

@end

@interface SESpringBoard (Private)

- (void)launchWithTag:(NSUInteger)tag;

- (NSUInteger)displayScale;

- (NSUInteger)nrOfItemsOnPage;

- (BOOL)isTopBarVisible;
- (BOOL)isPageControlVisible;

- (void)setupTopBar;
- (void)setupItemsContainer;

@end

@implementation SESpringBoard

#pragma mark - Properties

@synthesize itemRect, itemSize, numberOfItemsVertically, numberOfItemsHorizontally, items, title, launcherImage;

@synthesize itemLabelColor, itemLabelShadowColor, itemLabelShadowOffset;

@synthesize topBar, topBarTitleLabel, itemsContainer, pageControl, delegate;

- (CGRect)itemRect
{
    if (CGRectIsEmpty(itemRect) && !CGSizeEqualToSize(itemSize, CGSizeZero))
    {
        CGFloat heightToSubstract = kPageControlHeight + kPageControlTopMargin;
        if (self.isTopBarVisible)
            heightToSubstract += self.topBar.frame.size.height;
        
        CGFloat width = itemSize.width;
        CGFloat height = itemSize.height;
        CGFloat leftMargin =  (self.frame.size.width - (numberOfItemsHorizontally * width)) / ((numberOfItemsHorizontally + 1) * 2);
        CGFloat topMargin = (self.frame.size.height - heightToSubstract - (numberOfItemsVertically * height)) / ((numberOfItemsVertically + 1) * 2);
        
        itemRect = CGRectMake(leftMargin, topMargin, width, height);
    }
    return itemRect;
}

- (void)setItemSize:(CGSize)anItemSize
{
    itemSize = anItemSize;
    
    [self setupItemsContainer];
}

- (void)setNumberOfItemsHorizontally:(NSUInteger)aNumberOfItemsHorizontally
{
    numberOfItemsHorizontally = aNumberOfItemsHorizontally;
    
    [self setupItemsContainer];
}

- (void)setNumberOfItemsVertically:(NSUInteger)aNumberOfItemsVertically
{
    numberOfItemsVertically = aNumberOfItemsVertically;
    
    [self setupItemsContainer];
}

#pragma mark - Private

- (NSUInteger)displayScale
{
    if (displayScale == -1) {
        displayScale = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0) ? 2 : 1);
    }
    return displayScale;
}

- (NSUInteger)nrOfItemsOnPage
{
    return (NSUInteger)(self.numberOfItemsHorizontally * self.numberOfItemsVertically);
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
    itemRect = CGRectZero;
    
    CGFloat y = (self.isTopBarVisible ? self.topBar.frame.size.height : 0);
    
    if (itemsContainer != nil) {
        [itemsContainer removeFromSuperview];
        [itemsContainer release];
    }
    
    CGRect itemContainerFrame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height - y);
    itemsContainer = [[UIScrollView alloc] initWithFrame:itemContainerFrame];
    self.itemsContainer.delegate = self;
    self.itemsContainer.scrollEnabled = YES;
    self.itemsContainer.pagingEnabled = YES;
    self.itemsContainer.showsHorizontalScrollIndicator = NO;
    self.itemsContainer.showsVerticalScrollIndicator = NO;
    
    [self addSubview:self.itemsContainer];
    
    int counter = 0;
    
    int horizontalGap = 0;
    int verticalGap = 0;
    int rowIndex = 0;
    int columnIndex = 0;
    
    NSUInteger numberOfItemsOnPage = self.nrOfItemsOnPage;
    int numberOfPages = (ceil((float)self.items.count / numberOfItemsOnPage));
    int currentPage = 0;
    
    CGFloat labelSize = kItemLabelTopMargin + kItemLabelHeight;
    
    for (SEMenuItem *item in self.items)
    {
        currentPage = counter / numberOfItemsOnPage;
        columnIndex = counter % self.numberOfItemsHorizontally;
        rowIndex = (counter / self.numberOfItemsHorizontally) % self.numberOfItemsVertically;
        
        if (rowIndex >= self.numberOfItemsVertically)
            rowIndex = 0;
        if (columnIndex >= self.numberOfItemsHorizontally)
            columnIndex = 0;
        
        if (columnIndex == 0)
            horizontalGap = 0;
        
        horizontalGap = (self.itemRect.size.width + (self.itemRect.origin.x * 2)) * columnIndex;
        verticalGap = (self.itemRect.size.height + (self.itemRect.origin.y * 2)) * rowIndex;
        
        SEMenuItemView *itemView = [[SEMenuItemView alloc] initWithMenuItem:item andSpringBoard:self];
        itemView.tag = counter;
        CGRect frame = CGRectMake(self.itemRect.origin.x * 2 + horizontalGap + (currentPage * self.itemsContainer.frame.size.width), self.itemRect.origin.y * 2 + verticalGap, self.itemRect.size.width, self.itemRect.size.height + labelSize);
        itemView.frame = frame;
        
        [itemsContainer addSubview:itemView];
        [itemView release];
        
        counter++;
    }
    
    self.itemsContainer.contentSize = CGSizeMake((numberOfPages * self.itemsContainer.frame.size.width), self.itemsContainer.frame.size.height);
    
    // Add a page control representing the page the scrollview controls
    CGRect pageControlFrame = CGRectMake(0, self.frame.size.height - kPageControlHeight - kPageControlTopMargin, self.frame.size.width, kPageControlHeight);
    
    if (pageControl != nil) {
        [pageControl removeFromSuperview];
        [pageControl release];
    }
    
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
    [itemsContainer release];
    [pageControl release];
    
    [super dealloc];
}

- (id)initWithTitle:(NSString *)aTitle items:(NSMutableArray *)someItems andDelegate:(id<SESpringBoardDelegate>)aDelegate
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.delegate = aDelegate;
        
        [self setUserInteractionEnabled:YES];
        
        displayScale = -1;
        
        self.itemLabelColor = [UIColor blackColor];
        self.itemLabelShadowColor = [UIColor grayColor];
        self.itemLabelShadowOffset = CGPointMake(0, 0);
        
        self.numberOfItemsHorizontally = 4;
        self.numberOfItemsVertically = 5;
        itemSize = CGSizeMake(57.f, 57.f);
        
        self.title = aTitle;
        self.items = someItems;
        
        [self setupTopBar];
        [self setupItemsContainer];
    }
    return self;
}

- (id)initWithItems:(NSMutableArray *)someItems andDelegate:(id<SESpringBoardDelegate>)aDelegate
{
    self = [self initWithTitle:nil items:someItems andDelegate:aDelegate];
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

- (void)launchWithTag:(NSUInteger)tag
{
    if ([self.delegate respondsToSelector:@selector(springBoard:didSelectItemWithTag:)]) {
        [self.delegate springBoard:self didSelectItemWithTag:tag];
    }
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
    }
            
    return self;
}
            
#pragma mark - Other Methods
            
- (void)drawRect:(CGRect)rect
{    
    // Draw the icon image
    [self.menuItem.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kItemLabelTopMargin - kItemLabelHeight)];
    
    if (self.menuItem.badge > 0) {
        MKNumberBadgeView *badgeView = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 28)];
        badgeView.shadow = NO;
        badgeView.value = self.menuItem.badge;
        badgeView.alignment = UITextAlignmentRight;
        [badgeView drawRect:badgeView.frame];
        [badgeView release];
    }
    
    UIFont *bold12 = [UIFont boldSystemFontOfSize:12.f];
    // Draw the menu item title shadow
    if (self.springBoard.itemLabelShadowOffset.x != 0 && self.springBoard.itemLabelShadowOffset.y != 0) {
        NSString *shadowText = self.menuItem.title;
        [self.springBoard.itemLabelShadowColor set];
        [shadowText drawInRect:CGRectMake(self.springBoard.itemLabelShadowOffset.x, self.frame.size.height - kItemLabelTopMargin - kItemLabelHeight + self.springBoard.itemLabelShadowOffset.y, self.frame.size.width, kItemLabelHeight) withFont:bold12 lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
    }
    
    // Draw the menu item title
    NSString *text = self.menuItem.title;
    [self.springBoard.itemLabelColor set];
    [text drawInRect:CGRectMake(0, self.frame.size.height - kItemLabelTopMargin - kItemLabelHeight, self.frame.size.width, kItemLabelHeight) withFont:bold12 lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
    
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
    [self.springBoard launchWithTag:theButton.tag];
}

@end

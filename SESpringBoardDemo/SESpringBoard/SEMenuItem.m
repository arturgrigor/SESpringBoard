//
//  SEMenuItem.m
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//
//  Modified by Artur Grigor on 21/01/12.
//

#import "SEMenuItem.h"

@implementation SEMenuItem

#pragma mark - Properties

@synthesize title, image, badge;

@synthesize tag;

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [title release];
    [image release];
    
    [super dealloc];
}

- (id)initWithTitle:(NSString *)aTitle image:(UIImage *)aImage
{
    self = [super init];
    if (self) {
        self.title = aTitle;
        self.image = aImage;
        self.badge = 0;
    }
    
    return self;
}

+ (SEMenuItem *)menuItemWithTitle:(NSString *)aTitle image:(UIImage *)aImage
{
    return [[[SEMenuItem alloc] initWithTitle:aTitle image:aImage] autorelease];
}

@end

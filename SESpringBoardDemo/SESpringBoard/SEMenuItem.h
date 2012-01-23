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

@interface SEMenuItem : NSObject {
    UIImage *image;
    NSString *title;
    NSUInteger badge;
    
    NSUInteger tag;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSUInteger badge;

@property (nonatomic, assign) NSUInteger tag;

- (id)initWithTitle:(NSString *)aTitle image:(UIImage *)aImage;
+ (SEMenuItem *)menuItemWithTitle:(NSString *)aTitle image:(UIImage *)aImage;

@end
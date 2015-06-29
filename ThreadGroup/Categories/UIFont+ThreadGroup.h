//
//  UIFont+ThreadGroup.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (ThreadGroup)

+ (UIFont *)threadGroup_boldFontWithSize:(CGFloat)size;
+ (UIFont *)threadGroup_bookFontWithSize:(CGFloat)size;
+ (UIFont *)threadGroup_lightFontWithSize:(CGFloat)size;
+ (UIFont *)threadGroup_mediumFontWithSize:(CGFloat)size;

@end

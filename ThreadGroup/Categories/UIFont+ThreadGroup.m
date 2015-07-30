//
//  UIFont+ThreadGroup.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIFont+ThreadGroup.h"

static NSString * const kThreadGroupFontNameBold = @"Gotham-Bold";
static NSString * const kThreadGroupFontNameBook = @"Gotham-Book";
static NSString * const kThreadGroupFontNameLight = @"Gotham-Light";
static NSString * const kThreadGroupFontNameMedium = @"Gotham-Medium";

@implementation UIFont (ThreadGroup)

+ (UIFont *)threadGroup_boldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:kThreadGroupFontNameBold size:size];
}

+ (UIFont *)threadGroup_bookFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:kThreadGroupFontNameBook size:size];
}

+ (UIFont *)threadGroup_lightFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:kThreadGroupFontNameLight size:size];
}

+ (UIFont *)threadGroup_mediumFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:kThreadGroupFontNameMedium size:size];
}

@end

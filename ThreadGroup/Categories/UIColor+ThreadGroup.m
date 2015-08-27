//
//  UIColor+ThreadGroup.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIColor+ThreadGroup.h"

@implementation UIColor (ThreadGroup)

+ (UIColor *)threadGroup_whiteGrey {
    return [UIColor colorWithRed:(237.0f / 255.0f) green:(237.0f / 255.0f) blue:(237.0f / 255.0f) alpha:1.0f];
}

+ (UIColor *)threadGroup_lightGrey {
    return [UIColor colorWithRed:(88.0f/255.0f) green:(87.0f/255.0f) blue:(87.0f/255.0f) alpha:1.0f];
}

+ (UIColor *)threadGroup_grey {
    return [UIColor colorWithRed:(71.0f/255.0f) green:(72.0f/255.0f) blue:(65.0f/255.0f) alpha:1.0f];
}

+ (UIColor *)threadGroup_warmGrey {
    return [UIColor colorWithRed:(136.0f/255.0f) green:(135.0f/255.0f) blue:(135.0f/255.0f) alpha:1.0f];
}

+ (UIColor *)threadGroup_orange {
    return [UIColor colorWithRed:(231.0f/255.0f) green:(124.0f/255.0f) blue:(50.0f/255.0f) alpha:1.0f];
}

+ (UIColor *)threadGroup_red {
    return [UIColor colorWithRed:(211.0f / 255.0f) green:(47.0f / 255.0f) blue:(47.0f / 255.0f) alpha:1.0f];
}

+ (UIColor *)threadGroup_darkGrey {
    return [[UIColor blackColor] colorWithAlphaComponent:0.26f];
}

@end

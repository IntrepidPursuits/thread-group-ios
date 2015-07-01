//
//  TGButton.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGButton.h"
#import "UIColor+ThreadGroup.h"
#import "UIFont+ThreadGroup.h"

@implementation TGButton

- (instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image {
    self = [UIButton buttonWithType:UIButtonTypeSystem];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor threadGroup_orange];
        self.titleLabel.font = [UIFont threadGroup_mediumFontWithSize:14.0f];

        [self setTitle:title forState:UIControlStateNormal];
        if (image) {
            [self setImage:image forState:UIControlStateNormal];
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 0.0f);
            self.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 8.0f);
        }
    }
    return self;
}
@end

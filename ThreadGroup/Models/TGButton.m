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

@interface TGButton()

@end

@implementation TGButton

- (instancetype)init {
    self = [UIButton buttonWithType:UIButtonTypeSystem];
    if (self) {
        self.tintColor = [UIColor threadGroup_orange]; //Assuming this would take care of the titleLabel color
        self.titleLabel.font = [UIFont threadGroup_mediumFontWithSize:14.0f];
    }
    return self;
}

#pragma mark - 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

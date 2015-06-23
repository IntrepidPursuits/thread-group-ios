//
//  TGMaskedView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGMaskedView.h"

@implementation TGMaskedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:1];
    UIBezierPath *cutoutPath = [UIBezierPath bezierPathWithRect:self.maskFrame];
    [path appendPath:cutoutPath];
    path.usesEvenOddFillRule = YES;
    [[UIColor colorWithWhite:0 alpha:0.6] setFill];
    [path fill];
    CGContextRestoreGState(context);
}

- (void)setMaskFrame:(CGRect)maskFrame {
    _maskFrame = maskFrame;
    [self setNeedsDisplay];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.maskFrame, point)) {
        return NO;
    } else {
        return YES;
    }
}

@end

//
//  TGSpinnerView.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/24/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSpinnerView.h"
#import "UIView+Animations.h"

@implementation TGSpinnerView

- (id)initWithClockwiseImage:(UIImage *)clockwiseImage counterClockwiseImage:(UIImage *)counterClockwiseImage {
    if (self = [super init]) {
        self.clockwiseSpinnerImageView = [[UIImageView alloc] initWithImage:clockwiseImage];
        self.counterClockwiseSpinnerImageView = [[UIImageView alloc] initWithImage:counterClockwiseImage];
        
        [self registerForEnterForegroundNotification];
        [self startAnimating];
    }
    return self;
}

- (void)startAnimating {
    [self.clockwiseSpinnerImageView threadGroup_animateClockwise];
    [self.counterClockwiseSpinnerImageView threadGroup_animateCounterClockwise];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [self startAnimating];
}

#pragma mark - Return from background notification

- (void)registerForEnterForegroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startAnimating)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

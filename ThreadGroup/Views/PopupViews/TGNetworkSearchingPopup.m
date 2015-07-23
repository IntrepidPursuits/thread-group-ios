//
//  TGNetworkSearchingPopup.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/11/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkSearchingPopup.h"
#import "UIView+Animations.h"

@interface TGNetworkSearchingPopup()
@property (weak, nonatomic) IBOutlet UIImageView *clockwiseSpinnerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *counterClockwiseSpinnerImageView;
@end

@implementation TGNetworkSearchingPopup

- (instancetype)init {
    self = [super init];
    if (self) {
        [self startAnimating];
    }
    return self;
}

- (void)startAnimating {
    [self.clockwiseSpinnerImageView threadGroup_animateClockwise];
    [self.counterClockwiseSpinnerImageView threadGroup_animateCounterClockwise];
}

@end

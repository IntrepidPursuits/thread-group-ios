//
//  TGSpinnerView.h
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/24/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TGSpinnerView : UIView

@property (strong, nonatomic) UIImageView *clockwiseSpinnerImageView;
@property (strong, nonatomic) UIImageView *counterClockwiseSpinnerImageView;

- (id)initWithClockwiseImage:(UIImage *)clockwiseView counterClockwiseImage:(UIImage *)counterClockwiseView;

@end

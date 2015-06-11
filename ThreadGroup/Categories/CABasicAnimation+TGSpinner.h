//
//  CABasicAnimation+TGSpinner.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/11/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CABasicAnimation (TGSpinner)

+ (CABasicAnimation *)clockwiseRotationAnimation;
+ (CABasicAnimation *)counterClockwiseRotationAnimation;

@end

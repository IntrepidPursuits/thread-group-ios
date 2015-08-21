//
//  TGKeyboardInfo.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 8/21/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TGKeyboardInfo : NSObject
@property (nonatomic, strong) NSNumber *animationDuration;
@property (nonatomic) UIViewAnimationCurve animationCurve;
@property (nonatomic) CGRect endframe;
@end

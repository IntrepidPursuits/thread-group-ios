//
//  TGNotificationView.h
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/27/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TGBadgeViewState) {
    TGBadgeViewStateCount,
    TGBadgeViewStateFailed,
};

@interface TGBadgeView : UIView

@property (nonatomic) TGBadgeViewState viewState;
- (void)setCount:(NSInteger)count;

@end

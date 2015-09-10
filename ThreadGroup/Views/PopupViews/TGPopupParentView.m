//
//  TGPopupView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "TGPopupParentView.h"

@interface TGPopupParentView()
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) NSArray *popups;
@property (strong, nonatomic) UIView *topChildPopup;
@end

@implementation TGPopupParentView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizer:self.tapGesture];
}

#pragma mark - "Data Source"

- (NSInteger)numberOfPopups {
    return [self.popups count];
}

- (NSInteger)indexOfPopup:(UIView *)popup {
    return [self.popups indexOfObject:popup];
}

- (UIView *)popupAtIndex:(NSInteger)index {
    return  [self.popups objectAtIndex:index];
}

#pragma mark - Actions

- (void)parentPopupPressed {
    NSInteger indexOfPopup = [self indexOfPopup:self.topChildPopup];
    if ([self.delegate respondsToSelector:@selector(parentPopup:didReceiveTouchForChildPopupAtIndex:)]) {
        [self.delegate parentPopup:self didReceiveTouchForChildPopupAtIndex:indexOfPopup];
    }
}

- (void)bringChildPopupToFront:(UIView *)childPopup animated:(BOOL)animated withCompletion:(void (^)(void))completion {
    if (childPopup == self.topChildPopup) {
        if (completion) {
            completion();
        }
        return;
    }
    childPopup.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(childPopup.bounds));
    [UIView animateWithDuration:(animated) ? 0.5f : 0.0f animations:^{
        childPopup.transform = CGAffineTransformIdentity;
        [self bringSubviewToFront:childPopup];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
    self.topChildPopup = childPopup;
}

#pragma mark - Setter/Getter

- (void)setPopups:(NSArray *)popups {
    _popups = popups;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *popupView in popups) {
        [self addSubview:popupView];
        [popupView autoPinEdgesToSuperviewEdges];
    }
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parentPopupPressed)];
    }
    return _tapGesture;
}

@end

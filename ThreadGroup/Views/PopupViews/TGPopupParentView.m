//
//  TGPopupView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

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

- (void)bringChildPopupToFront:(UIView *)childPopup {
    [self bringSubviewToFront:childPopup];
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
        popupView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : popupView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : popupView}]];
    }
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parentPopupPressed)];
    }
    return _tapGesture;
}

@end

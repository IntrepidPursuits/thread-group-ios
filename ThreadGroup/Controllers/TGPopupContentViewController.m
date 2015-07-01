//
//  TGPopupContentViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGPopupContentViewController.h"
#import "TGButton.h"
#import "UIColor+ThreadGroup.h"
#import "UIFont+ThreadGroup.h"

@interface TGPopupContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttonsPlaceholderView;

@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSString *name;
@end

@implementation TGPopupContentViewController

#pragma mark - ViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = self.name;
    [self setupButtons];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (TGButton *button in self.buttons) {
        [button removeFromSuperview];
    }
}

#pragma mark - Buttons

- (void)setupButtons {
    TGButton *preceedingButton;
    for (TGButton *button in self.buttons) {
        [self.buttonsPlaceholderView addSubview:button];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [self.buttonsPlaceholderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[bar]|" options:0 metrics:nil views:@{@"bar" : button}]];
        if (preceedingButton == nil) {
            [self.buttonsPlaceholderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bar]" options:0 metrics:nil views:@{@"bar" : button}]];
        } else {
            [self.buttonsPlaceholderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[preceeding]-1-[bar]" options:0 metrics:nil views:@{@"preceeding" : preceedingButton, @"bar" : button}]];
            [self.buttonsPlaceholderView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                                    attribute:NSLayoutAttributeWidth
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:preceedingButton
                                                                                    attribute:NSLayoutAttributeWidth
                                                                                   multiplier:1
                                                                                     constant:0]];
        }
        preceedingButton = button;
    }
    [self.buttonsPlaceholderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[preceeding]|" options:0 metrics:nil views:@{@"preceeding" : preceedingButton}]];
}

- (void)buttonPressed:(id)sender {
    NSUInteger index = [self.buttons indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(popupContentViewControllerDidPressButtonAtIndex:)]) {
        [self.delegate popupContentViewControllerDidPressButtonAtIndex:index];
    }
}

#pragma mark - Setter/Getter

- (void)setContentTitle:(NSString *)contentTitle andButtons:(NSArray *)buttons {
    self.name = contentTitle;
    self.buttons = buttons;
}

@end

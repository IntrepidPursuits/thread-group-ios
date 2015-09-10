//
//  TGPopupContentViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "TGPopupContentViewController.h"
#import "TGButton.h"
#import "UIColor+ThreadGroup.h"
#import "UIFont+ThreadGroup.h"

@interface TGPopupContentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonsPlaceholderView;

@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSString *name;

@end

@implementation TGPopupContentViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.textContainerInset = UIEdgeInsetsMake(24.0f, 24.0f, 24.0f, 24.0f);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = self.name;
    [self setupButtons];
    [self resetTextView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (TGButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    [self resetTextAlignment];
}

#pragma mark - Buttons

- (void)setupButtons {
    TGButton *preceedingButton;
    for (TGButton *button in self.buttons) {
        [self.buttonsPlaceholderView addSubview:button];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(1.0f, NSNotFound, 0.0f, NSNotFound)];
        if (preceedingButton == nil) {
            [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.buttonsPlaceholderView];
        } else {
            [preceedingButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:button withOffset:1.0f];
            [button autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:preceedingButton];
        }
        preceedingButton = button;
    }
    [preceedingButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.buttonsPlaceholderView];
}

#pragma mark - TextView

- (void)resetTextView {
    //This is a workaround for textView bug.
    //The textView will retain previous words identified as links or phone numbers, making the text formatting wrong when new text is added.
    self.textView.text = nil;
    self.textView.text = self.textContent;
    self.textView.textAlignment = self.textViewAlignment;
}

- (void)resetTextAlignment {
    self.textViewAlignment = NSTextAlignmentLeft;
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

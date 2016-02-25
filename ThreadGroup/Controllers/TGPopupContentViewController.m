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
    [self resetTextView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (TGButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    [self resetTextAlignment];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupButtons];
}

#pragma mark - Buttons

- (void)setupButtons {
    TGButton *preceedingButton;
    NSUInteger buttonsCount = [self.buttons count];
    CGFloat buttonWidth = self.buttonsPlaceholderView.frame.size.width / buttonsCount - 1.0f;
    CGFloat buttonHeight = self.buttonsPlaceholderView.frame.size.height - 1.0f;
    for (TGButton *button in self.buttons) {
        [self.buttonsPlaceholderView addSubview:button];
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [button autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.buttonsPlaceholderView];
        [button autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.buttonsPlaceholderView withOffset:1.0f];
        
        if (preceedingButton == nil) {
            [button setFrame: CGRectMake(0.0f, 0.0f, buttonWidth, buttonHeight)];
            [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.buttonsPlaceholderView];
        } else {
            [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:preceedingButton withOffset:1.0f];
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

#pragma mark - Lazy

- (NSString *)textContent {
    if (!_textContent) {
        _textContent = @"";
    }
    return _textContent;
}

@end

//
//  TGRouterAuthenticationView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGRouterAuthenticationView.h"
#import "UIFont+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"
#import "TGNetworkManager.h"
#import "TGRouterItem.h"

@interface TGRouterAuthenticationView()

@property (strong, nonatomic) UIView *nibView;

@property (weak, nonatomic) IBOutlet UILabel *routerLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;

@end

@implementation TGRouterAuthenticationView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self) {
        self.nibView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil] lastObject];
        [self addSubview:self.nibView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    [self resetView];
}

- (void)resetView {
    self.errorLabel.hidden = YES;
    self.bottomBar.backgroundColor = [UIColor threadGroup_orange];
}

#pragma mark - IBActions

- (IBAction)okButtonPressed:(UIButton *)sender {
    [[TGNetworkManager sharedManager] connectToNetwork:self.passwordTextField.text completion:^(NSError *__autoreleasing *error) {
        if (!error) {
            [self authenticationSuccess];
        } else {
            [self authenticationFailure];
        }
    }];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(routerAuthenticationCanceled:)]) {
        [self.delegate routerAuthenticationCanceled:self];
    }
}

#pragma mark - Delegate

- (void)authenticationSuccess {
    if ([self.delegate respondsToSelector:@selector(routerAuthenticationSuccessful:)]) {
        [self.delegate routerAuthenticationSuccessful:self];
    }
}

- (void)authenticationFailure {
    //show error label and make bottom bar red
    self.errorLabel.hidden = NO;
    self.bottomBar.backgroundColor = [UIColor threadGroup_red];
}

#pragma mark - Setter

- (void)setItem:(TGRouterItem *)item {
    _item = item;
    //Creating attributed strings
    NSAttributedString *enter = [[NSAttributedString alloc] initWithString:@"Enter password to connect to " attributes:[self bookFontAttributeDictionary]];
    NSAttributedString *on = [[NSAttributedString alloc] initWithString:@" on " attributes:[self bookFontAttributeDictionary]];
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:item.name attributes:[self boldFontAttributeDictionary]];
    NSAttributedString *threadNetworkName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@.", item.networkName] attributes:[self boldFontAttributeDictionary]];

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:enter];
    [attString appendAttributedString:name];
    [attString appendAttributedString:on];
    [attString appendAttributedString:threadNetworkName];

    self.routerLabel.attributedText = attString;
}

#pragma mark - Helper Methods

- (NSDictionary *)boldFontAttributeDictionary {
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineHeightMultiple = 1.5;
    return @{NSFontAttributeName : [UIFont threadGroup_boldFontWithSize:14.0], NSParagraphStyleAttributeName : style};
}

- (NSDictionary *)bookFontAttributeDictionary {
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineHeightMultiple = 1.5;
    return @{NSFontAttributeName : [UIFont threadGroup_bookFontWithSize:14.0], NSParagraphStyleAttributeName : style};
}

@end

//
//  TGRouterAuthViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGRouterAuthViewController.h"
#import "UIFont+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"
#import "TGNetworkManager.h"
#import "TGRouter.h"

@interface TGRouterAuthViewController ()
@property (weak, nonatomic) IBOutlet UILabel *routerLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnerActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@end

@implementation TGRouterAuthViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetView];
}

- (void)resetView {
    self.errorLabel.hidden = YES;
    [self setUserInteractionEnabled:YES];
    self.bottomBar.backgroundColor = [UIColor threadGroup_orange];
    self.passwordTextField.text = @"";

    self.routerLabel.attributedText = [self createLabelFromItem:self.item];
}

#pragma mark - IBActions

- (IBAction)okButtonPressed:(UIButton *)sender {
    [[TGNetworkManager sharedManager] connectToRouter:self.item completion:^(TGNetworkCallbackComissionerPetitionResult *result) {
        if (result.hasAuthorizationFailed == NO) {
            [self authenticationSuccess];
            NSLog(@"Router Authentication Successful!");
        } else {
            [self authenticationFailure];
            NSLog(@"Router Authentication Failed!");
            [self setUserInteractionEnabled:YES];
        }
    }];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.passwordTextField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(routerAuthenticationCanceled:)]) {
        [self.delegate routerAuthenticationCanceled:self];
    }
}

#pragma mark - Delegate

- (void)authenticationSuccess {
    [self.passwordTextField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(routerAuthenticationSuccessful:)]) {
        [self.delegate routerAuthenticationSuccessful:self];
    }
}

- (void)authenticationFailure {
    //show error label and make bottom bar red
    self.errorLabel.hidden = NO;
    self.bottomBar.backgroundColor = [UIColor threadGroup_red];
}

#pragma mark - Helper Methods

- (NSAttributedString *)createLabelFromItem:(TGRouter *)item {
    NSAttributedString *enter = [[NSAttributedString alloc] initWithString:@"Enter password to connect to " attributes:[self bookFontAttributeDictionary]];
    NSAttributedString *on = [[NSAttributedString alloc] initWithString:@" on " attributes:[self bookFontAttributeDictionary]];
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:item.name attributes:[self boldFontAttributeDictionary]];
    NSAttributedString *threadNetworkName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@.", item.networkName] attributes:[self boldFontAttributeDictionary]];

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:enter];
    [attString appendAttributedString:name];
    [attString appendAttributedString:on];
    [attString appendAttributedString:threadNetworkName];
    return attString;
}
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

- (void)setUserInteractionEnabled:(BOOL)isEnabled {
    self.okButton.enabled = isEnabled;
    self.passwordTextField.enabled = isEnabled;
    self.spinnerActivityIndicatorView.hidden = isEnabled;
    
    if (!self.spinnerActivityIndicatorView.hidden) {
        [self.spinnerActivityIndicatorView startAnimating];
    }
    
    if (isEnabled) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.passwordTextField resignFirstResponder];
    }
}

@end

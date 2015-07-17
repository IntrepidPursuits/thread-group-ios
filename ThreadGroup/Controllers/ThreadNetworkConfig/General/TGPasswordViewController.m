//
//  TGPasswordViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/17/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGPasswordViewController.h"
#import "UIFont+ThreadGroup.h"

@interface TGPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *retypePasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation TGPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.routerNetwork = @"Intrepid Thread Network";
    self.label.attributedText = [self createLabelFromNetwor:self.routerNetwork];
    [self.passwordTextField becomeFirstResponder];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self hideKeyboards];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)okButtonPressed:(UIButton *)sender {
    [self hideKeyboards];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Methods

- (NSAttributedString *)createLabelFromNetwor:(NSString *)network {
    NSAttributedString *enter = [[NSAttributedString alloc] initWithString:@"Enter a new password for " attributes:[self bookFontAttributeDictionary]];
    NSAttributedString *threadNetworkName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@.", network] attributes:[self boldFontAttributeDictionary]];

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:enter];
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

- (void)hideKeyboards {
    [self.passwordTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end

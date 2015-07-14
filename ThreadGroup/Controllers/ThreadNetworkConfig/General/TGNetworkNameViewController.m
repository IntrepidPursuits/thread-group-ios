//
//  TGNetworkNameViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkNameViewController.h"

@interface TGNetworkNameViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation TGNetworkNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
    [self.textField resignFirstResponder];
}

#pragma mark - Setter

- (void)setTextFieldText:(NSString *)text {
    self.textField.text = text;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

@end

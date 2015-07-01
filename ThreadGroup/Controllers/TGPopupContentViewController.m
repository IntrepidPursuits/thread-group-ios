//
//  TGPopupContentViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGPopupContentViewController.h"

@interface TGPopupContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttonsPlaceholderView;

@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSString *name;
@end

@implementation TGPopupContentViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = self.name;
}

#pragma mark - Setter/Getter

- (void)setContentTitle:(NSString *)contentTitle andButtons:(NSArray *)buttons {
    self.name = contentTitle;
    self.buttons = buttons;
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(popupContentViewControllerDidPressButtonAtIndex:)]) {
        [self.delegate popupContentViewControllerDidPressButtonAtIndex:1]; //Not real index. Used to dismiss VC
    }
}

@end

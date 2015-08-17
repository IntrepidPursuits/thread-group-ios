//
//  TGNoWifiViewController.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNoWifiViewController.h"
#import "UIColor+ThreadGroup.h"

@interface TGNoWifiViewController ()

@end

@implementation TGNoWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor threadGroup_grey];
}

#pragma mark - IBAction

- (IBAction)findWifiButtonPressed:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end

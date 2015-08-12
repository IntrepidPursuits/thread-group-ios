//
//  TGNoWifiViewController.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNoWifiViewController.h"

@interface TGNoWifiViewController ()

@end

@implementation TGNoWifiViewController

#pragma mark - IBAction

- (IBAction)findWifiButtonPressed:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end

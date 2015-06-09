//
//  TGHomeViewController.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGHomeViewController.h"
#import "TGSettingsViewController.h"
#import <Reachability/Reachability.h>

@interface TGHomeViewController ()
@property (weak, nonatomic) Reachability *reachability;
@property (weak, nonatomic) IBOutlet UIView *wifiErrorView;
@end

@implementation TGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureReachability];
    [self setWifiErrorViewHidden:self.reachability.isReachableViaWiFi animated:NO];
}

- (void)configureNavigationBar {
    self.title = @"Thread";
    
    // TODO: Replace with settings button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(navigateToSettings)];
}

- (void)configureReachability {
    self.reachability = [Reachability reachabilityForLocalWiFi];
    self.reachability.reachableBlock = ^(Reachability*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setWifiErrorViewHidden:YES animated:YES];
        });
    };
    
    self.reachability.unreachableBlock = ^(Reachability*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setWifiErrorViewHidden:NO animated:YES];
        });
    };
    
    [self.reachability startNotifier];
}

#pragma mark - Navigation

- (void)navigateToSettings {
    TGSettingsViewController *settingsController = [TGSettingsViewController new];
    [self.navigationController pushViewController:settingsController animated:YES];
}

#pragma mark - Layout

- (void)setWifiErrorViewHidden:(BOOL)hidden animated:(BOOL)animated {
    NSLog(@"Setting Wifi Error View Hidden (%@) Animated (%@)", (hidden) ? @"Y" : @"N", (animated) ? @"Y" : @"N");
    CGFloat startAlpha = (hidden) ? 1.0f : 0;
    CGFloat endAlpha = (hidden) ? 0 : 1.0f;
    self.wifiErrorView.alpha = startAlpha;
    [self.wifiErrorView layoutIfNeeded];
    
    [UIView animateWithDuration:(animated) ? 0.4f : 0 animations:^{
        [self.view bringSubviewToFront:self.wifiErrorView];
        self.wifiErrorView.alpha = endAlpha;
    }];
}

#pragma mark - Button Events

- (IBAction)findWifiNetworkButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


@end

//
//  TGHomeViewController.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGHomeViewController.h"
#import "TGSettingsViewController.h"
#import "TGSpinnerView.h"
#import "TGDeviceStepView.h"
#import "TGSelectDeviceStepView.h"
#import "TGNetworkSearchingPopup.h"
#import "UIColor+ThreadGroup.h"
#import <Reachability/Reachability.h>

static CGFloat TGHomeViewAnimationDefaultDuration = 0.4f;
static CGFloat TGHomeViewAnimationNetworkSearchPopupDuration = 0.7f;

@interface TGHomeViewController () <TGDeviceStepViewDelegate, TGSelectDeviceStepViewDelegate>

@property (weak, nonatomic) Reachability *reachability;
@property (weak, nonatomic) IBOutlet UIView *wifiErrorView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet TGDeviceStepView *wifiConnectionCellView;
@property (weak, nonatomic) IBOutlet TGDeviceStepView *selectRouterCellView;
@property (weak, nonatomic) IBOutlet TGSelectDeviceStepView *scanDeviceCellView;
@property (weak, nonatomic) IBOutlet UIView *searchingForNetworksView;
@property (weak, nonatomic) IBOutlet TGSpinnerView *searchingForNetworksSpinnerView;
@property (weak, nonatomic) IBOutlet UITableView *threadNetworksTableView;
@property (weak, nonatomic) IBOutlet TGNetworkSearchingPopup *threadNetworkSearchingPopupView;

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UILabel *successDeviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *successMessageLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *networkSearchPopupBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanDeviceRowHeightConstraint;

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

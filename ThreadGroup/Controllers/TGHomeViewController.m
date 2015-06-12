//
//  TGHomeViewController.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

@import SystemConfiguration.CaptiveNetwork;
#import "TGHomeViewController.h"
#import "TGSettingsViewController.h"
#import "TGSpinnerView.h"
#import "TGDeviceStepView.h"
#import "TGSelectDeviceStepView.h"
#import "TGNetworkSearchingPopup.h"
#import "TGSettingsManager.h"
#import "TGNetworkManager.h"
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
@property (weak, nonatomic) IBOutlet UIButton *addAnotherDeviceButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *networkSearchPopupBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanDeviceRowHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addAnotherDeviceButtonBottomConstraint;

@end

@implementation TGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureLayout];
    [self configureReachability];
    [self configureDeviceStepListRows];
    [self setWifiErrorViewHidden:self.reachability.isReachableViaWiFi animated:NO];
    [self setThreadNetworkSearchPopupHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideWifiErrorAnimated:YES];

    [[TGNetworkManager sharedManager] findLocalThreadNetworksCompletion:^(NSArray *networks, NSError *__autoreleasing *error) {
        [self showThreadNetworkTableViewAnimated:YES];
    }];
}

- (void)configureLayout {
    self.view.backgroundColor = [UIColor threadGroup_grey];
    self.wifiErrorView.backgroundColor = [UIColor threadGroup_grey];
    self.addAnotherDeviceButtonBottomConstraint.constant = -self.addAnotherDeviceButton.bounds.size.height;
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_thread_logo"]];
    
    NSMutableArray *barButtons = [NSMutableArray new];
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_more_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(navigateToSettings)];
    [barButtons addObject:settingsBarButton];
    
    BOOL debugModeEnabled = [[TGSettingsManager sharedManager] debugModeEnabled];
    if (debugModeEnabled) {
        UIBarButtonItem *logBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_log_info"] style:UIBarButtonItemStylePlain target:self action:@selector(navigateToLog)];
        [barButtons addObject:logBarButton];
    }
    self.navigationItem.rightBarButtonItems = barButtons;
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

- (void)configureDeviceStepListRows {
    [self resetWifiConnectionCellView];
    [self resetSelectRouterCellView];
    [self resetScanCodeCellView];
}

- (void)resetWifiConnectionCellView {
    [self.wifiConnectionCellView setBottomBarHidden:NO];
    [self.wifiConnectionCellView setDelegate:self];
    [self.wifiConnectionCellView setIcon:[UIImage imageNamed:@"steps_wifi_completed"]];
    [self.wifiConnectionCellView setSpinnerActive:NO];
    [self.wifiConnectionCellView setTitle:@"Connected to Wifi" subTitle:[self currentWifiSSID]];
    [self.wifiConnectionCellView setTopBarHidden:YES];
}

- (void)resetSelectRouterCellView {
    // TODO: Change when active data is available
    [self.selectRouterCellView setBackgroundColor:[UIColor threadGroup_orange]];
    [self.selectRouterCellView setBottomBarHidden:YES];
    [self.selectRouterCellView setDelegate:self];
    [self.selectRouterCellView setIcon:[UIImage imageNamed:@"steps_router_active"]];
    [self.selectRouterCellView setSpinnerActive:NO];
    [self.selectRouterCellView setTitle:@"Select a Border Router" subTitle:@"Thread Networks on your connection"];
    [self.selectRouterCellView setTopBarHidden:NO];
}

- (void)resetScanCodeCellView {
    self.scanDeviceCellView.delegate = self;
    self.scanDeviceCellView.alpha = 0;
    self.cameraView.alpha = 0;
    self.successView.alpha = 0;
    
    TGSelectDeviceStepViewContentMode contentMode = TGSelectDeviceStepViewContentModeScanQRCode;
    [self.scanDeviceCellView setContentMode:contentMode];
    self.scanDeviceRowHeightConstraint.constant = [TGSelectDeviceStepView heightForContentMode:contentMode];
    [self.view layoutIfNeeded];
}

#pragma mark - Navigation

- (void)navigateToSettings {
    TGSettingsViewController *settingsController = [TGSettingsViewController new];
    [self.navigationController pushViewController:settingsController animated:YES];
}

- (void)navigateToLog {
    NSLog(@"Show Log");
}

#pragma mark - Layout

- (void)setWifiErrorViewHidden:(BOOL)hidden animated:(BOOL)animated {
    NSLog(@"Setting Wifi Error View Hidden (%@) Animated (%@)", (hidden) ? @"Y" : @"N", (animated) ? @"Y" : @"N");
    CGFloat startAlpha = (hidden) ? 1.0f : 0;
    CGFloat endAlpha = (hidden) ? 0 : 1.0f;
    self.wifiErrorView.alpha = startAlpha;
    [self.wifiErrorView layoutIfNeeded];
    
    [UIView animateWithDuration:(animated) ? TGHomeViewAnimationDefaultDuration : 0
                     animations:^{
                         [self.view bringSubviewToFront:self.wifiErrorView];
                         self.wifiErrorView.alpha = endAlpha;
                     }];
}

- (void)hideWifiErrorAnimated:(BOOL)animated {
    NSLog(@"Hide Wifi Error Animated ? %@", animated ? @"Y" : @"N");
    [self resetWifiConnectionCellView];
    self.wifiErrorView.alpha = 1.0f;
    self.threadNetworksTableView.alpha = 0;
    self.mainView.alpha = 0;
    self.wifiConnectionCellView.alpha = 0;
    self.selectRouterCellView.alpha = 0;
    self.searchingForNetworksView.alpha = 0;
    
    [UIView animateKeyframesWithDuration:(animated) ? 2.0 : 0
                                   delay:0.0
                                 options:0
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.3 animations:^{
                                      [self.view bringSubviewToFront:self.wifiErrorView];
                                      self.wifiErrorView.alpha = 0;
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.2 animations:^{
                                      [self.view bringSubviewToFront:self.mainView];
                                      self.mainView.alpha = 1.0f;
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.2 animations:^{
                                      self.wifiConnectionCellView.alpha = 1.0f;
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.2 animations:^{
                                      self.selectRouterCellView.alpha = 1.0f;
                                  }];

                                  [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
                                      self.searchingForNetworksView.alpha = 1.0f;
                                      [self.searchingForNetworksSpinnerView startAnimating];
                                  }];
                              }
                              completion:nil];
}

- (void)showThreadNetworkTableViewAnimated:(BOOL)animated {
    animated = YES;
    [UIView animateWithDuration:(animated) ? TGHomeViewAnimationDefaultDuration : 0
                     animations:^{
                         self.searchingForNetworksView.alpha = 0.0f;
                         self.threadNetworksTableView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [self setThreadNetworkSearchPopupHidden:NO animated:YES];
                         [self performSelector:@selector(connectToThreadNetwork:) withObject:nil afterDelay:5.0f];
                     }];
}

- (void)setThreadNetworkSearchPopupHidden:(BOOL)hidden animated:(BOOL)animated {
    [UIView animateWithDuration:(animated) ? TGHomeViewAnimationNetworkSearchPopupDuration : 0
                     animations:^{
                         CGFloat offset = (hidden) ? self.threadNetworkSearchingPopupView.bounds.size.height : 0;
                         self.networkSearchPopupBottomConstraint.constant = -offset;
                         [self.threadNetworkSearchingPopupView startAnimating];
                         [self.view layoutIfNeeded];
                     }];
}

- (void)showScanCodeViewAnimated:(BOOL)animated {
    [self.scanDeviceCellView setContentMode:TGSelectDeviceStepViewContentModeScanQRCode];
    [UIView animateKeyframesWithDuration:1.0f
                                   delay:0
                                 options:0
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
                                      self.threadNetworksTableView.alpha = 0;
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.4 animations:^{
                                      self.scanDeviceCellView.alpha = 1.0f;
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.5 animations:^{
                                      [self.view bringSubviewToFront:self.cameraView];
                                      self.cameraView.alpha = 1.0f;
                                  }];
                              }
                              completion:nil];
}

- (void)hideScanCodeViewAnimated:(BOOL)animated {
    [UIView animateKeyframesWithDuration:1.0f
                                   delay:0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.3 animations:^{
                                      self.scanDeviceCellView.alpha = 0.0f;
                                      self.cameraView.alpha = 0.0f;
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.5 animations:^{
                                      self.threadNetworksTableView.alpha = 1.0f;
                                      [self resetSelectRouterCellView];
                                  }];
                              }
                              completion:^(BOOL finished) {
                                  [self performSelector:@selector(connectToThreadNetwork:) withObject:nil afterDelay:5.0f];
                              }];
}

- (void)showDeviceConnectionSuccessAnimated:(BOOL)animated {
    [UIView animateKeyframesWithDuration:1.0f
                                   delay:0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                                      self.cameraView.alpha = 0;
                                      self.successView.alpha = 1.0f;
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                                      self.addAnotherDeviceButtonBottomConstraint.constant = 0;
                                      [self.view layoutIfNeeded];
                                  }];
                              }
                              completion:nil];
}

- (void)hideDeviceConnectionSuccessAnimated:(BOOL)animated {
    [UIView animateKeyframesWithDuration:1.0f
                                   delay:0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                                      self.addAnotherDeviceButtonBottomConstraint.constant = -self.addAnotherDeviceButton.bounds.size.height;
                                      [self.view layoutIfNeeded];
                                  }];

                                  [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                                      self.cameraView.alpha = 1.0;
                                      self.successView.alpha = 0;
                                  }];
                              }
                              completion:^(BOOL finished) {
                                  [self.scanDeviceCellView setContentMode:TGSelectDeviceStepViewContentModeScanQRCode];
                              }];
}

#pragma mark - Button Events

- (IBAction)findWifiNetworkButtonTapped:(id)sender {
    [self navigateToPhoneSettingsScreen];
}

- (IBAction)usePassphraseButtonTapped:(id)sender {
    [UIView animateWithDuration:0.4f animations:^{
        TGSelectDeviceStepViewContentMode newMode = TGSelectDeviceStepViewContentModePassphrase;
        [self.scanDeviceCellView setContentMode:newMode];
        self.scanDeviceRowHeightConstraint.constant = [TGSelectDeviceStepView heightForContentMode:newMode];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.scanDeviceCellView becomeFirstResponder];
    }];
}

- (IBAction)addAnotherDeviceButtonTapped:(id)sender {
    [self hideDeviceConnectionSuccessAnimated:YES];
}

#pragma mark - Helpers

- (void)connectToThreadNetwork:(id)network {
    [self.selectRouterCellView setSpinnerActive:YES];
    [self.selectRouterCellView setIcon:[UIImage imageNamed:@"steps_cancel_button"]];
    [self.selectRouterCellView setTitle:@"Connecting..." subTitle:@"Test Network on Intrepid's Thread Network"];
    
    [[TGNetworkManager sharedManager] connectToNetwork:network
                                            completion:^(NSError *__autoreleasing *error) {
                                                [self.selectRouterCellView setSpinnerActive:NO];
                                                [self.selectRouterCellView setBackgroundColor:[UIColor threadGroup_grey]];
                                                [self.selectRouterCellView setTitle:@"Test Router 1" subTitle:@"Intrepid's Thread Network"];
                                                [self.selectRouterCellView setIcon:[UIImage imageNamed:@"steps_router_completed"]];
                                                [self.selectRouterCellView setBottomBarHidden:NO];
                                                
                                                if ([self isShowingSearchingForNetworksPopup]) {
                                                    [self setThreadNetworkSearchPopupHidden:YES animated:YES];
                                                }
                                                
                                                [self showScanCodeViewAnimated:YES];
                                            }];
}

- (void)connectDevice:(id)device {
    [[TGNetworkManager sharedManager] connectDevice:device
                                         completion:^(NSError *__autoreleasing *error) {
                                             [self.scanDeviceCellView setContentMode:TGSelectDeviceStepViewContentModeComplete];
                                             [self showDeviceConnectionSuccessAnimated:YES];
                                         }];
}

- (void)navigateToPhoneSettingsScreen {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (BOOL)isShowingSearchingForNetworksPopup {
    return (self.networkSearchPopupBottomConstraint.constant == 0);
}

- (NSString *)currentWifiSSID {
    NSString *ssid;
    NSArray *interfaces = (__bridge NSArray *)CNCopySupportedInterfaces();
    
    for (NSString *interface in interfaces) {
        CFDictionaryRef networkDetails = CNCopyCurrentNetworkInfo((__bridge CFStringRef) interface);
        if (networkDetails) {
            ssid = (NSString *)CFDictionaryGetValue (networkDetails, kCNNetworkInfoKeySSID);
            CFRelease(networkDetails);
        }
    }
    return ssid;
}

#pragma mark - TGDeviceStepView Delegate

- (void)TGDeviceStepView:(TGDeviceStepView *)stepView didTapIcon:(id)sender {
    if (stepView == self.selectRouterCellView && stepView.spinnerActive) {
        [self resetSelectRouterCellView];
        [self setThreadNetworkSearchPopupHidden:YES animated:YES];
    } else if (stepView == self.selectRouterCellView && !stepView.spinnerActive) {
        [self hideDeviceConnectionSuccessAnimated:YES];
        [self hideScanCodeViewAnimated:YES];
    } else if (stepView == self.wifiConnectionCellView) {
        [self navigateToPhoneSettingsScreen];
    }
}

#pragma mark - TGScanDeviceStepView Delegate 

- (void)TGSelectDeviceStepViewDidTapConfirmButton:(TGSelectDeviceStepView *)stepView {
    [UIView animateWithDuration:0.4f animations:^{
        TGSelectDeviceStepViewContentMode newMode = TGSelectDeviceStepViewContentModeComplete;
        [self.scanDeviceCellView setContentMode:newMode];
        self.scanDeviceRowHeightConstraint.constant = [TGSelectDeviceStepView heightForContentMode:newMode];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self connectDevice:nil];
    }];
}

- (void)TGSelectDeviceStepViewDidTapScanCodeButton:(TGSelectDeviceStepView *)stepView {
    [UIView animateWithDuration:0.4f animations:^{
        TGSelectDeviceStepViewContentMode newMode = TGSelectDeviceStepViewContentModeScanQRCode;
        [self.scanDeviceCellView setContentMode:newMode];
        self.scanDeviceRowHeightConstraint.constant = [TGSelectDeviceStepView heightForContentMode:newMode];
        [self.view layoutIfNeeded];
    }];

}
@end

//
//  TGHomeScreenViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <Reachability/Reachability.h>
#import "TGHomeScreenViewController.h"

@interface TGHomeScreenViewController ()

@property (nonatomic, strong) Reachability *reachability;

//No Wifi View
@property (weak, nonatomic) IBOutlet UIView *noWifiView;

@end

@implementation TGHomeScreenViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureReachability];
    [self registerForReturnFromBackgroundNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetMainView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Reachability

- (void)configureReachability {
    self.reachability = [Reachability reachabilityForLocalWiFi];
    __weak __typeof(self)weakSelf = self;
    self.reachability.reachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf configureUIForReachableState];
        });
    };
    self.reachability.unreachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf configureUIForUnreachableState];
        });
    };
    [self.reachability startNotifier];
}

#pragma mark - Configuring Views

- (void)resetMainView {
    [self hideAllViews];
    if ([self.reachability currentReachabilityStatus] == ReachableViaWiFi) {
        [self configureUIForReachableState];
    } else {
        [self configureUIForUnreachableState];
    }
}

- (void)hideAllViews {
    self.noWifiView.hidden = YES;
    //self.wifiView.hidden = YES; // May need to all hide its subviews instead because we need to customize when the different parts of the wifiView would come in and out with animation

}

- (void)configureUIForReachableState {
    // If wifiView is already not hidden, I do not want to reset the state
//    if (self.wifiView.hidden) {
//        //Perform updates
//    }
}

- (void)configureUIForUnreachableState {
    self.noWifiView.hidden = NO;
}

#pragma mark - App States

//We should list out the different states that the app can exist in
/*
 *  1) No wifi connection
       Only thing to interact with there is the "Find Wifi Connection" button, which i am assuming would bring the user to the iPhone setting screen
 *  2) Connected to Wifi, looking for border routers
 *  3) Connected to Wifi, scan device or enter in passphrase
 *  4) Connected to Wifi, device added, have the option to add a new device into the network.
 */
#pragma mark - Header View

- (IBAction)moreButtonPressed:(UIButton *)sender {
    NSLog(@"Show drop down menu");
}

- (IBAction)logButtonPressed:(UIButton *)sender {
    NSLog(@"Show App Log");
}

#pragma mark - Wifi View

#pragma mark - No Wifi View

- (IBAction)findWifiButtonPressed:(UIButton *)sender {
    [self navigateToPhoneSettingsScreen];
}

#pragma mark - Notifications

- (void)registerForReturnFromBackgroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetMainView)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

#pragma mark - Helper Methods

- (void)navigateToPhoneSettingsScreen {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

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
#import "TGMainViewController.h"

@interface TGHomeScreenViewController ()

@property (nonatomic, strong) Reachability *reachability;

//No Wifi View
@property (weak, nonatomic) IBOutlet UIView *noWifiView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
//Main View
@property (strong, nonatomic) TGMainViewController *mainViewController;

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
    [self setupMainView];
    [self hideAllViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetMainView];
}

#pragma mark - Reachability

- (void)configureReachability {
    self.reachability = [Reachability reachabilityForLocalWiFi];
    self.reachability.reachableOnWWAN = NO;
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

- (void)hideAllViews {
    self.mainViewController.view.hidden = YES;
    self.noWifiView.hidden = YES;
}

- (void)resetMainView {
    if ([self.reachability currentReachabilityStatus] == ReachableViaWiFi) {
        [self configureUIForReachableState];
    } else {
        [self configureUIForUnreachableState];
    }
}

- (void)configureUIForReachableState {
    // If wifiView is already not hidden, I do not want to reset the state
    self.noWifiView.hidden = YES;
    if (self.mainViewController.view.hidden == YES) {
        self.mainViewController.view.hidden = NO;
        [self.mainViewController setViewState:TGMainViewStateLookingForRouters];
    }
}

- (void)configureUIForUnreachableState {
    self.mainViewController.view.hidden = YES;
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

#pragma mark - Main View

- (void)setupMainView {
    self.mainViewController = [TGMainViewController new];
    [self.mainViewController willMoveToParentViewController:self];
    [self.mainViewController.view setFrame:self.mainView.bounds];
    [self.mainView addSubview:self.mainViewController.view];
    [self addChildViewController:self.mainViewController];
    [self.mainViewController didMoveToParentViewController:self];
}

#pragma mark - No Wifi View

- (IBAction)findWifiButtonPressed:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

#pragma mark - Notifications

- (void)registerForReturnFromBackgroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetMainView)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

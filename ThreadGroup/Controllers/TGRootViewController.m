//
//  TGHomeScreenViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <Reachability/Reachability.h>
#import "TGRootViewController.h"
#import "TGMainViewController.h"
#import "TGPopupContentAnimator.h"
#import "TGLogManager.h"

@interface TGRootViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) Reachability *reachability;

//No Wifi View
@property (weak, nonatomic) IBOutlet UIView *noWifiView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

//Main View
@property (strong, nonatomic) TGMainViewController *mainViewController;
@end

@implementation TGRootViewController

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
    self.modalPresentationStyle = UIModalPresentationCustom;
    [[TGLogManager sharedManager] logMessage:@"HomeScreenVC viewDidLoad"];
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
    [[TGLogManager sharedManager] logMessage:@"HomeScreenVC hideAllViews"];
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
        [self.mainViewController setPopupNotificationForState:NSNotFound animated:NO];
    }
}

- (void)configureUIForUnreachableState {
    self.mainViewController.view.hidden = YES;
    self.noWifiView.hidden = NO;
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

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    TGPopupContentAnimator *animator = [TGPopupContentAnimator new];
    animator.type = TGTransitionTypePresent;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TGPopupContentAnimator *animator = [TGPopupContentAnimator new];
    animator.type = TGTransitionTypeDismiss;
    return animator;
}

@end

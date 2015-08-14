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
#import "TGNoWifiViewController.h"
#import "TGPopupContentAnimator.h"
#import "TGLogManager.h"

@interface TGRootViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) UINavigationController *childNavigationController;
@property (strong, nonatomic) TGMainViewController *mainViewController;

@end

@implementation TGRootViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureReachability];
    [self registerForReturnFromBackgroundNotification];
    self.modalPresentationStyle = UIModalPresentationCustom;
    [[TGLogManager sharedManager] logMessage:@"HomeScreenVC viewDidLoad"];
    [self setupChildNavigationController];
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

- (void)resetMainView {
    if ([self.reachability currentReachabilityStatus] == ReachableViaWiFi) {
        [self configureUIForReachableState];
    } else {
        [self configureUIForUnreachableState];
    }
}

- (void)configureUIForReachableState {
    [self.childNavigationController setViewControllers:@[
                                   [[TGNoWifiViewController alloc] init],
                                   [[TGMainViewController alloc] init],
                                   ]];
}

- (void)configureUIForUnreachableState {
    [self.childNavigationController setViewControllers:@[
                                   [[TGNoWifiViewController alloc] init],
                                   ]];
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

#pragma mark - Lazy load

- (TGMainViewController *)mainViewController {
    if (!_mainViewController) {
        _mainViewController = [[TGMainViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _mainViewController;
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Helpers

- (void)setupChildNavigationController {
    self.childNavigationController = [[UINavigationController alloc] init];
    [self addChildViewController:self.childNavigationController];
    self.childNavigationController.view.frame = self.view.bounds;
    [self.view addSubview:self.childNavigationController.view];
    [self.childNavigationController didMoveToParentViewController:self];
}

@end

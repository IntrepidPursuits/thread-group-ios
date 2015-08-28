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
#import "TGNetworkConfigViewController.h"
#import "TGPopupContentAnimator.h"
#import "TGLogManager.h"
#import "TGNavigationAnimator.h"

@interface TGRootViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) Reachability *reachability;
@property (strong, nonatomic) TGMainViewController *mainViewController;

@end

@implementation TGRootViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureReachability];
    [self registerForReturnFromBackgroundNotification];
    [self setupNavigationControllerDelegate];
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
    [self.mainViewController setViewState:TGMainViewStateLookingForRouters];
    if (![self.navigationController.viewControllers containsObject:self.mainViewController]) {
        [self.navigationController pushViewController:self.mainViewController animated:NO];
    } else {
        [self.navigationController popToViewController:self.mainViewController animated:YES];
    }
}

- (void)configureUIForUnreachableState {
    if (![self.presentedViewController isEqual:self.mainViewController]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    TGNoWifiViewController *noWifiVC = [[TGNoWifiViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:noWifiVC animated:YES];
}

#pragma mark - Notifications

- (void)registerForReturnFromBackgroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetMainView)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([fromVC isKindOfClass:[TGNetworkConfigViewController class]] || [toVC isKindOfClass:[TGNetworkConfigViewController class]]) {
        return nil;
    }
    TGNavigationAnimator *animator = [TGNavigationAnimator new];
    return animator;
}

#pragma mark - Lazy load

- (TGMainViewController *)mainViewController {
    if (!_mainViewController) {
        _mainViewController = [[TGMainViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _mainViewController;
}

#pragma mark - Helpers

- (void)setupNavigationControllerDelegate {
    self.navigationController.delegate = self;
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

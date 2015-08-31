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
@property (nonatomic, strong) TGMainViewController *mainViewController;
@property (nonatomic, strong) TGNoWifiViewController *noWifiViewController;

@end

@implementation TGRootViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForReturnFromBackgroundNotification];
    [self setupNavigationControllerDelegate];
    [self configureReachability];
    [self resetMainView:NO];
}

#pragma mark - Reachability

- (void)configureReachability {
    self.reachability = [Reachability reachabilityForLocalWiFi];
    self.reachability.reachableOnWWAN = NO;
    __weak __typeof(self)weakSelf = self;
    self.reachability.reachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf configureUIForReachableState:YES];
        });
    };
    self.reachability.unreachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf configureUIForUnreachableState:YES];
        });
    };
    [self.reachability startNotifier];
}

#pragma mark - Configuring Views

- (void)resetMainView:(BOOL)animated {
    if ([self.reachability currentReachabilityStatus] == ReachableViaWiFi) {
        [self configureUIForReachableState:animated];
    } else {
        [self configureUIForUnreachableState:animated];
    }
}

- (void)configureUIForReachableState:(BOOL)animated {
    [self.mainViewController setViewState:TGMainViewStateLookingForRouters];
    if (![self.navigationController.viewControllers containsObject:self.mainViewController]) {
        [self.navigationController pushViewController:self.mainViewController animated:animated];
    } else {
        [self.navigationController popToViewController:self.mainViewController animated:animated];
    }
}

- (void)configureUIForUnreachableState:(BOOL)animated {
    if ([self.navigationController.viewControllers containsObject:self.mainViewController]) {
        [self.mainViewController dismissViewControllerAnimated:YES completion:nil];
    }
    if (![self.navigationController.viewControllers containsObject:self.noWifiViewController]) {
        [self.navigationController pushViewController:self.noWifiViewController animated:animated];
    } else {
        [self.navigationController popToViewController:self.noWifiViewController animated:animated];
    }

}

#pragma mark - Notifications

- (void)registerForReturnFromBackgroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

- (void)appWillEnterForeground {
    [self resetMainView:YES];
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

- (TGNoWifiViewController *)noWifiViewController {
    if (!_noWifiViewController) {
        _noWifiViewController = [[TGNoWifiViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _noWifiViewController;
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

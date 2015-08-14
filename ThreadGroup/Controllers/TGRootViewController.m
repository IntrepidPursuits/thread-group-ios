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
#import "TGNavigationAnimator.h"

@interface TGRootViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) UINavigationController *childNavigationController;
@property (strong, nonatomic) TGMainViewController *mainViewController;
@property (strong, nonatomic) TGNavigationAnimator *animator;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;

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
    self.animator = [[TGNavigationAnimator alloc] init];
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
    TGMainViewController *mainVC = [[TGMainViewController alloc] initWithNibName:nil bundle:nil];
    mainVC.viewState = TGMainViewStateLookingForRouters;
    [self.childNavigationController setViewControllers:@[
                                   [[TGNoWifiViewController alloc] init],
                                   mainVC,
                                   ]];
}

- (void)configureUIForUnreachableState {
    [self.childNavigationController popViewControllerAnimated:YES];
}

#pragma mark - Notifications

- (void)registerForReturnFromBackgroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetMainView)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        return self.animator;
    }
    return nil;
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
    self.childNavigationController.delegate = self;
    [self addChildViewController:self.childNavigationController];
    self.childNavigationController.view.frame = self.view.bounds;
    [self.view addSubview:self.childNavigationController.view];
    [self.childNavigationController didMoveToParentViewController:self];
}

@end

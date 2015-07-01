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
#import "TGPopupContentViewController.h"
#import "TGAnimator.h"
#import "TGButton.h"
#import "UIImage+ThreadGroup.h"

@interface TGHomeScreenViewController () <UIViewControllerTransitioningDelegate, TGPopupContentViewControllerDelegate>

@property (nonatomic, strong) Reachability *reachability;

//No Wifi View
@property (weak, nonatomic) IBOutlet UIView *noWifiView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

//Main View
@property (strong, nonatomic) TGMainViewController *mainViewController;

//PopupContentViewController
@property (strong, nonatomic) TGPopupContentViewController *popupContentVC;

@property (strong, nonatomic) NSArray *buttons;
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
    self.modalPresentationStyle = UIModalPresentationCustom;
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

#pragma mark - Header View

- (IBAction)moreButtonPressed:(UIButton *)sender {
    NSLog(@"Show drop down menu");
}

- (IBAction)logButtonPressed:(UIButton *)sender {
    NSLog(@"Show App Log");
    self.popupContentVC.popupType = TGPopupTypeLog;
    self.buttons = [self createButtonsFor:self.popupContentVC];
    [self.popupContentVC setContentTitle:@"Application Debug Log" andButtons:self.buttons];
    [self presentViewController:self.popupContentVC animated:YES completion:nil];
}

#pragma mark - TGPopupContentViewControllerDelegate

- (void)popupContentViewControllerDidPressButtonAtIndex:(NSUInteger)index {
    switch (self.popupContentVC.popupType) {
        case TGPopupTypeLog:
            [self handleButtonPressedAtIndex:index forPopupType:TGPopupTypeLog];
            break;
        case TGPopupTypeTOS:
            [self handleButtonPressedAtIndex:index forPopupType:TGPopupTypeTOS];
            break;
        default:
            NSAssert(YES, @"TGPopupType is undefined");
            break;
    }
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
    TGAnimator *animator = [TGAnimator new];
    animator.type = TGTransitionTypePresent;
    animator.isPopup = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TGAnimator *animator = [TGAnimator new];
    animator.type = TGTransitionTypeDismiss;
    animator.isPopup = YES;
    return animator;
}

#pragma mark - Lazy load

- (TGPopupContentViewController *)popupContentVC {
    if (!_popupContentVC) {
        _popupContentVC = [[TGPopupContentViewController alloc] initWithNibName:nil bundle:nil];
        _popupContentVC.transitioningDelegate = self;
        _popupContentVC.delegate = self;
    }
    return _popupContentVC;
}

#pragma mark - Button creation

- (NSArray *)createButtonsFor:(TGPopupContentViewController *)popupVC {
    NSMutableArray *buttons = [NSMutableArray new];
    switch (popupVC.popupType) {
        case TGPopupTypeLog: {
            TGButton *shareButton = [[TGButton alloc] initWithTitle:@"SHARE" andImage:[UIImage tg_shareAction]];
            TGButton *clearButton = [[TGButton alloc] initWithTitle:@"CLEAR" andImage:nil];
            TGButton *okButton = [[TGButton alloc] initWithTitle:@"OK" andImage:nil];

            [buttons addObject:shareButton];
            [buttons addObject:clearButton];
            [buttons addObject:okButton];

            break;
        }
        case TGPopupTypeTOS: {
            TGButton *okButton = [[TGButton alloc] initWithTitle:@"OK" andImage:nil];
            [buttons addObject:okButton];
            break;
        }
        default:
            NSAssert(YES, @"TGPopupType is undefined");
            break;
    }
    return buttons;
}

#pragma mark - Button Actions

- (void)handleButtonPressedAtIndex:(NSUInteger)index forPopupType:(TGPopupType)popupType {
    if (popupType == TGPopupTypeLog) {
        switch (index) {
            case 0:
                NSLog(@"Share button pressed!");
                break;
            case 1:
                NSLog(@"Clear button pressed!");
                break;
            case 2:
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            default:
                NSAssert(index > 2, @"Button index is out of bounds!");
                break;
        }
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

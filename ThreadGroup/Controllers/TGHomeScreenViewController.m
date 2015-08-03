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
#import "TGPopupContentAnimator.h"
#import "TGButton.h"
#import "UIImage+ThreadGroup.h"
#import "TGLogManager.h"

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
@property (strong, nonatomic) UIAlertController *moreMenu;
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
#warning change this
        [self.mainViewController setViewState:TGMainViewStateLookingForRouters];
//        [self.mainViewController setViewState:TGMainViewStateConnectDeviceScanning];
    }
}

- (void)configureUIForUnreachableState {
    self.mainViewController.view.hidden = YES;
    self.noWifiView.hidden = NO;
}

#pragma mark - Header View

- (IBAction)moreButtonPressed:(UIButton *)sender {
    [[TGLogManager sharedManager] logMessage:@"Show drop down menu"];
    [self presentViewController:self.moreMenu animated:YES completion:nil];
}

- (IBAction)logButtonPressed:(UIButton *)sender {
    [[TGLogManager sharedManager] logMessage:@"Show App Log"];
    self.popupContentVC.popupType = TGPopupTypeLog;
    self.buttons = [self createButtonsFor:self.popupContentVC];
    [self.popupContentVC setContentTitle:@"Application Debug Log" andButtons:self.buttons];
    self.popupContentVC.textContent = [[TGLogManager sharedManager] getLog];
    [self presentViewController:self.popupContentVC animated:YES completion:nil];
}

#pragma mark - MoreMenu

- (void)showTermsOfService {
    [[TGLogManager sharedManager] logMessage:@"Show Terms of Service"];
    self.popupContentVC.popupType = TGPopupTypeTOS;
    self.buttons = [self createButtonsFor:self.popupContentVC];
    [self.popupContentVC setContentTitle:@"Terms of Service" andButtons:self.buttons];
    //Rather than Lorem Ipsum, I just have the log showing
    self.popupContentVC.textContent = [[TGLogManager sharedManager] getLog];
    [self presentViewController:self.popupContentVC animated:YES completion:nil];
}

- (void)showAbout {
    [[TGLogManager sharedManager] logMessage:@"Show About"];
    self.popupContentVC.popupType = TGPopupTypeAbout;
    self.popupContentVC.textViewAlignment = NSTextAlignmentCenter; //Text alignment is reset back to justified in popup's controller
    self.buttons = [self createButtonsFor:self.popupContentVC];
    [self.popupContentVC setContentTitle:@"About" andButtons:self.buttons];
    self.popupContentVC.textContent = [self textForAbout];
    [self presentViewController:self.popupContentVC animated:YES completion:nil];
}

- (void)showHelp {
    [[TGLogManager sharedManager] logMessage:@"Show Help"];
    self.popupContentVC.popupType = TGPopupTypeAbout;
    self.buttons = [self createButtonsFor:self.popupContentVC];
    [self.popupContentVC setContentTitle:@"Help" andButtons:self.buttons];
    //Rather than Lorem Ipsum, I just have the log showing
    self.popupContentVC.textContent = [[TGLogManager sharedManager] getLog];
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
        case TGPopupTypeAbout:
            [self handleButtonPressedAtIndex:index forPopupType:TGPopupTypeAbout];
            break;
        case TGPopupTypeHelp:
            [self handleButtonPressedAtIndex:index forPopupType:TGPopupTypeHelp];
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
            TGButton *shareButton = [[TGButton alloc] initWithTitle:@"" andImage:[UIImage tg_shareAction]];
            TGButton *clearButton = [[TGButton alloc] initWithTitle:@"CLEAR" andImage:nil];
            TGButton *okButton = [[TGButton alloc] initWithTitle:@"OK" andImage:nil];

            [buttons addObject:shareButton];
            [buttons addObject:clearButton];
            [buttons addObject:okButton];

            break;
        }
        case TGPopupTypeTOS:
        case TGPopupTypeAbout:
        case TGPopupTypeHelp: {
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
            case 0: {
                NSLog(@"Share button pressed!");
                [self dismissViewControllerAnimated:YES completion:^{
                    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[self.popupContentVC.textContent] applicationActivities:nil];
                    activity.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToTwitter, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo];
                    [self presentViewController:activity animated:YES completion:nil];
                }];
                break;
            }
            case 1: {
                NSLog(@"Clear button pressed!");
                [[TGLogManager sharedManager] resetLog];
                self.popupContentVC.textContent = [[TGLogManager sharedManager] getLog];
                [self.popupContentVC resetTextView];
                break;
            }
            case 2: {
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            }
            default:
                NSAssert(index > 2, @"Button index is out of bounds!");
                break;
        }
    } else if (popupType == TGPopupTypeAbout || popupType == TGPopupTypeTOS || popupType == TGPopupTypeHelp) {
        NSLog(@"Ok Button pressed");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TextContent

- (NSString *)textForAbout {
    NSString *title = @"Thread Group Sample Comminisioning Application for iOS";
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *version = infoDictionary[(NSString *)kCFBundleVersionKey];
    NSString *versionString = [NSString stringWithFormat:@"Version: %@", version];
    NSString *additionalInfo = @"For demonstration and reference purposes only";
    NSString *intrepid = @"Brought to you by Intrepid Pursuits\nhttp://www.intrepid.io";
    NSString *thread = @"Owned and maintained by Thread Group inc.\nhttp://www.threadgroup.org";
    NSMutableString *string = [NSMutableString new];
    [string appendFormat:@"%@\n\n",title];
    [string appendFormat:@"%@\n\n",versionString];
    [string appendFormat:@"%@\n\n",additionalInfo];
    [string appendFormat:@"%@\n\n",intrepid];
    [string appendFormat:@"%@",thread];

    return string;
}

#pragma mark - UIAlertController

- (UIAlertController *)moreMenu {
    if (!_moreMenu) {
        _moreMenu = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *tos = [UIAlertAction actionWithTitle:@"Terms of Service" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showTermsOfService];
        }];
        UIAlertAction *about =  [UIAlertAction actionWithTitle:@"About" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showAbout];
            }];
        UIAlertAction *help =  [UIAlertAction actionWithTitle:@"Help" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showHelp];
        }];


        [_moreMenu addAction:defaultAction];
        [_moreMenu addAction:tos];
        [_moreMenu addAction:about];
        [_moreMenu addAction:help];
    }
    return _moreMenu;
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

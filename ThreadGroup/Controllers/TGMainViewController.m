//
//  TGMainView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

@import AudioToolbox;

#import <SystemConfiguration/CaptiveNetwork.h>
#import "TGMainViewController.h"
#import "TGDeviceStepView.h"
#import "TGNetworkSearchingPopup.h"
#import "TGSpinnerView.h"
#import "TGSelectDeviceStepView.h"
#import "UIImage+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"
#import "TGTableView.h"
#import "TGRouter.h"
#import "TGNetworkManager.h"
#import "TGDevice.h"
#import "TGScannerView.h"
#import "TGSettingsManager.h"
#import "TGAnimator.h"
#import "TGRouterAuthViewController.h"
#import "TGAddProductViewController.h"
#import "TGNetworkConfigViewController.h"

@interface TGMainViewController() <TGDeviceStepViewDelegate, TGSelectDeviceStepViewDelegate, TGTableViewProtocol, TGScannerViewDelegate, UIViewControllerTransitioningDelegate, TGRouterAuthViewControllerDelegate, TGAddProductViewControllerDelegate>

//Wifi
@property (weak, nonatomic) IBOutlet TGDeviceStepView *wifiSearchView;

//Border Router
@property (weak, nonatomic) IBOutlet TGDeviceStepView *routerSearchView;

//Available Routers View
@property (weak, nonatomic) IBOutlet UIView *availableRoutersView;
@property (weak, nonatomic) IBOutlet TGTableView *tableView;

//Finding Networks
@property (weak, nonatomic) IBOutlet UIView *findingNetworksView;
@property (weak, nonatomic) IBOutlet TGSpinnerView *findingNetworksSpinnerView;
@property (weak, nonatomic) IBOutlet TGNetworkSearchingPopup *findingNetworksPopupView;

//Select/Add Devices
@property (weak, nonatomic) IBOutlet TGSelectDeviceStepView *selectDeviceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectDeviceViewHeightLayoutConstraint;

//Success View
@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UILabel *successDeviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *successNetworkLabel;

//Mask View
@property (strong, nonatomic) IBOutlet TGScannerView *scannerView;

//Popup Notification
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIButton *addAnotherProductButton;
@property (weak, nonatomic) IBOutlet UIButton *passPhraseButton;
@property (weak, nonatomic) IBOutlet UIButton *tutorialDismissButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addDeviceTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passphraseButtonTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *findingNetworksPopupTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tutorialDismissTopLayoutConstraint;

//RouterAuthVC
@property (strong, nonatomic) TGRouterAuthViewController *routerAuthVC;

//AddProductVC
@property (strong, nonatomic) TGAddProductViewController *addProductVC;
@property (nonatomic) BOOL ignoreAddProduct;

//Thread Network Config
@property (strong, nonatomic) TGNetworkConfigViewController *threadConfig;

@end

@implementation TGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)configure {
    [self setupTableViewSource];
    self.scannerView.delegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
}

- (void)commonInit {
    self.threadConfig = [[TGNetworkConfigViewController alloc] initWithNibName:nil bundle:nil];
}

#pragma mark - Table View

- (void)setupTableViewSource {
    [self.tableView setTableViewDelegate:self];
    [[TGNetworkManager sharedManager] findLocalThreadNetworksCompletion:^(NSArray *networks, NSError *__autoreleasing *error, BOOL stillSearching) {
        [self.tableView setNetworkItems:networks];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"%@ Searching (Found %ld)", stillSearching ? @"Still" : @"Done", networks.count);
    }];
}

#pragma mark - Button Events

- (IBAction)tutorialDismissButtonTapped:(id)sender {
    [[TGSettingsManager sharedManager] setHasSeenScannerTutorial:YES];
    [self setViewState:TGMainViewStateConnectDeviceScanning];
}

- (IBAction)usePassphraseButtonPressed:(UIButton *)sender {
    self.viewState = TGMainViewStateConnectDevicePassphrase;
    
    [UIView animateWithDuration:0.4 animations:^{
        TGSelectDeviceStepViewContentMode newMode = TGSelectDeviceStepViewContentModePassphrase;
        [self.selectDeviceView setContentMode:newMode];
        self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:newMode];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.selectDeviceView becomeFirstResponder];
    }];
}

- (IBAction)addAnotherDeviceButtonPressed:(UIButton *)sender {
    self.viewState = TGMainViewStateConnectDeviceScanning;
}

#pragma mark - View States

- (void)setViewState:(TGMainViewState)viewState {
    _viewState = viewState;
    [self configureMainViewForViewState:viewState];
}

- (void)configureMainViewForViewState:(TGMainViewState)viewState {
    BOOL isScanning = (viewState == TGMainViewStateConnectDevicePassphrase || viewState == TGMainViewStateConnectDeviceScanning);
    if (isScanning && [[TGSettingsManager sharedManager] hasSeenScannerTutorial] == NO) {
        viewState = TGMainViewStateConnectDeviceTutorial;
    }
    
    [self setPopupNotificationForState:viewState animated:YES];
    [self.scannerView setContentMode:[self scannerModeForViewState:viewState]];
    
    switch (viewState) {
        case TGMainViewStateLookingForRouters:
            [self resetWifiSearchView];
            [self resetRouterSearchView];
            break;
        case TGMainViewStateConnectDevicePassphrase:
        case TGMainViewStateConnectDeviceScanning:
            [self resetSelectDeviceView];
            break;
        case TGMainViewStateAddAnotherDevice: {
            TGSelectDeviceStepViewContentMode completedMode = TGSelectDeviceStepViewContentModeComplete;
            self.selectDeviceView.contentMode = completedMode;
            self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:completedMode];
        }
            break;
        default:
            break;
    }
    
    [self hideAndShowViewsForState:viewState];
    [self animateViewsForState:viewState];
}

- (void)hideAndShowViewsForState:(TGMainViewState)viewState {
    switch (viewState) {
        case TGMainViewStateLookingForRouters:
            self.wifiSearchView.topSeperatorView.hidden = YES;
            self.findingNetworksView.hidden = NO;
            self.availableRoutersView.hidden = NO;

            self.selectDeviceView.hidden = YES;
            self.successView.hidden = YES;
            self.scannerView.hidden = YES;
            break;
        case TGMainViewStateConnectDeviceTutorial:
        case TGMainViewStateConnectDeviceScanning:
        case TGMainViewStateConnectDevicePassphrase:
            self.selectDeviceView.hidden = NO;
            self.scannerView.hidden = NO;

            self.availableRoutersView.hidden = YES;
            self.findingNetworksView.hidden = YES;
            self.successView.hidden = YES;
            break;
        case TGMainViewStateAddAnotherDevice:
            self.successView.hidden = NO;
            self.scannerView.hidden = YES;
            break;
        default:
            NSAssert(YES, @"viewState should not be undefined");
            break;
    }
}

- (void)animateViewsForState:(TGMainViewState)viewState {
    switch (viewState) {
        case TGMainViewStateLookingForRouters: {
            [self.findingNetworksSpinnerView startAnimating];
            [UIView animateWithDuration:1.5 animations:^{
                self.findingNetworksView.alpha = 0.0f;
            }];
        }
            break;
        case TGMainViewStateConnectDeviceTutorial:
        case TGMainViewStateConnectDevicePassphrase:
        case TGMainViewStateConnectDeviceScanning: {
            [UIView animateWithDuration:0.4 animations:^{
                self.selectDeviceView.alpha = 1.0f;
                self.scannerView.alpha = 1.0f;
                [self.view bringSubviewToFront:self.scannerView];
            }];
        }
            break;
        case TGMainViewStateAddAnotherDevice: {
            [UIView animateWithDuration:0.4 animations:^{
                self.successView.alpha = 1.0f;
            }];
        }
            break;
        default:
            NSAssert(YES, @"viewState should not be undefined");
            break;
    }
}

- (void)setPopupNotificationForState:(TGMainViewState)state animated:(BOOL)animated {
    NSLayoutConstraint *enabledButtonConstraint;
    NSMutableArray *hiddenConstraints = [@[self.addDeviceTopLayoutConstraint, self.passphraseButtonTopLayoutConstraint, self.findingNetworksPopupTopLayoutConstraint, self.tutorialDismissTopLayoutConstraint] mutableCopy];
    switch (state) {
        case TGMainViewStateAddAnotherDevice:
            enabledButtonConstraint = self.addDeviceTopLayoutConstraint;
            break;
        case TGMainViewStateLookingForRouters:
            enabledButtonConstraint = self.findingNetworksPopupTopLayoutConstraint;
            break;
        case TGMainViewStateConnectDeviceScanning:
            enabledButtonConstraint = self.passphraseButtonTopLayoutConstraint;
            break;
        case TGMainViewStateConnectDeviceTutorial:
            enabledButtonConstraint = self.tutorialDismissTopLayoutConstraint;
            break;
        default:
            enabledButtonConstraint = nil;
            break;
    }
    
    [hiddenConstraints removeObject:enabledButtonConstraint];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:(animated) ? 0.4 : 0 animations:^{
        enabledButtonConstraint.constant = 0.0f;
        for (NSLayoutConstraint *constraint in hiddenConstraints) {
            constraint.constant = self.popupView.frame.size.height;
        }
        [self.view layoutIfNeeded];
    }];
}

- (TGScannerViewContentMode)scannerModeForViewState:(TGMainViewState)state {
    switch (state) {
        case TGMainViewStateConnectDeviceScanning:
            return TGScannerViewContentModeActiveScanning;
        case TGMainViewStateConnectDeviceTutorial:
            return TGScannerViewContentModeTutorial;
        default:
            return TGScannerViewContentModeInactive;
    }
}

#pragma mark - Wifi

- (void)resetWifiSearchView {
    self.wifiSearchView.delegate = self;
    [self.wifiSearchView setTopBarHidden:YES];
    [self.wifiSearchView setBottomBarHidden:NO];
    [self.wifiSearchView setIcon:[UIImage tg_wifiCompleted]];
    [self.wifiSearchView setSpinnerActive:NO];
    [self.wifiSearchView setTitle:@"Connected to Wi-Fi" subTitle:[self currentWifiSSID]];
    [self.wifiSearchView setThreadConfigHidden:YES];
}

#pragma mark - Border Router

- (void)resetRouterSearchView {
    self.routerSearchView.delegate = self;
    self.routerSearchView.backgroundColor = [UIColor threadGroup_orange];
    [self.routerSearchView setTopBarHidden:NO];
    [self.routerSearchView setBottomBarHidden:YES];
    [self.routerSearchView setIcon:[UIImage tg_routerActive]];
    [self.routerSearchView setSpinnerActive:NO];
    [self.routerSearchView setTitle:@"Select a Border Router" subTitle:@"Thread networks in your home"];
    self.routerSearchView.topSeperatorView.hidden = YES;
    [self.routerSearchView setThreadConfigHidden:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

- (void)connectRouterForItem:(TGRouter *)item {
    //TODO: Will have to actually connect a real router
    [self animateConnectingToRouterWithItem:item];
    [self connectToRouterWithItem:item];
}

- (void)animateConnectingToRouterWithItem:(TGRouter *)item {
    [self.routerSearchView setSpinnerActive:YES];
    [self.routerSearchView setIcon:[UIImage tg_cancelButton]];
    [self.routerSearchView setTitle:@"Connecting..." subTitle:[NSString stringWithFormat:@"%@ on %@", item.name, item.networkName]];
}

- (void)animateConnectedToRouterWithItem:(TGRouter *)item {
    [self.routerSearchView setSpinnerActive:NO];
    [self.routerSearchView setBackgroundColor:[UIColor threadGroup_grey]];
    [self.routerSearchView setTitle:item.name subTitle:item.networkName];
    [self.routerSearchView setIcon:[UIImage tg_routerCompleted]];
    [self.routerSearchView setBottomBarHidden:NO];
    [self.routerSearchView setThreadConfigHidden:NO];
    self.routerSearchView.topSeperatorView.hidden = NO;
}

- (void)connectToRouterWithItem:(TGRouter *)item {
    self.routerAuthVC.item = item;
    [self presentViewController:self.routerAuthVC animated:YES completion:nil];
}

#pragma mark - TGRouterAuthViewControllerDelegate

- (void)routerAuthenticationSuccessful:(TGRouterAuthViewController *)routerAuthenticationView {
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.4 animations:^{
        [self animateConnectedToRouterWithItem:routerAuthenticationView.item];
        self.viewState = TGMainViewStateConnectDeviceScanning;
    }];
}

- (void)routerAuthenticationCanceled:(TGRouterAuthViewController *)routerAuthenticationView {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.viewState = TGMainViewStateLookingForRouters;
}

#pragma mark - Select/Add Devices

- (void)resetSelectDeviceView {
    self.selectDeviceView.delegate = self;
    self.selectDeviceView.alpha = 0.0f;
    self.scannerView.alpha = 0.0f;
    self.successView.alpha = 0.0f;

    TGSelectDeviceStepViewContentMode contentMode = TGSelectDeviceStepViewContentModeScanQRCode;
    self.selectDeviceView.contentMode = contentMode;
    self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:contentMode];
    [self.view layoutIfNeeded];
}

#pragma mark - TGDeviceStepViewDelegate

- (void)TGDeviceStepView:(TGDeviceStepView *)stepView didTapIcon:(id)sender {
    //the stepView sending could either be the wifiSearchView or the routerSearchView
    if (stepView == self.wifiSearchView) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } else if (stepView == self.routerSearchView) {
        [self setViewState:TGMainViewStateLookingForRouters];
    }
}

- (void)TGDeviceStepView:(TGDeviceStepView *)stepView didTapThreadConfig:(id)sender {
    //Check that stepView is routerSearchView
    if (stepView == self.routerSearchView) {
        [self.navigationController pushViewController:self.threadConfig animated:YES];
    }
}

#pragma mark - TGSelectDeviceStepViewDelegate

- (void)TGSelectDeviceStepViewDidTapScanCodeButton:(TGSelectDeviceStepView *)stepView {
    [self setViewState:TGMainViewStateConnectDeviceScanning];
    [self setPopupNotificationForState:TGMainViewStateConnectDeviceScanning animated:YES];
    
    [UIView animateWithDuration:0.4 animations:^{
        TGSelectDeviceStepViewContentMode contentMode = TGSelectDeviceStepViewContentModeScanQRCode;
        self.selectDeviceView.contentMode = contentMode;
        self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:contentMode];
        [self.view layoutIfNeeded];
    }];
}

- (void)TGSelectDeviceStepViewDidTapConfirmButton:(TGSelectDeviceStepView *)stepView validateWithDevice:(TGDevice *)device {
    [self.addProductVC setDevice:device andRouter:self.routerAuthVC.item];
    [self showAddProductVC];

    [device isPassphraseValidWithCompletion:^(BOOL success) {
        if (!self.ignoreAddProduct) {
            if (success) {
                [self hideAddProductVC];
                self.viewState = TGMainViewStateAddAnotherDevice;
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            } else {
                NSLog(@"Adding device failed!");
                [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModePassphraseInvalid];
                [self.selectDeviceView becomeFirstResponder];
                [self hideAddProductVC];
            }
        }
    }];
}

#pragma mark - TGAddProductViewController

- (void)showAddProductVC {
    self.ignoreAddProduct = NO;
    [self presentViewController:self.addProductVC animated:YES completion:nil];
}

- (void)hideAddProductVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addProductDidCancelAddingRequest:(TGAddProductViewController *)addProductViewController {
    NSLog(@"Add Product Cancelled! Ignore API call return!");
    self.ignoreAddProduct = YES;
    [self hideAddProductVC];
    [self.selectDeviceView becomeFirstResponder];
}

#pragma mark - TGTableView Delegate

- (void)tableView:(TGTableView *)tableView didSelectItem:(TGRouter *)item {
    [self connectRouterForItem:item];
}

#pragma mark - TGScannerView Delegate

- (void)TGScannerView:(UIView *)scannerView didParseDeviceFromCode:(TGDevice *)device {
    [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModeScanQRCode];
    [self.scannerView setContentMode:TGScannerViewContentModeInactive];

    [self.addProductVC setDevice:device andRouter:self.routerAuthVC.item];
    [self showAddProductVC];

    [device isPassphraseValidWithCompletion:^(BOOL success) {
        if (!self.ignoreAddProduct) {
            if (success) {
                [self hideAddProductVC];
                self.viewState = TGMainViewStateAddAnotherDevice;
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            } else {
                NSLog(@"Adding device failed!");
                self.viewState = TGMainViewStateConnectDeviceScanning;
                [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModeScanQRCodeInvalid];
                [self hideAddProductVC];
            }
        }
    }];
}

- (void)TGScannerViewDidFailParsingDevice:(UIView *)scannerView {
    [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModeScanQRCodeInvalid];
}

- (void)TGScannerView:(UIView *)scannerView didTapInfoButton:(id)sender {
    [self setViewState:TGMainViewStateConnectDeviceTutorial];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    TGAnimator *animator = [[TGAnimator alloc] init];
    animator.type = TGTransitionTypePresent;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TGAnimator *animator = [[TGAnimator alloc] init];
    animator.type = TGTransitionTypeDismiss;
    return animator;
}

#pragma mark - Helper Methods

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

#pragma mark - Lazy Load

- (TGRouterAuthViewController *)routerAuthVC {
    if (!_routerAuthVC) {
        _routerAuthVC = [[TGRouterAuthViewController alloc] initWithNibName:nil bundle:nil];
        _routerAuthVC.delegate = self;
        _routerAuthVC.transitioningDelegate = self;
    }
    return _routerAuthVC;
}

- (TGAddProductViewController *)addProductVC {
    if (!_addProductVC) {
        _addProductVC = [[TGAddProductViewController alloc] initWithNibName:nil bundle:nil];
        _addProductVC.delegate = self;
        _addProductVC.transitioningDelegate = self;
    }
    return _addProductVC;
}

@end

//
//  TGMainView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

@import AudioToolbox;

#import "TGMainViewController.h"
#import "TGDeviceStepView.h"
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
#import "TGKeychainManager.h"
#import "TGAnimator.h"
#import "TGRouterAuthViewController.h"
#import "TGAddProductViewController.h"
#import "TGNetworkConfigViewController.h"
#import "TGNoCameraAccessView.h"

#import "TGPopupParentView.h"
#import "TGNetworkSearchingPopup.h"
#import "TGConnectCodePopup.h"
#import "TGTutorialPopup.h"
#import "TGAddDevicePopup.h"

static CGFloat const kTGPopupParentViewHeight = 56.0f;
static CGFloat const kTGAnimationDuration = 0.5f;
static CGFloat const kTGHidingMainSpinnerDuration = 0.8f;
static CGFloat const kTGScannerViewAnimationDuration = 0.8f;

@interface TGMainViewController() <TGDeviceStepViewDelegate, TGSelectDeviceStepViewDelegate, TGTableViewProtocol, TGScannerViewDelegate, UIViewControllerTransitioningDelegate, TGRouterAuthViewControllerDelegate, TGAddProductViewControllerDelegate, TGPopupParentViewDelegate>

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
@property (strong, nonatomic) TGRouter *cachedRouter;

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
@property (weak, nonatomic) IBOutlet TGPopupParentView *popupView;
@property (strong, nonatomic) NSArray *popups;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupViewBottomConstraint;
@property (strong, nonatomic) TGNetworkSearchingPopup *networkPopup;
@property (strong, nonatomic) TGConnectCodePopup *connectCodePopup;
@property (strong, nonatomic) TGTutorialPopup *tutorialPopup;
@property (strong, nonatomic) TGAddDevicePopup *addDevicePopup;


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
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.viewState == TGMainViewStateConnectDevicePassphrase) {
        [self.selectDeviceView becomeFirstResponder];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configure];
}

- (void)configure {
    [self setupTableViewSource];
    self.scannerView.delegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
}

- (void)commonInit {
    self.threadConfig = [[TGNetworkConfigViewController alloc] initWithNibName:nil bundle:nil];
    [self.popupView setPopups:self.popups];
    self.popupView.delegate = self;
}

#pragma mark - Table View

- (void)setupTableViewSource {
    [self.tableView setTableViewDelegate:self];
    [[TGNetworkManager sharedManager] findLocalThreadNetworksCompletion:^(NSArray *networks, NSError *error, BOOL stillSearching) {
        
        for (TGRouter *item in networks) {
            if ([item isEqualToRouter:self.cachedRouter]) {
                //TODO: UI problem -  how to show that we're automatically trying to connect to last cached router
                [self connectRouterForItem:item];
            }
        }
        [self hideMainSpinner];
        [self.tableView setNetworkItems:networks];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"%@ Searching (Found %d)", stillSearching ? @"Still" : @"Done", networks.count);
    }];
}

#pragma mark - Main spinner

- (void)hideMainSpinner {
    [UIView animateWithDuration:kTGHidingMainSpinnerDuration animations:^{
        self.findingNetworksView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self setPopupNotificationForState:self.viewState animated:NO];
        }
    }];
}

#pragma mark - Cache

- (void)resetCachedRouterWithRouter:(TGRouter *)item {
    [[TGKeychainManager sharedManager] saveRouterItem:item withCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"Error saving router to keychain: %@", error);
        }
        NSLog(@"New cached router: %@", self.cachedRouter.name);
    }];
}

- (TGRouter *)cachedRouter {
    return [[TGKeychainManager sharedManager] getRouterItem];
}

#pragma mark - View States

- (void)setViewState:(TGMainViewState)viewState {
    _viewState = viewState;
    [self configureMainViewForViewState:viewState];
}

- (void)configureMainViewForViewState:(TGMainViewState)viewState {
    BOOL isScanning = (viewState == TGMainViewStateConnectDevicePassphrase || viewState == TGMainViewStateConnectDeviceScanning);
    if (isScanning && [TGSettingsManager hasSeenScannerTutorial] == NO) {
        viewState = TGMainViewStateConnectDeviceTutorial;
        [self setPopupNotificationForState:viewState animated:NO];
    }
    [self.scannerView setContentMode:[self scannerModeForViewState:viewState]];
    
    switch (viewState) {
        case TGMainViewStateLookingForRouters:
            [self resetWifiSearchView];
            [self resetRouterSearchView];
            break;
        case TGMainViewStateConnectDevicePassphrase:
        case TGMainViewStateConnectDeviceScanning:
            [self resetSelectDeviceView];
            [self setPopupNotificationForState:viewState animated:YES];
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
        case TGMainViewStateLookingForRouters:
        case TGMainViewStateConnectDeviceTutorial:
        case TGMainViewStateConnectDevicePassphrase:
        case TGMainViewStateConnectDeviceScanning: {
            self.selectDeviceView.alpha = 0.0f;
            self.scannerView.alpha = 0.0f;
            [UIView animateWithDuration:kTGScannerViewAnimationDuration animations:^{
                self.selectDeviceView.alpha = 1.0f;
                self.scannerView.alpha = 1.0f;
                [self.view bringSubviewToFront:self.scannerView];
            }];
        }
            break;
        case TGMainViewStateAddAnotherDevice: {
            [UIView animateWithDuration:kTGAnimationDuration animations:^{
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
    switch (state) {
        case TGMainViewStateAddAnotherDevice:
            [self.popupView bringChildPopupToFront:self.addDevicePopup animated:animated];
            self.popupViewBottomConstraint.constant = 0.0f;
            break;
        case TGMainViewStateLookingForRouters:
            [self.popupView bringChildPopupToFront:self.networkPopup animated:animated];
            self.popupViewBottomConstraint.constant = 0.0f;
            break;
        case TGMainViewStateConnectDeviceScanning:
            [self.popupView bringChildPopupToFront:self.connectCodePopup animated:animated];
            self.popupViewBottomConstraint.constant = 0.0f;
            break;
        case TGMainViewStateConnectDeviceTutorial:
            [self.popupView bringChildPopupToFront:self.tutorialPopup animated:animated];
            self.popupViewBottomConstraint.constant = 0.0f;
            break;
        default:
            //This hides the popupView
            self.popupViewBottomConstraint.constant = -kTGPopupParentViewHeight;
            break;
    }
    [UIView animateWithDuration:kTGAnimationDuration animations:^{
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
    [self.wifiSearchView setTitle:@"Connected to Wi-Fi" subTitle:[TGNetworkManager currentWifiSSID]];
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
    [self.routerSearchView setTitle:@"Connecting..." subTitle:[NSString stringWithFormat:@"%@", item.name]];
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
    [[TGNetworkManager sharedManager] connectToRouter:item completion:^(TGNetworkCallbackComissionerPetitionResult *result) {
        if (result.hasAuthorizationFailed) {
            if (![self routerViewIsBeingPresented]) {
                self.routerAuthVC.item = item;
                [self presentViewController:self.routerAuthVC animated:YES completion:nil];
            } else {
                [self.routerAuthVC updateUIForFailedAuthentication];
            }
        } else {
            if ([self routerViewIsBeingPresented]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            [self resetCachedRouterWithRouter:item];
            [self animateConnectedToRouterWithItem:item];
            self.viewState = TGMainViewStateConnectDeviceScanning;
        }
    }];
}

#pragma mark - TGRouterAuthViewController

- (BOOL)routerViewIsBeingPresented {
    return [self.presentedViewController isEqual:self.routerAuthVC];
}

#pragma mark - TGRouterAuthViewControllerDelegate

- (void)routerAuthenticationViewControllerDidPressOkButton:(TGRouterAuthViewController *)routerAuthenticationView {
    [self connectToRouterWithItem:routerAuthenticationView.item];
}

- (void)routerAuthenticationCanceled:(TGRouterAuthViewController *)routerAuthenticationView {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.viewState = TGMainViewStateLookingForRouters;
    [self setPopupNotificationForState:self.viewState animated:YES];
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
        [self.selectDeviceView resignFirstResponder];
        [self setViewState:TGMainViewStateLookingForRouters];
        [self setPopupNotificationForState:self.viewState animated:YES];
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
    [self setPopupNotificationForState:TGMainViewStateConnectDeviceScanning animated:NO];
    
    [UIView animateWithDuration:kTGAnimationDuration animations:^{
        TGSelectDeviceStepViewContentMode contentMode = TGSelectDeviceStepViewContentModeScanQRCode;
        self.selectDeviceView.contentMode = contentMode;
        self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:contentMode];
        [self.view layoutIfNeeded];
    }];
}

- (void)TGSelectDeviceStepViewDidTapConfirmButton:(TGSelectDeviceStepView *)stepView validateWithDevice:(TGDevice *)device {
    [self.addProductVC setDevice:device andRouter:self.routerAuthVC.item];
    [self showAddProductVC];

    [[TGNetworkManager sharedManager] connectDevice:device completion:^(TGNetworkCallbackJoinerFinishedResult *result) {
        if (self.ignoreAddProduct) {
            return;
        }
        
        if (result && result.state == ACCEPT) {
            [self hideAddProductVC];
            self.viewState = TGMainViewStateAddAnotherDevice;
            [self setPopupNotificationForState:self.viewState animated:YES];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        } else {
            NSLog(@"Adding device failed!");
            [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModePassphraseInvalid];
            [self.selectDeviceView becomeFirstResponder];
            [self hideAddProductVC];
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
    if (self.viewState == TGMainViewStateConnectDevicePassphrase) {
        [self.selectDeviceView becomeFirstResponder];
    } else if (self.viewState == TGMainViewStateConnectDeviceScanning) {
        [self.scannerView setContentMode:TGScannerViewContentModeActiveScanning];
    }
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

    [[TGNetworkManager sharedManager] connectDevice:device completion:^(TGNetworkCallbackJoinerFinishedResult *result) {
        if (self.ignoreAddProduct) {
            return;
        }
        
        if (result && result.state == ACCEPT) {
            [self hideAddProductVC];
            self.viewState = TGMainViewStateAddAnotherDevice;
            [self setPopupNotificationForState:self.viewState animated:YES];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        } else {
            NSLog(@"Adding device failed!");
            self.viewState = TGMainViewStateConnectDeviceScanning;
            [self setPopupNotificationForState:self.viewState animated:YES];
            [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModeScanQRCodeInvalid];
            [self hideAddProductVC];
        }
    }];
}

- (void)TGScannerViewDidFailParsingDevice:(UIView *)scannerView {
    [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModeScanQRCodeInvalid];
}

- (void)TGScannerView:(UIView *)scannerView didTapInfoButton:(id)sender {
    [self setViewState:TGMainViewStateConnectDeviceTutorial];
    [self setPopupNotificationForState:self.viewState animated:YES];
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

#pragma mark - TGPopupParentDelegate

- (void)parentPopup:(TGPopupParentView *)popupParent didReceiveTouchForChildPopupAtIndex:(NSInteger)index {
    UIView *selectedView = [self.popupView popupAtIndex:index];
    if (selectedView == self.tutorialPopup) {
        [TGSettingsManager setHasSeenScannerTutorial:YES];
        [self setViewState:TGMainViewStateConnectDeviceScanning];
        [self setPopupNotificationForState:self.viewState animated:YES];
    } else if (selectedView == self.addDevicePopup) {
        self.viewState = TGMainViewStateConnectDeviceScanning;
        [self setPopupNotificationForState:self.viewState animated:YES];
    } else if (selectedView == self.connectCodePopup) {
        self.viewState = TGMainViewStateConnectDevicePassphrase;
        [self setPopupNotificationForState:NSNotFound animated:YES];
        [UIView animateWithDuration:kTGAnimationDuration animations:^{
            TGSelectDeviceStepViewContentMode newMode = TGSelectDeviceStepViewContentModePassphrase;
            [self.selectDeviceView setContentMode:newMode];
            self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:newMode];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.selectDeviceView becomeFirstResponder];
        }];
    }
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

- (NSArray *)popups {
    if (!_popups) {
        self.networkPopup = [TGNetworkSearchingPopup new];
        self.connectCodePopup = [TGConnectCodePopup new];
        self.tutorialPopup = [TGTutorialPopup new];
        self.addDevicePopup = [TGAddDevicePopup new];
        _popups = @[self.networkPopup, self.connectCodePopup, self.tutorialPopup, self.addDevicePopup];
    }
    return _popups;
}

@end

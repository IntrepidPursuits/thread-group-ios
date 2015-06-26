//
//  TGMainView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import "TGMainView.h"
#import "TGDeviceStepView.h"
#import "TGNetworkSearchingPopup.h"
#import "TGSpinnerView.h"
#import "TGSelectDeviceStepView.h"
#import "UIImage+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"
#import "TGTableView.h"
#import "TGRouterItem.h"
#import "TGNetworkManager.h"
#import "TGDevice.h"
#import "TGScannerView.h"

@interface TGMainView() <TGDeviceStepViewDelegate, TGSelectDeviceStepViewDelegate, TGTableViewProtocol, TGScannerViewDelegate>

@property (nonatomic, strong) UIView *nibView;

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addDeviceTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passphraseButtonTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *findingNetworksPopupTopLayoutConstraint;

@end

@implementation TGMainView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self) {
        self.nibView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil] lastObject];
        [self addSubview:self.nibView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    [self configure];
}

- (void)configure {
    [self setupTableViewSource];
    [self setPopupNotificationForState:NSNotFound animated:NO];
    
    self.scannerView.delegate = self;
}

#pragma mark - Test

- (NSArray *)createTestObjects {
    TGRouterItem *item1 = [[TGRouterItem alloc] initWithName:@"Router 1" networkName:@"Network 1" networkAddress:@"2001:db8::ff00:42:8329"];
    TGRouterItem *item2 = [[TGRouterItem alloc] initWithName:@"Rotuer 2" networkName:@"Network 2" networkAddress:@"2001:db8::ff00:42:8329"];
    TGRouterItem *item3 = [[TGRouterItem alloc] initWithName:@"Rotuer 3" networkName:@"Network 1" networkAddress:@"2001:db8::ff00:42:8329"];
    TGRouterItem *item4 = [[TGRouterItem alloc] initWithName:@"Router 4" networkName:@"Network 3" networkAddress:@"2001:db8::ff00:42:8329"];
    return @[item1, item2, item3, item4];
}

#pragma mark - Table View

- (void)setupTableViewSource {
    self.tableViewSource = [[TGTableView alloc] initWithFrame:self.tableView.frame style:UITableViewStylePlain];
    self.tableViewSource.networkItems = [self createTestObjects];
    self.tableViewSource.tableViewDelegate = self;
    self.tableView.dataSource = self.tableViewSource;
    self.tableView.delegate = self.tableViewSource;
}

#pragma mark - View States

- (void)setViewState:(TGMainViewState)viewState {
    _viewState = viewState;
    [self configureMainViewForViewState:viewState];
}

- (void)configureMainViewForViewState:(TGMainViewState)viewState {
    [self setPopupNotificationForState:viewState animated:YES];
    
    switch (viewState) {
        case TGMainViewStateLookingForRouters:
            [self resetWifiSearchView];
            [self resetRouterSearchView];
            [self hideAndShowViewsForState:viewState];
            [self animateViewsForState:viewState];
            break;
        case TGMainViewStateConnectDevicePassphrase:
        case TGMainViewStateConnectDeviceScanning:
            [self resetSelectDeviceView];
            [self hideAndShowViewsForState:viewState];
            [self animateViewsForState:viewState];
            if (viewState == TGMainViewStateConnectDevicePassphrase) {
                [self.scannerView stopScanning];
            } else {
                [self.scannerView startScanning];
            }
            break;
        case TGMainViewStateAddAnotherDevice: {
            TGSelectDeviceStepViewContentMode completedMode = TGSelectDeviceStepViewContentModeComplete;
            self.selectDeviceView.contentMode = completedMode;
            self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:completedMode];

            [self hideAndShowViewsForState:viewState];
            [self animateViewsForState:viewState];
        }
            break;
        default:
            NSAssert(YES, @"viewState should not be undefined");
            break;
    }
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
            [UIView animateWithDuration:1.5 animations:^{
                self.findingNetworksView.alpha = 0;
            }];
        }
            break;
        case TGMainViewStateConnectDevicePassphrase:
        case TGMainViewStateConnectDeviceScanning: {
            [UIView animateWithDuration:0.4 animations:^{
                self.selectDeviceView.alpha = 1;
                self.scannerView.alpha = 1;
                [self bringSubviewToFront:self.scannerView];
            }];
        }
            break;
        case TGMainViewStateAddAnotherDevice: {
            [UIView animateWithDuration:0.4 animations:^{
                self.successView.alpha = 1;
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
    NSArray *hiddenConstraints;
    switch (state) {
        case TGMainViewStateAddAnotherDevice:
            enabledButtonConstraint = self.addDeviceTopLayoutConstraint;
            hiddenConstraints = @[self.findingNetworksPopupTopLayoutConstraint, self.passphraseButtonTopLayoutConstraint];
            break;
        case TGMainViewStateLookingForRouters:
            enabledButtonConstraint = self.findingNetworksPopupTopLayoutConstraint;
            hiddenConstraints = @[self.addDeviceTopLayoutConstraint, self.passphraseButtonTopLayoutConstraint];
            break;
        case TGMainViewStateConnectDeviceScanning:
            enabledButtonConstraint = self.passphraseButtonTopLayoutConstraint;
            hiddenConstraints = @[self.addDeviceTopLayoutConstraint, self.findingNetworksPopupTopLayoutConstraint];
            break;
        default:
            enabledButtonConstraint = nil;
            hiddenConstraints = @[self.addDeviceTopLayoutConstraint, self.passphraseButtonTopLayoutConstraint, self.findingNetworksPopupTopLayoutConstraint];
            break;
    }
    
    [UIView animateWithDuration:(animated) ? 0.4f : 0 animations:^{
        enabledButtonConstraint.constant = 0;
        for (NSLayoutConstraint *constraint in hiddenConstraints) {
            constraint.constant = self.popupView.frame.size.height;
        }
        [self layoutIfNeeded];
    }];
}

#pragma mark - Wifi

- (void)resetWifiSearchView {
    self.wifiSearchView.delegate = self;
    [self.wifiSearchView setTopBarHidden:YES];
    [self.wifiSearchView setBottomBarHidden:NO];
    [self.wifiSearchView setIcon:[UIImage tg_wifiCompleted]];
    [self.wifiSearchView setSpinnerActive:NO];
    [self.wifiSearchView setTitle:@"Connected to Wi-Fi" subTitle:[self currentWifiSSID]];
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
}

- (void)connectRouterForItem:(TGRouterItem *)item {
    //TODO: Will have to actually connect a real router
    [self animateConnectingToRouterWithItem:item];
    [self connectToRouterWithItem:item];
}

- (void)animateConnectingToRouterWithItem:(TGRouterItem *)item {
    [self.routerSearchView setSpinnerActive:YES];
    [self.routerSearchView setIcon:[UIImage tg_cancelButton]];
    [self.routerSearchView setTitle:@"Connecting..." subTitle:[NSString stringWithFormat:@"%@ on %@", item.name, item.networkName]];
}

- (void)animateConnectedToRouterWithItem:(TGRouterItem *)item {
    [self.routerSearchView setSpinnerActive:NO];
    [self.routerSearchView setBackgroundColor:[UIColor threadGroup_grey]];
    [self.routerSearchView setTitle:item.name subTitle:item.networkName];
    [self.routerSearchView setIcon:[UIImage tg_routerCompleted]];
    [self.routerSearchView setBottomBarHidden:NO];
    self.routerSearchView.topSeperatorView.hidden = NO;
}

- (void)connectToRouterWithItem:(TGRouterItem *)item {
    [[TGNetworkManager sharedManager] connectToNetwork:item
                                            completion:^(NSError *__autoreleasing *error) {
                                                if (!error) {
                                                    [UIView animateWithDuration:0.4 animations:^{
                                                        [self animateConnectedToRouterWithItem:item];
                                                        self.viewState = TGMainViewStateConnectDeviceScanning;
                                                    }];
                                                } else {
                                                    NSLog(@"Error connecting to network!");
                                                }
                                            }];
}

#pragma mark - Select/Add Devices

- (void)resetSelectDeviceView {
    self.selectDeviceView.delegate = self;
    self.selectDeviceView.alpha = 0;
    self.scannerView.alpha = 0;
    self.successView.alpha = 0;

    TGSelectDeviceStepViewContentMode contentMode = TGSelectDeviceStepViewContentModeScanQRCode;
    self.selectDeviceView.contentMode = contentMode;
    self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:contentMode];
    [self layoutIfNeeded];
}

- (IBAction)usePassphraseButtonPressed:(UIButton *)sender {
    self.viewState = TGMainViewStateConnectDevicePassphrase;
    
    [UIView animateWithDuration:0.4f animations:^{
        TGSelectDeviceStepViewContentMode newMode = TGSelectDeviceStepViewContentModePassphrase;
        [self.selectDeviceView setContentMode:newMode];
        self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:newMode];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.selectDeviceView becomeFirstResponder];
    }];
}

#pragma mark - Success View

- (IBAction)addAnotherDeviceButtonPressed:(UIButton *)sender {
    self.viewState = TGMainViewStateConnectDeviceScanning;
}

#pragma mark - TGDeviceStepViewDelegate

- (void)TGDeviceStepView:(TGDeviceStepView *)stepView didTapIcon:(id)sender {
    //the stepView sending could either be the wifiSearchView or the routerSearchView
    if (stepView == self.wifiSearchView) {
        [self.delegate mainViewWifiButtonDidTap:self];
    } else if (stepView == self.routerSearchView) {
        [self.delegate mainViewRouterButtonDidTap:self];
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
        [self layoutIfNeeded];
    }];
}

- (void)TGSelectDeviceStepViewDidTapConfirmButton:(TGSelectDeviceStepView *)stepView validateWithDevice:(TGDevice *)device{
    //Show addProduct screen
    [device isPassphraseValidWithCompletion:^(BOOL success) {
        if (success) {
            //Hide addProduct Screen
            self.viewState = TGMainViewStateAddAnotherDevice;
        } else {
            NSLog(@"Adding device failed!");
            [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModePassphraseInvalid];
            [self.selectDeviceView becomeFirstResponder];
            //Hide addProduct screen
        }
    }];
}

#pragma mark - TGTableViewProtocol

- (void)tableView:(TGTableView *)tableView didSelectItem:(TGRouterItem *)item {
    [self connectRouterForItem:item];
}

#pragma mark - TGScannerView Delegate

- (void)TGScannerView:(UIView *)scannerView didParseDeviceFromCode:(TGDevice *)device {
    [self.scannerView stopScanning];
    //Show addProduct screen
    [device isPassphraseValidWithCompletion:^(BOOL success) {
        if (success) {
            //Hide addProduct screen
            self.viewState = TGMainViewStateAddAnotherDevice;
        } else {
            // TODO: Show passphrase
            NSLog(@"Adding device failed!");
            self.viewState = TGMainViewStateConnectDeviceScanning;
            [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModeScanQRCodeInvalid];
            //Hide addProduct screen
        }
    }];
    
}

- (void)TGScannerViewDidFailParsingDevice:(UIView *)scannerView {
    [self.selectDeviceView setContentMode:TGSelectDeviceStepViewContentModeScanQRCodeInvalid];
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

@end

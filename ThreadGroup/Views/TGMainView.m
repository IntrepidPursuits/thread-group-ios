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

@interface TGMainView() <TGDeviceStepViewDelegate, TGSelectDeviceStepViewDelegate, TGTableViewProtocol>

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *findingNetworksPopupBottomLayoutConstraint;

//Select/Add Devices
@property (weak, nonatomic) IBOutlet TGSelectDeviceStepView *selectDeviceView;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectDeviceViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passphraseButtonBottomLayoutConstraint;

//Success View
@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UILabel *successDeviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *successNetworkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addDeviceButtonBottomLayoutConstraint;

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
    [self setupTableViewSource];
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
    switch (viewState) {
        case TGMainViewStateLookingForRouters:
            //Wifi search view
            [self resetWifiSearchView];
            [self.findingNetworksSpinnerView startAnimating];
            self.wifiSearchView.topSeperatorView.hidden = YES;

            //Router search view
            [self resetRouterSearchView];

            //Finding networks popup
            [self hideFindingNetworkPopup];
            //Views to hide
            [self hideAndShowViewsForState:viewState];

            //Things to animate
            [self animateViewsForState:viewState];
            break;
        case TGMainViewStateScanDevice:
            //Select device view
            [self resetSelectDeviceView];
            [self hideAndShowViewsForState:viewState];
            [self animateViewsForState:viewState];
            break;
        case TGMainViewStateAddAnotherDevice:
            //do something
            break;
        default:
            NSAssert(YES, @"viewState should not be undefined");
            break;
    }
}

- (void)hideAndShowViewsForState:(TGMainViewState)viewState {
    switch (viewState) {
        case TGMainViewStateLookingForRouters:
            self.findingNetworksView.hidden = NO;
            self.findingNetworksPopupView.hidden = NO;
            self.availableRoutersView.hidden = NO;

            self.selectDeviceView.hidden = YES;
            self.successView.hidden = YES;
            self.cameraView.hidden = YES;
            break;
        case TGMainViewStateScanDevice:
            self.selectDeviceView.hidden = NO;
            self.cameraView.hidden = NO;

            self.availableRoutersView.hidden = YES;
            self.findingNetworksPopupView.hidden = YES;
            self.findingNetworksView.hidden = YES;
            self.successView.hidden = YES;
            break;
        case TGMainViewStateAddAnotherDevice:
            //do something
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
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.7 animations:^{
                        [self showFindingNetworkPopup];
                        [self layoutIfNeeded];
                    }];
                }
            }];
        }
            break;
        case TGMainViewStateScanDevice: {
            [UIView animateWithDuration:0.4 animations:^{
                self.selectDeviceView.alpha = 1;
                self.cameraView.alpha = 1;
                [self bringSubviewToFront:self.cameraView];
            } completion:^(BOOL finished) {
                if (finished) {
                    NSLog(@"Done");
                }
            }];
        }
            break;
        case TGMainViewStateAddAnotherDevice:
            //do something
            break;
        default:
            NSAssert(YES, @"viewState should not be undefined");
            break;
    }
}

#pragma mark - Wifi

- (void)updateWifiSearchView {

}

- (void)resetWifiSearchView {
    self.wifiSearchView.delegate = self;
    [self.wifiSearchView setTopBarHidden:YES];
    [self.wifiSearchView setBottomBarHidden:NO];
    [self.wifiSearchView setIcon:[UIImage tg_wifiCompleted]];
    [self.wifiSearchView setSpinnerActive:NO];
    [self.wifiSearchView setTitle:@"Connected to Wifi" subTitle:[self currentWifiSSID]];
}

#pragma mark - Border Router

- (void)updateRouterSearchView {
    //update the background color here.
    //update the state of the spinner here.
    //update the bottom bar
    //update the bottom seperator bar/top seperator bar
}

- (void)resetRouterSearchView {
    self.routerSearchView.delegate = self;
    self.routerSearchView.backgroundColor = [UIColor threadGroup_orange];
    [self.routerSearchView setTopBarHidden:NO];
    [self.routerSearchView setBottomBarHidden:YES];
    [self.routerSearchView setIcon:[UIImage tg_routerActive]];
    [self.routerSearchView setSpinnerActive:NO];
    [self.routerSearchView setTitle:@"Select a Border Router" subTitle:@"Thread Networks on your connection"];
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
                                                        [self hideFindingNetworkPopup];
                                                        self.viewState = TGMainViewStateScanDevice;
                                                    }];
                                                } else {
                                                    NSLog(@"Error connecting to network!");
                                                }
                                            }];
}

#pragma mark - Select/Add Devices

- (void)updateSelectDeviceView {

}

- (void)resetSelectDeviceView {
    self.selectDeviceView.delegate = self;
    self.selectDeviceView.alpha = 0;
    self.cameraView.alpha = 0;
    self.successView.alpha = 0;

    TGSelectDeviceStepViewContentMode contentMode = TGSelectDeviceStepViewContentModeScanQRCode;
    self.selectDeviceView.contentMode = contentMode;
    self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:contentMode];
    [self layoutIfNeeded];
}

- (IBAction)usePassphraseButtonPressed:(UIButton *)sender {
    [UIView animateWithDuration:0.4f animations:^{
        TGSelectDeviceStepViewContentMode newMode = TGSelectDeviceStepViewContentModePassphrase;
        [self.selectDeviceView setContentMode:newMode];
        self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:newMode];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.selectDeviceView becomeFirstResponder];
    }];
}

#pragma mark - Finding Network Popup

- (void)showFindingNetworkPopup {
    self.findingNetworksPopupBottomLayoutConstraint.constant = 0;
    [self.findingNetworksPopupView startAnimating];
}

- (void)hideFindingNetworkPopup {
    self.findingNetworksPopupBottomLayoutConstraint.constant = - CGRectGetHeight(self.findingNetworksPopupView.frame);
    [self.findingNetworksPopupView stopAnimating];
}

#pragma mark - Success View

- (IBAction)addAnotherDeviceButtonPressed:(UIButton *)sender {
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
    [UIView animateWithDuration:0.4 animations:^{
        TGSelectDeviceStepViewContentMode contentMode = TGSelectDeviceStepViewContentModeScanQRCode;
        self.selectDeviceView.contentMode = contentMode;
        self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:contentMode];
        [self layoutIfNeeded];
    }];
}

- (void)TGSelectDeviceStepViewDidTapConfirmButton:(TGSelectDeviceStepView *)stepView {
    [UIView animateWithDuration:0.4 animations:^{
        TGSelectDeviceStepViewContentMode contentMode = TGSelectDeviceStepViewContentModePassphraseInvalid;
        self.selectDeviceView.contentMode = contentMode;
        self.selectDeviceViewHeightLayoutConstraint.constant = [TGSelectDeviceStepView heightForContentMode:contentMode];
        [self layoutIfNeeded];
    }];

}

#pragma mark - TGTableViewProtocol

- (void)tableView:(TGTableView *)tableView didSelectItem:(TGRouterItem *)item {
    [self connectRouterForItem:item];
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

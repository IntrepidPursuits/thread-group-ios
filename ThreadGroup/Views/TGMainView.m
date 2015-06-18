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

@interface TGMainView() <TGDeviceStepViewDelegate, TGSelectDeviceStepViewDelegate>

@property (nonatomic, strong) UIView *nibView;

//Wifi
@property (weak, nonatomic) IBOutlet TGDeviceStepView *wifiSearchView;

//Border Router
@property (weak, nonatomic) IBOutlet TGDeviceStepView *routerSearchView;

//Table View
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
            self.wifiSearchView.bottomSeperator.hidden = YES;

            //Router search view
            [self resetRouterSearchView];

            //Finding networks popup
            self.findingNetworksPopupBottomLayoutConstraint.constant = - CGRectGetHeight(self.findingNetworksPopupView.frame);
            [self.findingNetworksPopupView startAnimating];

            //Views to hide
            [self hideViewsForState:viewState];

            //Things to animate
            [self animateViewsForState:viewState];
            break;
        case TGMainViewStateScanDevice:
            //do something
            break;
        case TGMainViewStateAddAnotherDevice:
            //do something
            break;
        default:
            NSAssert(YES, @"viewState should not be undefined");
            break;
    }
}

- (void)hideViewsForState:(TGMainViewState)viewState {
    switch (viewState) {
        case TGMainViewStateLookingForRouters:
            self.selectDeviceView.hidden = YES;
            self.successView.hidden = YES;
            self.cameraView.hidden = YES;
            break;
        case TGMainViewStateScanDevice:
            //do something
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
                        self.findingNetworksPopupBottomLayoutConstraint.constant = 0;
                        [self layoutIfNeeded];
                    }];
                }
            }];
        }
            break;
        case TGMainViewStateScanDevice:
            //do something
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

//I would switch the bottom seperator bar to be a top seperator bar

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

    //Is this needed?
    [self layoutIfNeeded];
}

- (IBAction)usePassphraseButtonPressed:(UIButton *)sender {
}

#pragma mark - Finding Networks

- (void)updateFindingNetwork {

}

- (void)resetFindingNetwork {
    
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

}

- (void)TGSelectDeviceStepViewDidTapConfirmButton:(TGSelectDeviceStepView *)stepView {

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

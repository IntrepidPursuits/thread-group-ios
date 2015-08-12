//
//  TGMainView.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGNavigationViewController.h"

@class TGTableView;

typedef NS_ENUM(NSInteger, TGMainViewState) {
    TGMainViewStateLookingForRouters,
    TGMainViewStateConnectDeviceScanning,
    TGMainViewStateConnectDevicePassphrase,
    TGMainViewStateConnectDeviceTutorial,
    TGMainViewStateAddAnotherDevice
};

@interface TGMainViewController : TGNavigationViewController

@property (nonatomic) TGMainViewState viewState;
@property (strong, nonatomic) TGTableView *tableViewSource;
- (void)setPopupNotificationForState:(TGMainViewState)state animated:(BOOL)animated;

//Wifi
- (void)resetWifiSearchView;

//Border Router
- (void)resetRouterSearchView;

@end
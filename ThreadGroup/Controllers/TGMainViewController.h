//
//  TGMainView.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGTableView;

typedef NS_ENUM(NSInteger, TGMainViewState) {
    TGMainViewStateLookingForRouters,
    TGMainViewStateConnectDeviceScanning,
    TGMainViewStateConnectDevicePassphrase,
    TGMainViewStateConnectDeviceTutorial,
    TGMainViewStateAddAnotherDevice
};

@interface TGMainViewController : UIViewController

@property (nonatomic) TGMainViewState viewState;
@property (strong, nonatomic) TGTableView *tableViewSource;

//Wifi
- (void)resetWifiSearchView;

//Border Router
- (void)resetRouterSearchView;

@end
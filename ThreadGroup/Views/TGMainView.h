//
//  TGMainView.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGMainView;

@protocol TGMainViewProtocol <NSObject>
- (void)mainViewWifiButtonDidTap:(TGMainView *)mainView;
- (void)mainViewRouterButtonDidTap:(TGMainView *)mainView;
@end

typedef NS_ENUM(NSInteger, TGMainViewState) {
    TGMainViewStateLookingForRouters,
    TGMainViewStateScanDevice,
    TGMainViewStateAddAnotherDevice
};

@interface TGMainView : UIView

@property (nonatomic) TGMainViewState viewState;
@property (nonatomic, weak) id<TGMainViewProtocol> delegate;

//Wifi

- (void)resetWifiSearchView;

//Border Router

//Select Devices

//Camera View

//Success View

//Finding thread networks

//Finding threadNetworks Popup


@end

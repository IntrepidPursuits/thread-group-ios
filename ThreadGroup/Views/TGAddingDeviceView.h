//
//  TGAddingDeviceView.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGAddingDeviceView;

@protocol TGAddingDeviceViewProtocol <NSObject>
- (void)addingDeviceViewDidCancelAddingRequest:(TGAddingDeviceView *)addingDeviceView;
@end

@interface TGAddingDeviceView : UIView

@property (nonatomic, weak) id<TGAddingDeviceViewProtocol> delegate;
- (void)setDeviceName:(NSString *)name withNetworkName:(NSString *)networkName;
- (void)startAnimating;
- (void)stopAnimating;

@end


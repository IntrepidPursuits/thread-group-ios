//
//  TGConnectCodePopup.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGConnectCodePopup;

@protocol TGConnectCodePopupDelegate <NSObject>
- (void)didPressConnectCodePopup:(TGConnectCodePopup *)popup;
@end

@interface TGConnectCodePopup : UIView
@property (nonatomic) id<TGConnectCodePopupDelegate> delegate;
@end

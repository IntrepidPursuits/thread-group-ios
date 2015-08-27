//
//  TGNetworkSearchingPopup.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/11/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGPopup.h"

typedef NS_ENUM(NSUInteger, TGNetworkPopupContentMode) {
    TGNetworkPopupContentModeSearching,
    TGNetworkPopupContentModeConnecting,
};

@interface TGNetworkPopup : TGPopup

@property (nonatomic) TGNetworkPopupContentMode contentMode;

- (instancetype)initWithContentMode:(TGNetworkPopupContentMode)contentMode;
- (void)resetTitleLabel:(NSString *)title;

@end

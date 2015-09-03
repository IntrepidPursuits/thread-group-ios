//
//  TGSuccessView.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 9/2/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGDevice;
@class TGRouter;

@interface TGSuccessView : UIView
@property (nonatomic, strong) TGDevice *device;
@property (nonatomic, strong) TGRouter *router;
@end

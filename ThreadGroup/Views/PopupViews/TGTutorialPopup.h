//
//  TGTutorialPopup.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGTutorialPopup;

@protocol TGTutorialPopupDelegate <NSObject>
- (void)didPressTutorialPopup:(TGTutorialPopup *)popup;
@end

@interface TGTutorialPopup : UIView
@property (nonatomic) id<TGTutorialPopupDelegate> delegate;
@end

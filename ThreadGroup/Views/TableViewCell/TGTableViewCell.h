//
//  TGTableViewCell.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/17/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGRouter;

@interface TGTableViewCell : UITableViewCell

- (void)configureWithRouter:(TGRouter *)router;

@end

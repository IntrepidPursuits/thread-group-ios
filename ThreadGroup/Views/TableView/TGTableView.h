//
//  TGTableView.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TGTableView;
@class TGRouter;

@protocol TGTableViewProtocol <NSObject>
- (void)tableView:(TGTableView *)tableView didSelectItem:(TGRouter *)item;
@end

@interface TGTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *networkItems;
@property (nonatomic, weak) id<TGTableViewProtocol> tableViewDelegate;

@end

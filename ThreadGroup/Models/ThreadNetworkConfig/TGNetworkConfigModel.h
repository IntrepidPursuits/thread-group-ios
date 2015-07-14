//
//  TGNetworkConfigModel.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGNetworkConfigRowModel.h"

@interface TGNetworkConfigModel : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberofRowsInSection:(NSInteger)section;

- (TGNetworkConfigRowModel *)rowForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)headerTitleForSection:(NSInteger)section;

@end

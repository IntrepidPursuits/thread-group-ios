//
//  TGNetworkConfigRowModel.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkConfigRowModel.h"

@implementation TGNetworkConfigRowModel

+ (TGNetworkConfigRowModel *)rowModelWithTitle:(NSString *)title rowType:(TGNetworkConfigRowType)rowType actionType:(TGNetworkConfigAction)actionType{
    TGNetworkConfigRowModel *model = [[TGNetworkConfigRowModel alloc] init];
    model.title = title;
    model.rowType = rowType;
    model.actionType = actionType;
    return model;
}

@end

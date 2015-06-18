//
//  TGRouterItem.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGRouterItem.h"

@implementation TGRouterItem

- (instancetype)initWithName:(NSString *)name networkName:(NSString *)networkName networkAddress:(NSString *)networkAddress {
    self = [super init];
    if (self) {
        _name = name;
        _networkName = networkName;
        _networkAddress = networkAddress;
    }
    return self;
}

@end

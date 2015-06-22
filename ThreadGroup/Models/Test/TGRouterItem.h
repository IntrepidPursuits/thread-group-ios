//
//  TGRouterItem.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGRouterItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *networkName;
@property (nonatomic, strong) NSString *networkAddress;

- (instancetype)initWithName:(NSString *)name networkName:(NSString *)networkName networkAddress:(NSString *)networkAddress;

@end

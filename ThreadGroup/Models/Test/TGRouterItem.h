//
//  TGRouterItem.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGRouterItem : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *networkName;
@property (nonatomic, readonly) NSString *networkAddress;

- (instancetype)initWithService:(NSNetService *)service;

@end

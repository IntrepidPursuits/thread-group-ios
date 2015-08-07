//
//  TGRouter.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGRouter : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *networkName;
@property (nonatomic, readonly) NSString *ipAddress;
@property (nonatomic, readonly) NSInteger port;
@property (nonatomic, strong) NSString *passphrase;

- (instancetype)initWithService:(NSNetService *)service;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (BOOL)isEqualToRouter:(TGRouter *)router;

@end

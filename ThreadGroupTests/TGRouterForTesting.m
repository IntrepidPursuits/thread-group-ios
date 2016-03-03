//
//  TGRouterForTesting.m
//  ThreadGroup
//
//  Created by Stephen Wong on 3/3/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

#import "TGRouterForTesting.h"

@interface TGRouterForTesting()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *networkName;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic) NSInteger port;
@end

@implementation TGRouterForTesting

- (instancetype)initTestRouterWithName:(NSString *)name networkName:(NSString *)networkName ipAddress:(NSString *)ipAddress port:(NSInteger)port {
    self = [super init];
    if (self) {
        self.name = name;
        self.networkName = networkName;
        self.ipAddress = ipAddress;
        self.port = port;
    }
    return self;
}

@end

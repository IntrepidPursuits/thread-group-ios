//
//  TGKeychainManager.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/24/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGKeychainManager.h"

static NSString * const kTGKeychainStoreIdentifier = @"io.intrepid.thread-group-ios";

@implementation TGKeychainManager

+ (instancetype)sharedManager {
    static TGKeychainManager *shared = nil;
    static dispatch_once_t singleToken;
    dispatch_once(&singleToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)saveRouterItem:(TGRouter *)router {

}

- (TGRouter *)getRouterItem {
    return [TGRouter new];
}

@end

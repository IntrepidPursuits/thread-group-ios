//
//  TGIotivityWrapper.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGIotivityWrapper.h"

#import <MeshCop.h>

@implementation TGIotivityWrapper

+ (instancetype)sharedIotivityWrapper {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CAResult_t initializeResult;
        initializeResult = MCInitialize();
        NSAssert(initializeResult == CA_STATUS_OK, @"Failed to initialize MeshCop layer");
    }
    return self;
}

@end

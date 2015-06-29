//
//  TGNetworkManager.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkManager.h"

@implementation TGNetworkManager

+ (instancetype)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)findLocalThreadNetworksCompletion:(void (^)(NSArray *networks, NSError **error))completion {
    NSLog(@"Finding Thread Networks");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(nil, nil);
    });
}

- (void)connectToNetwork:(id)network completion:(void (^)(NSError **error))completion {
    NSLog(@"Connecting to mock network ... waiting 3 seconds");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(nil);
    });
}

- (void)connectDevice:(id)device completion:(void (^)(NSError **error))completion {
    NSLog(@"Connecting to mock network ... waiting 3 seconds");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(nil);
    });
}

@end

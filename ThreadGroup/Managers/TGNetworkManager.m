//
//  TGNetworkManager.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkManager.h"
#import "TGRouter.h"
#import "TGRouterServiceBrowser.h"

@interface TGNetworkManager() <TGRouterServiceBrowserDelegate>

@property (nonatomic, strong) TGRouterServiceBrowser *routerServiceBrowser;
@property (nonatomic, strong) TGNetworkManagerFindRoutersCompletionBlock findingNetworksCallback;
@property (nonatomic, strong) NSMutableArray *threadServices;

@end

@implementation TGNetworkManager

+ (instancetype)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)findLocalThreadNetworksCompletion:(TGNetworkManagerFindRoutersCompletionBlock)completion {
    NSLog(@"Searching For Border Routers");
    self.findingNetworksCallback = completion;
    [self.routerServiceBrowser startSearching];
}

- (void)connectToNetwork:(id)network completion:(void (^)(NSError **error))completion {
    NSLog(@"Stopping border router discovery");
    
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

#pragma mark - TGRouterServiceBrowserDelegate

- (void)TGRouterServiceBrowser:(TGRouterServiceBrowser *)browser didResolveRouter:(TGRouter *)router {
    if (self.threadServices == nil) {
        self.threadServices = [NSMutableArray new];
    }
    
    [self.threadServices addObject:router];
    
    if (self.findingNetworksCallback) {
        self.findingNetworksCallback(self.threadServices, nil, YES);
    }
}

#pragma mark - Lazy

- (TGRouterServiceBrowser *)routerServiceBrowser {
    if (_routerServiceBrowser == nil) {
        _routerServiceBrowser = [TGRouterServiceBrowser new];
        [_routerServiceBrowser setDelegate:self];
    }
    return _routerServiceBrowser;
}

@end

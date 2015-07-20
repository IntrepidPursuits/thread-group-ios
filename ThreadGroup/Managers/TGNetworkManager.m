//
//  TGNetworkManager.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkManager.h"
#import "TGRouterItem.h"

static NSString * const TGNetworkManagerMeshcopServiceType = @"_thread-net._udp";
static NSString * const TGNetworkManagerMeshcopServiceDomain = @"local";
static NSString * const TGNetworkManagerMeshcopServicePort = @"19779";
static NSUInteger const TGNetworkManagerMeshcopServiceTimeout = 15;

@interface TGNetworkManager() <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (nonatomic, strong) NSNetServiceBrowser *borderRouterServiceBrowser;
@property (nonatomic, strong) TGNetworkManagerFindRoutersCompletionBlock findingNetworksCallback;
@property (nonatomic, strong) NSMutableArray *threadServices;
@property (nonatomic, strong) NSMutableArray *netServices;

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
    NSLog(@"Finding Thread Networks");
    self.findingNetworksCallback = completion;
    
    if (self.borderRouterServiceBrowser) {
        [self.borderRouterServiceBrowser stop];
    }
    
    self.netServices = [NSMutableArray new];
    self.threadServices = [NSMutableArray new];
    self.borderRouterServiceBrowser = [NSNetServiceBrowser new];
    self.borderRouterServiceBrowser.delegate = self;
    [self.borderRouterServiceBrowser searchForServicesOfType:TGNetworkManagerMeshcopServiceType inDomain:TGNetworkManagerMeshcopServiceDomain];
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

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    [self.netServices addObject:aNetService];
    
    aNetService.delegate = self;
    [aNetService resolveWithTimeout:TGNetworkManagerMeshcopServiceTimeout];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    NSLog(@"REMOVE: %@", aNetService);
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    TGRouterItem *router = [[TGRouterItem alloc] initWithService:sender];
    [self.threadServices addObject:router];
    
    NSLog(@"Service: %@", sender);
    
    if (self.findingNetworksCallback) {
        self.findingNetworksCallback(self.threadServices, nil, YES);
    }
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"Error: %@", errorDict);
}

@end

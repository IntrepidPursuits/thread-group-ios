//
//  TGRouterServiceBrowser.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 7/21/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGRouterServiceBrowser.h"
#import "TGRouter.h"

static NSString * const TGRouterServiceBrowserServiceType = @"_thread-net._udp";
static NSString * const TGRouterServiceBrowserDomain = @"local";
static NSString * const TGRouterServiceBrowserPort = @"19779";
static NSUInteger const TGRouterServiceBrowserTimeout = 15;
static NSUInteger const TGRouterServiceBrowserRetryCount = 5;

@interface TGRouterServiceBrowser() <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (nonatomic, strong) NSNetServiceBrowser *borderRouterServiceBrowser;
@property (nonatomic, strong) NSMutableArray *netServices;
@property (nonatomic, strong) NSMutableDictionary *retryDict;

@end

@implementation TGRouterServiceBrowser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.netServices = [NSMutableArray new];
        self.retryDict = [NSMutableDictionary new];
    }
    return self;
}

- (void)startSearching {
    [self.borderRouterServiceBrowser searchForServicesOfType:TGRouterServiceBrowserServiceType inDomain:TGRouterServiceBrowserDomain];
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    [self.netServices addObject:aNetService];
    
    aNetService.delegate = self;
    [aNetService resolveWithTimeout:TGRouterServiceBrowserTimeout];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    aNetService.delegate = nil;
    [aNetService stop];
    [self.netServices removeObject:aNetService];
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    TGRouter *router = [[TGRouter alloc] initWithService:sender];
    NSLog(@"Discovered Router: %@", router);

    if ([self.delegate respondsToSelector:@selector(TGRouterServiceBrowser:didResolveRouter:)]) {
        [self.delegate TGRouterServiceBrowser:self didResolveRouter:router];
    }
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSNetServicesError error = [[errorDict objectForKey:NSNetServicesErrorCode] integerValue];
    if (error == NSNetServicesTimeoutError) {
        NSNumber *retryDictHash = @(sender.hash);
        NSInteger currentRetryCount = [[self.retryDict objectForKey:retryDictHash] integerValue];
        NSLog(@"Timeout resolving router address. Current retry count <%d>", currentRetryCount);
        
        if (++currentRetryCount < TGRouterServiceBrowserRetryCount) {
            NSLog(@"Retrying router address resolve");
            [sender resolveWithTimeout:TGRouterServiceBrowserTimeout];
            [self.retryDict setObject:@(currentRetryCount) forKey:retryDictHash];
        }
    }
}

#pragma mark - Lazy

- (NSNetServiceBrowser *)borderRouterServiceBrowser {
    if (_borderRouterServiceBrowser == nil) {
        _borderRouterServiceBrowser = [NSNetServiceBrowser new];
        [_borderRouterServiceBrowser setDelegate:self];
    }
    return _borderRouterServiceBrowser;
}

@end

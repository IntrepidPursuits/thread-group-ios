 //
//  TGNetworkManager.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import "TGNetworkManager.h"
#import "TGRouter.h"
#import "TGRouterServiceBrowser.h"
#import "TGMeshcopManager.h"
#import "TGLogManager.h"

@interface TGNetworkManager() <TGRouterServiceBrowserDelegate>

@property (nonatomic, strong) TGRouterServiceBrowser *routerServiceBrowser;
@property (nonatomic, strong) TGNetworkManagerFindRoutersCompletionBlock findingNetworksCallback;
@property (nonatomic, strong) TGNetworkManagerCommissionerPetitionCompletionBlock petitionCompletionBlock;

@property (nonatomic, strong) NSMutableArray *threadServices;
@property (nonatomic, strong) TGMeshcopManager *meshcopManager;

@end

@implementation TGNetworkManager

+ (instancetype)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance commonInit];
    });
    return _sharedInstance;
}

- (void)commonInit {
    self.meshcopManager = [TGMeshcopManager sharedManager];
    [self.meshcopManager setDelegate:self];
    [self.meshcopManager setMeshCopEnabled:YES];
    
    self.routerServiceBrowser = [TGRouterServiceBrowser new];
    self.routerServiceBrowser.delegate = self;
    
    self.threadServices = [NSMutableArray new];
}

- (void)findLocalThreadNetworksCompletion:(TGNetworkManagerFindRoutersCompletionBlock)completion {
    NSLog(@"Searching For Border Routers");
    self.findingNetworksCallback = completion;
    [self.routerServiceBrowser startSearching];
}

- (void)connectToRouter:(TGRouter *)router completion:(TGNetworkManagerCommissionerPetitionCompletionBlock)completion {
    BOOL didChangeHost = [self.meshcopManager changeToHostAtAddress:router.ipAddress
                                                   commissionerPort:router.port
                                                        networkType:CA_ADAPTER_IP
                                                        networkName:router.networkName
                                                            secured:YES];
    
    if (didChangeHost == NO) {
        completion(nil);
        return;
    }
    
    NSLog(@"Changed to host <%@> at IP <%@> on port <%ld>", router.name, router.ipAddress, router.port);
    NSLog(@"Petitioning as commissioner to host <%@>", router.name);
    NSData *data = [self.meshcopManager petitionAsCommissioner:@"iphone"];
    NSLog(@"Data: %@", data);
}

- (void)connectDevice:(id)device completion:(TGNetworkManagerJoinDeviceCompletionBlock)completion {
    NSLog(@"Connecting to mock network ... waiting 3 seconds");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(nil);
    });
}

#pragma mark - Wifi SSID

+ (NSString *)currentWifiSSID {
    NSString *ssid;
    NSArray *interfaces = (__bridge NSArray *)CNCopySupportedInterfaces();

    for (NSString *interface in interfaces) {
        CFDictionaryRef networkDetails = CNCopyCurrentNetworkInfo((__bridge CFStringRef) interface);
        if (networkDetails) {
            ssid = (NSString *)CFDictionaryGetValue (networkDetails, kCNNetworkInfoKeySSID);
            CFRelease(networkDetails);
        }
    }
    return ssid;
}

#pragma mark - TGRouterServiceBrowserDelegate

- (void)TGRouterServiceBrowser:(TGRouterServiceBrowser *)browser didResolveRouter:(TGRouter *)router {
    [self.threadServices addObject:router];
    
    if (self.findingNetworksCallback) {
        self.findingNetworksCallback(self.threadServices, nil, YES);
    }
}

#pragma mark - Meshcop Manager Delegate

- (void)meshcopManagerDidReceiveCallbackResponse:(MCCallback_t)responseType responseResult:(TGNetworkCallbackResult *)callbackResult {
    NSLog(@"Received Callback Response");
    
    switch (responseType) {
        case COMM_PET:
            self.petitionCompletionBlock((TGNetworkCallbackComissionerPetitionResult *)callbackResult);
            break;
        case JOIN_URL:
            break;
        case JOIN_FIN:
            break;
        case ERROR_RESPONSE:
            break;
        case MGMT_PARAM_GET:
        case MGMT_PARAM_SET:
        default:
            break;
    }
}

@end

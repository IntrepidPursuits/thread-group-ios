 //
//  TGNetworkManager.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import "TGNetworkManager.h"
#import "TGDevice.h"
#import "TGRouter.h"
#import "TGQRCode.h"
#import "TGRouterServiceBrowser.h"
#import "TGMeshcopManager.h"
#import "TGLogManager.h"

static NSString * const kTGNetworkManagerRouterCommissionerIdentifier = @"ios.threadgroup";
static NSString * const kTGNetworkManagerDefaultJoinerIdentifier = @"threadgroup_device";

@interface TGNetworkManager() <TGRouterServiceBrowserDelegate>

@property (nonatomic, strong) TGRouterServiceBrowser *routerServiceBrowser;
@property (nonatomic, strong) TGNetworkManagerFindRoutersCompletionBlock findingNetworksCallback;
@property (nonatomic, strong) TGNetworkManagerCommissionerPetitionCompletionBlock petitionCompletionBlock;
@property (nonatomic, strong) TGNetworkManagerJoinDeviceCompletionBlock joinFinishedCompletionBlock;

@property (nonatomic, strong) NSMutableArray *threadServices;
@property (nonatomic, strong) TGMeshcopManager *meshcopManager;

@property (nonatomic, strong) NSMutableDictionary *managementSetCompletionBlocks;

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
    
    _viewState = TGNetworkManagerCommissionerStateDisconnected;
}

- (void)findLocalThreadNetworksCompletion:(TGNetworkManagerFindRoutersCompletionBlock)completion {
    NSLog(@"Searching For Border Routers");
    self.findingNetworksCallback = completion;
    [self.routerServiceBrowser startSearching];
}

- (void)connectToRouter:(TGRouter *)router completion:(TGNetworkManagerCommissionerPetitionCompletionBlock)completion {
    _viewState = TGNetworkManagerCommissionerStateConnecting;
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

    NSData *data = [self.meshcopManager petitionAsCommissioner:kTGNetworkManagerRouterCommissionerIdentifier];
    NSLog(@"Data: %@", data);
    
    NSLog(@"Debug -- Constructing a commissioner petition result");
    TGNetworkCallbackComissionerPetitionResult *result = [[TGNetworkCallbackComissionerPetitionResult alloc] init];
    result.commissionerIdentifer = @"Debug-Identifier";
    result.commissionerSessionIdentifier = 1000;
    result.hasAuthorizationFailed = (BOOL)(arc4random() % 2);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (result.hasAuthorizationFailed) {
            _viewState = TGNetworkManagerCommissionerStateDisconnected;
        } else {
            _viewState = TGNetworkManagerCommissionerStateConnected;
        }
        completion(result);
    });
}

- (void)connectDevice:(TGDevice *)device completion:(TGNetworkManagerJoinDeviceCompletionBlock)completion {
    self.joinFinishedCompletionBlock = completion;
    
    NSString *joinerIdentifier = (device.qrCode) ? device.qrCode.vendorName : kTGNetworkManagerDefaultJoinerIdentifier;
    NSString *credentials = device.connectCode;
    NSString *vendorModel = (device.qrCode) ? device.qrCode.vendorModel : kTGNetworkManagerDefaultJoinerIdentifier;
    NSString *vendorName = (device.qrCode) ? device.qrCode.vendorName : kTGNetworkManagerDefaultJoinerIdentifier;

    NSLog(@"Connecting to device %@ - %@. Connect Code <%@>", vendorName, vendorModel, credentials);
    // TODO: Set Joiner Identifier & Credentials in Meshcop
    
    TGNetworkCallbackJoinerFinishedResult *result = [TGNetworkCallbackJoinerFinishedResult new];
    result.joinerIdentifier = vendorName;
    result.state = ACCEPT;
    result.vendorModel = vendorModel;
    result.vendorName = vendorName;
    result.vendorSoftwareVersion = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(result);
    });
}

- (void)setManagementParameter:(MCMgmtParamID_t)parameter withValue:(id)value completion:(TGNetworkManagerManagementSetCompletionBlock)completion {
    NSString *token = [[TGMeshcopManager sharedManager] setManagementParameter:parameter withValue:value];
    [self.managementSetCompletionBlocks setObject:completion forKey:token];
}

- (void)setManagementSecurityPolicy:(MCMgmtSecurityPolicy_t *)policy completion:(TGNetworkManagerManagementSetCompletionBlock)completion {
    NSString *token = [[TGMeshcopManager sharedManager] setManagementSecurityPolicy:policy];
    [self.managementSetCompletionBlocks setObject:completion forKey:token];
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
            self.joinFinishedCompletionBlock((TGNetworkCallbackJoinerFinishedResult *)callbackResult);
            break;
        case ERROR_RESPONSE:
            break;
        case MGMT_PARAM_GET:
            break;
        case MGMT_PARAM_SET: {
            TGNetworkCallbackSetSettingResult *callback = (TGNetworkCallbackSetSettingResult *)callbackResult;
            NSString *token = [callback token];
            TGNetworkManagerManagementSetCompletionBlock completionBlock = [self.managementSetCompletionBlocks objectForKey:token];
            if (completionBlock) {
                completionBlock(callback);
                [self.managementSetCompletionBlocks removeObjectForKey:token];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Lazy

- (NSMutableDictionary *)managementSetCompletionBlocks {
    if (_managementSetCompletionBlocks == nil) {
        _managementSetCompletionBlocks = [NSMutableDictionary new];
    }
    return _managementSetCompletionBlocks;
}

@end

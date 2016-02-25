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
@property (nonatomic, strong) NSMutableDictionary *managementGetCompletionBlocks;

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
    self.managementGetCompletionBlocks = [NSMutableDictionary new];
    self.managementSetCompletionBlocks = [NSMutableDictionary new];
    
    _viewState = TGNetworkManagerCommissionerStateDisconnected;
}

#pragma mark - Networking Calls

- (void)findLocalThreadNetworksCompletion:(TGNetworkManagerFindRoutersCompletionBlock)completion {
    NSLog(@"Searching For Border Routers");
    self.findingNetworksCallback = completion;
    [self.routerServiceBrowser startSearching];
}

- (void)connectToRouter:(TGRouter *)router completion:(TGNetworkManagerCommissionerPetitionCompletionBlock)completion {
    _viewState = TGNetworkManagerCommissionerStateConnecting;
    self.petitionCompletionBlock = completion;
    
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

    self.petitionCompletionBlock = completion;
    if (router.passphrase) {
        [self.meshcopManager setPassphrase:router.passphrase];
    }
    [self.meshcopManager petitionAsCommissioner:kTGNetworkManagerRouterCommissionerIdentifier];
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
    result.state = credentials ? ACCEPT : REJECT;
    result.vendorModel = vendorModel;
    result.vendorName = vendorName;
    result.vendorSoftwareVersion = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(result);
    });
}

#pragma mark - Management Settings Get/Set

- (void)setManagementParameter:(MCMgmtParamID_t)parameter withValue:(id)value completion:(TGNetworkManagerManagementSetCompletionBlock)completion {
    NSString *token = [[TGMeshcopManager sharedManager] setManagementParameter:parameter withValue:value];
    
    if (token) {
        [self.managementSetCompletionBlocks setObject:completion forKey:token];
    } else if (completion) {
        completion(nil);
    }
}

- (void)setManagementSecurityPolicy:(MCMgmtSecurityPolicy_t *)policy completion:(TGNetworkManagerManagementSetCompletionBlock)completion {
    NSString *token = [[TGMeshcopManager sharedManager] setManagementSecurityPolicy:policy];
    if (token) {
        [self.managementSetCompletionBlocks setObject:completion forKey:token];
    } else if (completion) {
        completion(nil);
    }
}

- (void)fetchManagementParameter:(MCMgmtParamID_t)parameter completion:(TGNetworkManagerManagementGetCompletionBlock)completion {
    NSString *token = [[TGMeshcopManager sharedManager] fetchManagementParameters:@[@(parameter)] peekOnly:NO];
    
    if (token) {
        NSString *key = [self fetchManagementParameterCompletionKeyForParameter:parameter];
        [self.managementGetCompletionBlocks setObject:completion forKey:key];
    } else if (completion) {
        completion(nil);
    }
}

- (NSString *)fetchManagementParameterCompletionKeyForParameter:(MCMgmtParamID_t)parameter {
    return [@(parameter) stringValue];
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (responseType) {
            case COMM_PET: {
                TGNetworkCallbackComissionerPetitionResult *callback = (TGNetworkCallbackComissionerPetitionResult *)callbackResult;
                _viewState = (callback.hasAuthorizationFailed) ? TGNetworkManagerCommissionerStateDisconnected : TGNetworkManagerCommissionerStateConnected;
                self.petitionCompletionBlock(callback);
                break;
            }
            case JOIN_URL:
                break;
            case JOIN_FIN:
                self.joinFinishedCompletionBlock((TGNetworkCallbackJoinerFinishedResult *)callbackResult);
                break;
            case ERROR_RESPONSE:
                break;
            case MGMT_PARAM_GET: {
                TGNetworkCallbackFetchSettingResult *callback = (TGNetworkCallbackFetchSettingResult *)callbackResult;
                NSString *key = [self fetchManagementParameterCompletionKeyForParameter:callback.parameterIdentifier];
                TGNetworkManagerManagementGetCompletionBlock completionBlock = [self.managementGetCompletionBlocks objectForKey:key];
                if (completionBlock) {
                    completionBlock(callback);
                    [self.managementGetCompletionBlocks removeObjectForKey:key];
                }
                break;
            }
            case MGMT_PARAM_SET: {
                TGNetworkCallbackSetSettingResult *callback = (TGNetworkCallbackSetSettingResult *)callbackResult;
                NSString *key = [callback token];
                TGNetworkManagerManagementSetCompletionBlock completionBlock = [self.managementSetCompletionBlocks objectForKey:key];
                if (completionBlock) {
                    completionBlock(callback);
                    [self.managementSetCompletionBlocks removeObjectForKey:key];
                }
                break;
            }
            default:
                break;
        }
    });
}

#pragma mark - Lazy

- (NSMutableDictionary *)managementSetCompletionBlocks {
    if (_managementSetCompletionBlocks == nil) {
        _managementSetCompletionBlocks = [NSMutableDictionary new];
    }
    return _managementSetCompletionBlocks;
}

@end

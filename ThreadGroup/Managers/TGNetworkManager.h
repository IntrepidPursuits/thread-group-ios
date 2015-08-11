//
//  TGNetworkManager.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGMeshcopManager.h"
#import "TGNetworkCallbackResult.h"

typedef NS_ENUM(NSInteger, TGNetworkManagerCommissionerState) {
    TGNetworkManagerCommissionerStateDisconnected,
    TGNetworkManagerCommissionerStateConnecting,
    TGNetworkManagerCommissionerStateConnected
};

@class TGRouter;

typedef void (^TGNetworkManagerFindRoutersCompletionBlock)(NSArray *networks, NSError *error, BOOL stillSearching);
typedef void (^TGNetworkManagerCommissionerPetitionCompletionBlock)(TGNetworkCallbackComissionerPetitionResult *result);
typedef void (^TGNetworkManagerJoinDeviceCompletionBlock)(TGNetworkCallbackJoinerFinishedResult *result);
typedef void (^TGNetworkManagerManagementSetCompletionBlock)(TGNetworkCallbackSetSettingResult *result);

@interface TGNetworkManager : NSObject <TGMeshcopManagerDelegate>

@property (nonatomic) TGNetworkManagerCommissionerState viewState;

+ (instancetype)sharedManager;
+ (NSString *)currentWifiSSID;
- (void)findLocalThreadNetworksCompletion:(TGNetworkManagerFindRoutersCompletionBlock)completion;
- (void)connectToRouter:(TGRouter *)router completion:(TGNetworkManagerCommissionerPetitionCompletionBlock)completion;
- (void)connectDevice:(id)device completion:(TGNetworkManagerJoinDeviceCompletionBlock)completion;
- (void)setManagementParameter:(MCMgmtParamID_t)parameter withValue:(id)value completion:(TGNetworkManagerManagementSetCompletionBlock)completion;

@end

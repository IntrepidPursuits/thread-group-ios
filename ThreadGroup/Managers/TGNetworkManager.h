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

@class TGRouter;
typedef void (^TGNetworkManagerFindRoutersCompletionBlock)(NSArray *networks, NSError *error, BOOL stillSearching);
typedef void (^TGNetworkManagerCommissionerPetitionCompletionBlock)(TGNetworkCallbackComissionerPetitionResult *result, NSError *error);

@interface TGNetworkManager : NSObject <TGMeshcopManagerDelegate>

+ (instancetype)sharedManager;
+ (NSString *)currentWifiSSID;
- (void)findLocalThreadNetworksCompletion:(TGNetworkManagerFindRoutersCompletionBlock)completion;
- (void)connectToRouter:(TGRouter *)router completion:(TGNetworkManagerCommissionerPetitionCompletionBlock)completion;
- (void)connectDevice:(id)device completion:(void (^)(TGNetworkCallbackJoinerFinishedResult *result, NSError *error))completion;

@end

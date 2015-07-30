//
//  TGNetworkManager.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TGNetworkManagerFindRoutersCompletionBlock)(NSArray *networks, NSError **error, BOOL stillSearching);

@interface TGNetworkManager : NSObject

+ (instancetype)sharedManager;
+ (NSString *)currentWifiSSID;
- (void)findLocalThreadNetworksCompletion:(TGNetworkManagerFindRoutersCompletionBlock)completion;
- (void)connectToNetwork:(id)network completion:(void (^)(NSError **error))completion;
- (void)connectDevice:(id)device completion:(void (^)(NSError **error))completion;

@end

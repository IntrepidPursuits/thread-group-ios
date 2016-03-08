//
//  TGNetworkCallbackResult.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 8/4/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iotivity-csdk-thread/MeshCop.h>

@interface TGNetworkCallbackResult : NSObject

- (instancetype)initWithArguments:(va_list)args;

@end

// Callback Result Commissioner Petition
@interface TGNetworkCallbackComissionerPetitionResult : TGNetworkCallbackResult
@property (nonatomic, strong) NSString *commissionerIdentifer;
@property (nonatomic) NSInteger commissionerSessionIdentifier;
@property (nonatomic) BOOL hasAuthorizationFailed;
@end

// Callback Result Keep Alive
@interface TGNetworkCallbackComissionerKeepAliveResult : TGNetworkCallbackResult
@property (nonatomic) BOOL alive;
@end

// Callback Result Joiner Finished
@interface TGNetworkCallbackJoinerFinishedResult : TGNetworkCallbackResult
@property (nonatomic, strong) NSString *joinerIdentifier;
@property (nonatomic) MCState_t state;
@property (nonatomic, strong) NSString *provisioningURL;
@property (nonatomic, strong) NSString *vendorName;
@property (nonatomic, strong) NSString *vendorModel;
@property (nonatomic, strong) NSString *vendorSoftwareVersion;
@end

// Callback Result Joiner URL
@interface TGNetworkCallbackJoinResult : TGNetworkCallbackResult
@property (nonatomic, strong) NSString *provisioningURL;
@end

// Callback Result Error Response
@interface TGNetworkCallbackErrorResult : TGNetworkCallbackResult
@property (nonatomic, assign) NSInteger mcResult;
@property (nonatomic, assign) NSInteger caResult;
@property (nonatomic, strong) NSString *token;
@end

@interface TGNetworkCallbackFetchSettingResult : TGNetworkCallbackResult
@property (nonatomic, strong) id value;
@property (nonatomic, assign) MCMgmtParamID_t parameterIdentifier;
@end

@interface TGNetworkCallbackSetSettingResult : TGNetworkCallbackResult
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString *token;
@end
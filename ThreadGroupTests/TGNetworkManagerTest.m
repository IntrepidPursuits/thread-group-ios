//
//  TGNetworkManagerTest.m
//  ThreadGroup
//
//  Created by Stephen Wong on 3/3/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TGNetworkManager.h"
#import "TGRouterForTesting.h"
#import "TGDevice.h"


@interface TGNetworkManagerTest : XCTestCase
@property (strong, nonatomic) TGRouter *testRouter;
@property (strong, nonatomic) TGDevice *testDevice;
@end

@implementation TGNetworkManagerTest

- (TGRouter *)testRouter {
    if (_testRouter == nil) {
        _testRouter = [[TGRouterForTesting alloc] initTestRouterWithName:@"Test" networkName:@"ThreadNetwork" ipAddress:@"0.0.0.0" port:8000];
    }
    return _testRouter;
}

- (TGDevice *)testDevice {
    if (_testDevice == nil) {
        _testDevice = [[TGDevice alloc] initWithConnectCode:@"TEST"];
    }
    return _testDevice;
}

- (void)testSharedManager {
    XCTAssertNotNil([TGNetworkManager sharedManager]);
}

- (void)testConnectToRouter {
    [[TGNetworkManager sharedManager] connectToRouter:self.testRouter completion:^(TGNetworkCallbackComissionerPetitionResult *result) {
        if (result == nil) {
            XCTAssert(NO);
        } else {
            XCTAssert(YES);
        }
    }];
}

- (void)testConnectDevice {
    [[TGNetworkManager sharedManager] connectDevice:self.testDevice completion:^(TGNetworkCallbackJoinerFinishedResult *result) {
        if (result.state == ACCEPT) {
            XCTAssert(YES);
        } else {
            XCTAssert(NO);
        }
    }];
}

@end

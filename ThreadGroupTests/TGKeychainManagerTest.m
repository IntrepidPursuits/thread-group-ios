//
//  KeychainManagerTest.m
//  ThreadGroup
//
//  Created by Stephen Wong on 3/1/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TGKeychainManager.h"
#import "TGKeychainManager_private.h"
#import "TGRouterForTesting.h"

@interface KeyChainSpy : UICKeyChainStore
@property (readwrite) BOOL saveCalled;
@property (readwrite) BOOL getCalled;
@property (strong, nonatomic) NSData *routerData;
@end

@implementation KeyChainSpy

- (BOOL)setData:(NSData *)data forKey:(NSString *)key error:(NSError *__autoreleasing  _Nullable *)error {
    self.saveCalled = YES;
    self.routerData = data;
    return YES;
}

- (NSData *)dataForKey:(NSString *)key error:(NSError *__autoreleasing  _Nullable *)error {
    self.getCalled = YES;
    return self.routerData;
}

@end

@interface TGKeychainManagerTest : XCTestCase
@property (strong, nonatomic) TGRouter *testRouter;
@property (strong, nonatomic) TGKeychainManager *testKeychainManager;
@property (strong, nonatomic) KeyChainSpy *testKeyChainSpy;
@end

@implementation TGKeychainManagerTest

- (TGRouter *)testRouter {
    if (_testRouter == nil) {
        _testRouter = [[TGRouterForTesting alloc] initTestRouterWithName:@"Test" networkName:@"ThreadNetwork" ipAddress:@"0.0.0.0" port:8000];
    }
    return _testRouter;
}

- (void)setUp {
    [super setUp];
    self.testKeychainManager = [TGKeychainManager sharedManager];
    self.testKeyChainSpy = [[KeyChainSpy alloc] init];
    
    self.testKeychainManager.keychain = self.testKeyChainSpy;
}

- (void)testSharedManager {
    XCTAssertNotNil([TGKeychainManager sharedManager]);
}

- (void)testSaveRouterItem {
    [self.testKeychainManager saveRouterItem:self.testRouter withCompletion:nil];
    
    XCTAssert(self.testKeyChainSpy.saveCalled);
    XCTAssert([self.testKeyChainSpy.routerData isEqualToData:[self.testKeychainManager encodeRouterItem:self.testRouter]]);
}

- (void)testGetRouterItem {
    [self.testKeychainManager saveRouterItem:self.testRouter withCompletion:nil];
    
    TGRouter *storedRouter = [self.testKeychainManager getRouterItem];
    
    XCTAssert(self.testKeyChainSpy.getCalled);
    XCTAssert([storedRouter isEqualToRouter:self.testRouter]);
}

- (void)tearDown {
    self.testKeychainManager.keychain = [self.testKeychainManager keychain];
    [super tearDown];
}


@end

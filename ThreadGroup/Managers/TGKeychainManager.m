//
//  TGKeychainManager.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/24/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UICKeychainStore/UICKeyChainStore.h>
#import "TGKeychainManager.h"
#import "TGRouter.h"

static NSString * const kTGKeychainStoreIdentifier = @"io.intrepid.thread-group-ios";
static NSString * const KTGRouterObjectKey = @"kTGRouterObjectKey";

@interface TGKeychainManager()
@property (strong, nonatomic) UICKeyChainStore *keychain;
@property (strong, nonatomic) NSKeyedArchiver *archiver;
@property (strong, nonatomic) NSKeyedUnarchiver *unArchiver;
@end

@implementation TGKeychainManager

+ (instancetype)sharedManager {
    static TGKeychainManager *shared = nil;
    static dispatch_once_t singleToken;
    dispatch_once(&singleToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)saveRouterItem:(TGRouter *)router withCompletion:(void(^)(NSError *error))completion {
    NSData *objectData = [self encodeRouterItem:router];
    NSError *saveError;
    [self.keychain setData:objectData forKey:KTGRouterObjectKey error:&saveError];
    if (completion) {
        completion(saveError);
    }
}

- (void)getRouterItemWithCompletion:(void(^)(TGRouter *router, NSError *error))completion {
    NSError *getError;
    NSData *data = [self.keychain dataForKey:KTGRouterObjectKey error:&getError];
    TGRouter *router = [self decodeRouterItem:data];
    if (completion) {
        completion(router, getError);
    }
}

#pragma mark - Encode/Decode TGRouter

- (NSData *)encodeRouterItem:(TGRouter *)router {
    return [NSKeyedArchiver archivedDataWithRootObject:router];
}

- (TGRouter *)decodeRouterItem:(NSData *)data {
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - UICKeychainStore

- (UICKeyChainStore *)keychain {
    if (!_keychain) {
        _keychain = [[UICKeyChainStore alloc] initWithService:kTGKeychainStoreIdentifier];
    }
    return _keychain;
}

@end

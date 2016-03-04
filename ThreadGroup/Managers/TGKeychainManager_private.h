//
//  TGKeychainManager_private.h
//  ThreadGroup
//
//  Created by Stephen Wong on 3/2/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

#import <UICKeychainStore/UICKeyChainStore.h>

@interface TGKeychainManager()
@property (strong, nonatomic) UICKeyChainStore *keychain;
@property (strong, nonatomic) NSKeyedArchiver *archiver;
@property (strong, nonatomic) NSKeyedUnarchiver *unArchiver;

- (NSData *)encodeRouterItem:(TGRouter *)router;
- (UICKeyChainStore *)keychain;
@end

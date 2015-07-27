//
//  TGKeychainManager.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/24/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TGRouter;

@interface TGKeychainManager : NSObject

+ (instancetype)sharedManager;
- (void)saveRouterItem:(TGRouter *)router withCompletion:(void(^)(NSError *error))completion;
- (TGRouter *)getRouterItem;

@end

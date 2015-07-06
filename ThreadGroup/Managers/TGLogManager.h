//
//  TGLogManager.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/2/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGLogManager : NSObject

+ (instancetype)sharedManager;

- (void)logMessage:(NSString *)message;
- (NSArray *)getLog;
- (void)resetLog;

@end

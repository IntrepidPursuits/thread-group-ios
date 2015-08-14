//
//  TGLogManager.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/2/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSLog(args...) _Log(@"DEBUG ", __FILE__,__LINE__,__PRETTY_FUNCTION__,args);

@interface TGLogManager : NSObject

+ (instancetype)sharedManager;

void _Log(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format,...);
- (NSString *)getLog;
- (void)resetLog;


@end

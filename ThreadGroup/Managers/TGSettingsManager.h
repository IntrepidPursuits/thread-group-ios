//
//  TGSettingsManager.h
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGSettingsManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)debugModeEnabled;
- (void)setDebugModeEnabled:(BOOL)enabled;

@end

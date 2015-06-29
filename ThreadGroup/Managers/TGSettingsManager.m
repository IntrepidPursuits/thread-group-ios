//
//  TGSettingsManager.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSettingsManager.h"

static NSString * const TGSettingsManagerDebugModeEnabled = @"TGSettingsManagerDebugModeEnabled";
static NSString * const TGSettingsManagerHasSeenScannerTutorial = @"TGSettingsManagerHasSeenScannerTutorial";

@implementation TGSettingsManager

+ (instancetype)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Public Settings

- (BOOL)debugModeEnabled {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:TGSettingsManagerDebugModeEnabled] boolValue];
}

- (void)setDebugModeEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setObject:@(enabled) forKey:TGSettingsManagerDebugModeEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)hasSeenScannerTutorial {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:TGSettingsManagerHasSeenScannerTutorial] boolValue];
}

- (void)setHasSeenScannerTutorial:(BOOL)hasSeen {
    [[NSUserDefaults standardUserDefaults] setObject:@(hasSeen) forKey:TGSettingsManagerHasSeenScannerTutorial];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

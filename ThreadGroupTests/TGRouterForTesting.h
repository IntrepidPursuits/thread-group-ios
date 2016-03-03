//
//  TGRouterForTesting.h
//  ThreadGroup
//
//  Created by Stephen Wong on 3/3/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

#import "TGRouter.h"

@interface TGRouterForTesting: TGRouter
- (instancetype)initTestRouterWithName:(NSString *)name networkName:(NSString *)networkName ipAddress:(NSString *)ipAddress port:(NSInteger)port;
@end

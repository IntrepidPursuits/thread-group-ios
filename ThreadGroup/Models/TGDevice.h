//
//  TGDevice.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A representation of a thread enabled device. 
 */
@interface TGDevice : NSObject

- (instancetype)initWithConnectCode:(NSString *)connectCode;
- (void)isConnectCodeValidWithCompletion:(void(^)(BOOL success))completion;

@end

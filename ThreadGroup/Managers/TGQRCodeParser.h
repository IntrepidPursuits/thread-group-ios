//
//  TGQRCodeParser.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/28/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TGQRCode;

@interface TGQRCodeParser : NSObject
+ (TGQRCode *)parseDataFromString:(NSString *)dataString;
@end

//
//  TGQRCodeParser.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/28/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TGQRCodeParser;
@class TGDevice;

@protocol TGQRCodeParserDelegate <NSObject>
- (void)parser:(TGQRCodeParser *)parser didParseDevice:(TGDevice *)device;
//need to refactor TGDevice to include all the information that the QR code has
@end

@interface TGQRCodeParser : NSObject
@property (nonatomic, weak) id<TGQRCodeParserDelegate> delegate;
- (void)parseDataFromString:(NSString *)dataString;
@end

//
//  TGQRCodeParser.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/28/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGQRCodeParser.h"
#import "TGDevice.h"

@implementation TGQRCodeParser

- (void)parseDataFromString:(NSString *)dataString {
    NSArray *parameters = [self parseQueryString:dataString];
    TGDevice *device = [[TGDevice alloc] initWithParamaters:parameters];
    if ([self.delegate respondsToSelector:@selector(parser:didParseDevice:)]) {
        [self.delegate parser:self didParseDevice:device];
    }
}

- (NSArray *)parseQueryString:(NSString *)string {
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.query = string;
    return urlComponents.queryItems;
}

@end

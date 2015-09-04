//
//  TGQRCodeParser.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/28/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGQRCodeParser.h"
#import "TGQRCode.h"

@implementation TGQRCodeParser

+ (TGQRCode *)parseDataFromString:(NSString *)dataString {
    NSArray *parameters = [TGQRCodeParser parseQueryString:dataString];
    return [TGQRCode qrCodeWithParameters:parameters];
}

+ (NSArray *)parseQueryString:(NSString *)string {
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.query = string;
    return urlComponents.queryItems;
}

@end

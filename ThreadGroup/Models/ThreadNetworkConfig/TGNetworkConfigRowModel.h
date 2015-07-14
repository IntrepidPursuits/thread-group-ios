//
//  TGNetworkConfigRowModel.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TGNetworkConfigRowType) {
    TGNetworkConfigRowTypeGeneral,
    TGNetworkConfigRowTypeInfo,
    TGNetworkConfigRowTypeSelectable
};

@interface TGNetworkConfigRowModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (nonatomic) TGNetworkConfigRowType rowType;

+ (TGNetworkConfigRowModel *)rowModelWithTitle:(NSString *)title
                                       rowType:(TGNetworkConfigRowType)rowType;

@end

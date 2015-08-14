//
//  NSDate+ThreadGroup.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 8/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NSDate+ThreadGroup.h"

@implementation NSDate (ThreadGroup)

+ (NSString *)currentDateAndTimeString {
    NSDate *currentDate = [NSDate date];
    return [NSDateFormatter localizedStringFromDate:currentDate
                                          dateStyle:NSDateFormatterLongStyle
                                          timeStyle:NSDateFormatterShortStyle];
}

@end

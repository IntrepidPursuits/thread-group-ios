//
//  TGLogManager.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/2/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <asl.h>
#import "TGLogManager.h"

static const char* kTGLogFacilityConstant = "com.threadgroup.log";

@interface TGLogManager()

@property (nonatomic) aslclient client;
@property (nonatomic) aslmsg queryMessage;
@property (nonatomic) aslmsg recordMessage;

@end
@implementation TGLogManager

+ (instancetype)sharedManager {
    static TGLogManager *shared = nil;
    static dispatch_once_t singleToken;
    dispatch_once(&singleToken, ^{
        shared = [[self alloc] init];
        [shared setup];
    });
    return shared;
}

- (void)logMessage:(NSString *)message {
    const char *msg = [message UTF8String];
    //We will set all app logs to ASL_LEVEL_NOTICE
    asl_log(self.client, self.recordMessage, ASL_LEVEL_NOTICE, "%s", msg);
}

- (NSString *)getLog {
    NSMutableArray *consoleLog = [NSMutableArray array];

    aslresponse response = asl_search(self.client, self.queryMessage);

    aslmsg message;
    while((message = asl_next(response)))
    {
        const char *msg = asl_get(message, ASL_KEY_MSG);
        const char *time = asl_get(message, ASL_KEY_TIME);
        NSDate *dateFromTime = [NSDate dateWithTimeIntervalSince1970:(strtod(time, NULL))];

        NSString *timeString = [self convertDateToLocalTimeZone:dateFromTime];
        NSString *msgString = [NSString stringWithCString:msg encoding:NSUTF8StringEncoding];

        [consoleLog addObject:[NSString stringWithFormat:@"%@\n%@", timeString, msgString]];
    }

    asl_release(response);

    //Two newline characters are needed to actually make a newline between the items.
    NSString *logs = [consoleLog componentsJoinedByString:@"\n\n"];

    return logs;
}

- (void)resetLog {
    //The way I "clear" the log is to change the time key on the query to now 
    //I will get an empty log back
    NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
    NSString *timeFilter = [NSString stringWithFormat:@"%f", timeInterval];
    const char * timeFilterStr = [timeFilter cStringUsingEncoding:NSUTF8StringEncoding];
    asl_set_query(self.queryMessage, ASL_KEY_TIME, timeFilterStr, ASL_QUERY_OP_GREATER);
}

#pragma mark - Setup

- (void)setup {
    //Set a unique facility so we can target our log queries and entries
    self.client = asl_open(NULL, kTGLogFacilityConstant, ASL_OPT_STDERR);

    self.queryMessage = asl_new(ASL_TYPE_QUERY);
    self.recordMessage = asl_new(ASL_TYPE_MSG);

    //Get log who has the unique ASL_KEY_FACILITY
    asl_set_query(self.queryMessage, ASL_KEY_FACILITY, kTGLogFacilityConstant, ASL_QUERY_OP_EQUAL);

    //On device, log entries are only visible to root by default.
    //We need to set the ASL_KEY_READ_UID to -1 in order for the calling process to see its log entries
    asl_set(self.recordMessage, ASL_KEY_READ_UID, "-1");
}

#pragma mark - Helper

- (NSString *)convertDateToLocalTimeZone:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    return [dateFormatter stringFromDate:date];
}
@end

//
//  TGLogManager.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/2/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <asl.h>
#import "TGLogManager.h"

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
    //Create message and send that to ASL
    const char *msg = [message UTF8String];
    asl_log(self.client, self.recordMessage, ASL_LEVEL_NOTICE, "%s", msg);
}

- (NSArray *)getLog {
    //Generate a query and get all logs from ASL that return the logs at the level we have specified and perhaps the facility as well in order to make sure that we only get the logs we want
    NSMutableArray *consoleLog = [NSMutableArray array];

    asl_set_query(self.queryMessage, ASL_KEY_MSG, NULL, ASL_QUERY_OP_LESS_EQUAL);
    asl_set(self.queryMessage, ASL_KEY_FACILITY, "io.intrepid.threadgroup");
    aslresponse response = asl_search(self.client, self.queryMessage);

    asl_free(self.queryMessage);

    aslmsg message;
    while((message = asl_next(response)))
    {
        const char *msg = asl_get(message, ASL_KEY_MSG);
        [consoleLog addObject:[NSString stringWithCString:msg encoding:NSUTF8StringEncoding]];
    }

    asl_release(response);
    asl_close(self.client);
    
    return consoleLog;
}

- (void)clearLog {
    //Somehow go thru ASl and clear all the logs for the app only.
}

#pragma mark - Setup

- (void)setup {
    self.client = asl_open(NULL, NULL, ASL_OPT_STDERR);
    asl_set(self.client, ASL_KEY_FACILITY, "io.intrepid.threadgroup");

    self.queryMessage = asl_new(ASL_TYPE_QUERY);
    self.recordMessage = asl_new(ASL_TYPE_MSG);
}

- (NSArray *)console {
    NSMutableArray *consoleLog = [NSMutableArray array];

    aslclient client = asl_open(NULL, NULL, ASL_OPT_STDERR);


    aslmsg query = asl_new(ASL_TYPE_QUERY);
    asl_set_query(query, ASL_KEY_MSG, NULL, ASL_QUERY_OP_NOT_EQUAL);
    aslresponse response = asl_search(client, query);

    asl_free(query);

    aslmsg message;
    while((message = asl_next(response)))
    {

        const char *msg = asl_get(message, ASL_KEY_MSG);
        [consoleLog addObject:[NSString stringWithCString:msg encoding:NSUTF8StringEncoding]];
    }

    asl_release(response);
    asl_close(client);
    
    return consoleLog;
}

@end

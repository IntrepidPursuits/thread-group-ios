//
//  TGLogManager.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/2/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGLogManager.h"
#import "NSDate+ThreadGroup.h"

static NSString * const kTGLogFacilityString = @"com.threadgroup.log";

@interface TGLogManager()

@property (strong, nonatomic) NSString *filePath;
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

void _Log(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format,...) {
    NSString *currentDateAndTime = [NSDate currentDateAndTimeString];
    va_list ap;
    va_start (ap, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@%@\n\n", format, currentDateAndTime] arguments:ap];
    va_end (ap);
    //Print log to console with more information
    fprintf(stderr,"%s %s %50s: %3d - %s", [currentDateAndTime UTF8String], [prefix UTF8String], funcName, lineNumber, [format UTF8String]);
    append(msg);
}

void append(NSString *msg) {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:kTGLogFacilityString];

    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        BOOL isFileCreationSuccessful= [[NSFileManager defaultManager] createFileAtPath:path
                                                                               contents:nil
                                                                             attributes:nil];
        fprintf(stderr, "file creation %s", isFileCreationSuccessful ? "successful" :"failed");
    }
    // append
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

- (NSString *)getLog {
    NSError *error = nil;
    NSString *log = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        //NOTE: After reseting the log, we call getLog. We will receive an error. Expected because there is no log!
        fprintf(stderr, "Log fetch failed with error: %s", [error.description UTF8String]);
        return nil;
    }
    return log;
}

- (void)resetLog {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:&error];
    if (error) {
        fprintf(stderr, "Log deletion failed with error: %s", [error.description UTF8String]);
    }

}

#pragma mark - Setup

- (void)setup {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:kTGLogFacilityString];
    _filePath = path;
}

@end

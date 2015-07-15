//
//  TGNetworkConfigModel.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

@import UIKit;
#import "TGNetworkConfigModel.h"
#import "TGNetworkConfigHeaderModel.h"

@interface TGNetworkConfigModel()

@property (strong, nonatomic) NSArray *sections;

@end

@implementation TGNetworkConfigModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    //General
    TGNetworkConfigHeaderModel *generalHeader = [[TGNetworkConfigHeaderModel alloc] init];
    generalHeader.title = @"GENERAL";

    TGNetworkConfigRowModel *name = [TGNetworkConfigRowModel rowModelWithTitle:@"NAME"
                                                                       rowType:TGNetworkConfigRowTypeGeneral
                                                                    actionType:TGNetworkConfigActionName];
    name.subtitle = @"Intrepid Thread Network";
    TGNetworkConfigRowModel *channel = [TGNetworkConfigRowModel rowModelWithTitle:@"CHANNEL"
                                                                          rowType:TGNetworkConfigRowTypeGeneral
                                                                       actionType:TGNetworkConfigActionChannel];
    channel.subtitle = @"15";
    TGNetworkConfigRowModel *security = [TGNetworkConfigRowModel rowModelWithTitle:@"SECURITY"
                                                                           rowType:TGNetworkConfigRowTypeGeneral
                                                                        actionType:TGNetworkConfigActionSecurity];
    security.subtitle = @"Out-of-band restricted";
    TGNetworkConfigRowModel *threadPassword = [TGNetworkConfigRowModel rowModelWithTitle:@"CHANGE THREAD ADMIN PASSWORD..."
                                                                                 rowType:TGNetworkConfigRowTypeSelectable
                                                                              actionType:TGNetworkConfigActionPassword];
    generalHeader.rows = @[name, channel, security, threadPassword];

    //Network Info
    TGNetworkConfigHeaderModel *infoHeader = [[TGNetworkConfigHeaderModel alloc] init];
    infoHeader.title = @"NETWORK INFO";

    TGNetworkConfigRowModel *panID = [TGNetworkConfigRowModel rowModelWithTitle:@"PANID"
                                                                        rowType:TGNetworkConfigRowTypeInfo
                                                                     actionType:TGNetworkConfigActionNone];
    panID.subtitle = @"12344567";
    TGNetworkConfigRowModel *xPanID = [TGNetworkConfigRowModel rowModelWithTitle:@"XPANID"
                                                                         rowType:TGNetworkConfigRowTypeInfo
                                                                      actionType:TGNetworkConfigActionNone];
    xPanID.subtitle = @"0987876524359";
    TGNetworkConfigRowModel *masterKey = [TGNetworkConfigRowModel rowModelWithTitle:@"MASTER KEY"
                                                                            rowType:TGNetworkConfigRowTypeInfo
                                                                         actionType:TGNetworkConfigActionNone];
    masterKey.subtitle = @"54as8u9567lk";
    TGNetworkConfigRowModel *keySequence = [TGNetworkConfigRowModel rowModelWithTitle:@"KEY SEQUENCE"
                                                                              rowType:TGNetworkConfigRowTypeInfo
                                                                           actionType:TGNetworkConfigActionNone];
    keySequence.subtitle = @"45425673jd99782kkl";
    TGNetworkConfigRowModel *meshLocalULA = [TGNetworkConfigRowModel rowModelWithTitle:@"MESH LOCAL ULA"
                                                                               rowType:TGNetworkConfigRowTypeInfo
                                                                            actionType:TGNetworkConfigActionNone];
    meshLocalULA.subtitle = @"ULA3779992000kksss";
    infoHeader.rows = @[panID, xPanID, masterKey, keySequence, meshLocalULA];

    self.sections = @[generalHeader, infoHeader];
}

#pragma mark - Getter

- (NSInteger)numberOfSections {
    return [self.sections count];
}

- (NSInteger)numberofRowsInSection:(NSInteger)section {
    return [[self.sections[section] rows] count];
}

- (TGNetworkConfigRowModel *)rowForIndexPath:(NSIndexPath *)indexPath {
    TGNetworkConfigHeaderModel *header = self.sections[indexPath.section];
    return  header.rows[indexPath.row];
}

- (NSString *)headerTitleForSection:(NSInteger)section {
    TGNetworkConfigHeaderModel *header = self.sections[section];
    return header.title;
}

@end

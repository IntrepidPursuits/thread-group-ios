//
//  TGTableView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGTableView.h"
#import "TGTableViewCell.h"

static NSString * const kTGTableViewCellName = @"TGTableViewCell";
static NSString * const kTGTableViewCellReuseIdentifier = @"TGTableViewCell";

@interface TGTableView()

@end

@implementation TGTableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerNib:[UINib nibWithNibName:kTGTableViewCellName bundle:nil] forCellReuseIdentifier:kTGTableViewCellReuseIdentifier];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTGTableViewCellReuseIdentifier forIndexPath:indexPath];
    cell.routerNameLabel.text = @"Test";
    cell.networkNameLabel.text = @"Network test";
    cell.networkAddressLabel.text = @"3434234234";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

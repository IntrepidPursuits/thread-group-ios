//
//  TGTableView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGTableView.h"
#import "TGTableViewCell.h"
#import "TGRouterItem.h"

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
    return self.networkItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTGTableViewCellReuseIdentifier forIndexPath:indexPath];
    TGRouterItem *item = self.networkItems[indexPath.item];
    cell.routerNameLabel.text = item.name;
    cell.networkNameLabel.text = item.networkName;
    cell.networkAddressLabel.text = item.networkAddress;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TGRouterItem *itemSelected = self.networkItems[indexPath.item];
    [self.tableViewDelegate tableView:self didSelectItem:itemSelected];
}

@end

//
//  TGTableView.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGTableView.h"
#import "TGTableViewCell.h"
#import "TGRouter.h"

static NSString * const kTGTableViewCellName = @"TGTableViewCell";
static NSString * const kTGTableViewCellReuseIdentifier = @"TGTableViewCell";

@interface TGTableView()

@end

@implementation TGTableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerNib:[UINib nibWithNibName:kTGTableViewCellName bundle:nil] forCellReuseIdentifier:kTGTableViewCellReuseIdentifier];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = self;
    self.delegate = self;
}

#pragma mark - DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.networkItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTGTableViewCellReuseIdentifier forIndexPath:indexPath];
    TGRouter *item = self.networkItems[indexPath.item];
    [cell configureWithRouter:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark - Public

- (void)highlightRouter:(TGRouter *)item {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.networkItems indexOfObject:item] inSection:0];
    [self selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TGRouter *selectedRouter = self.networkItems[indexPath.item];
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectItem:)]) {
        [self.tableViewDelegate tableView:self didSelectItem:selectedRouter];
    }
}

@end

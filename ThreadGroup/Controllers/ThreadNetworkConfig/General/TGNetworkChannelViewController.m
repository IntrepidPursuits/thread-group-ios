//
//  TGNetworkChannelViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkChannelViewController.h"
#import "TGNetworkChannelCell.h"
#import "UIFont+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"

static NSString * const kTGNetworkChannelReuseIdentifier = @"TGNetworkChannelReuseIdentifier";
static NSInteger const kTGMeshCopChannelMinimumNumber = 11;
static NSInteger const kTGMeshCopChannelMaximumNumber = 26;

@interface TGNetworkChannelViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *channels;

@end

@implementation TGNetworkChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Channel"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView registerNib:[UINib nibWithNibName:@"TGNetworkChannelCell" bundle:nil] forCellReuseIdentifier:kTGNetworkChannelReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TGNetworkChannelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTGNetworkChannelReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.channels[indexPath.row];
    if (indexPath.row == [self.channels indexOfObject:[NSString stringWithFormat:@"%d", self.selectedIndex]]) {
        cell.isCheckMarkHidden = NO;
    } else {
        cell.isCheckMarkHidden = YES;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = [self.channels[indexPath.row] integerValue];
    [self showCheckmark:YES forCellAtIndexPath:indexPath];
    [self.tableView reloadData];
}

- (void)showCheckmark:(BOOL)show forCellAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[TGNetworkChannelCell class]]) {
        TGNetworkChannelCell *channelCell = (TGNetworkChannelCell *)cell;
        channelCell.isCheckMarkHidden = show;
    }
}

#pragma mark - Lazy

- (NSArray *)channels {
    if (!_channels) {
        NSMutableArray *mutableChannels = [NSMutableArray new];
        for (int i = kTGMeshCopChannelMinimumNumber; i <= kTGMeshCopChannelMaximumNumber; i++) {
            [mutableChannels addObject:[NSString stringWithFormat:@"%d", i]];
        }
        _channels = mutableChannels;
    }
    return _channels;
}

@end

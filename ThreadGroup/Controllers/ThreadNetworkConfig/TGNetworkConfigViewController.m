//
//  TGNetworkConfigViewController.m
//  ThreadGroup
//
//  Created by Lu Quan Tan on 7/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkConfigViewController.h"
#import "TGGeneralCell.h"
#import "UIFont+ThreadGroup.h"
#import "UIColor+ThreadGroup.h"
#import "TGHeaderView.h"
#import "TGNetworkInfoCell.h"
#import "TGSelectableCell.h"
#import "TGNetworkConfigModel.h"
#import "TGNetworkConfigRowModel.h"
#import "TGNetworkNameViewController.h"
#import "TGNetworkChannelViewController.h"
#import "TGNetworkSecurityViewController.h"

static NSString * const kTGGeneralCellReuseIdentifier = @"TGGeneralCellReuseIdentifier";
static NSString * const kTGNetworkInfoCellReuseIdentifier = @"TGNetworkInfoCellReuseIdentifier";
static NSString * const kTGSelectableCellReuseIdentifier = @"TGSelectableCellReuseIdentifier";
static NSString * const KTGHeaderViewReuseIdentifier = @"TGHeaderViewReuseIdentifier";
static CGFloat const kTGSectionHeaderHeight = 36.0f;

@interface TGNetworkConfigViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TGNetworkConfigModel *model;
@end

@implementation TGNetworkConfigViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewSetup];
}

- (void)tableViewSetup {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layoutMargins = UIEdgeInsetsZero;

    [self.tableView registerNib:[UINib nibWithNibName:@"TGGeneralCell" bundle:nil] forCellReuseIdentifier:kTGGeneralCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TGNetworkInfoCell" bundle:nil] forCellReuseIdentifier:kTGNetworkInfoCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TGSelectableCell" bundle:nil] forCellReuseIdentifier:kTGSelectableCellReuseIdentifier];
    [self.tableView registerClass:[TGHeaderView class] forHeaderFooterViewReuseIdentifier:KTGHeaderViewReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.navigationController.navigationBar.backItem.title = @"";
    [self.navigationItem setTitle:@"Network Settings"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.model numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model numberofRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TGNetworkConfigRowModel *row = [self.model rowForIndexPath:indexPath];
    UITableViewCell *returnCell;
    switch (row.rowType) {
        case TGNetworkConfigRowTypeGeneral: {
            TGGeneralCell *generalCell = [self.tableView dequeueReusableCellWithIdentifier:kTGGeneralCellReuseIdentifier forIndexPath:indexPath];
            generalCell.textLabel.text = row.title;
            generalCell.detailTextLabel.text = row.subtitle;
            returnCell = generalCell;
            break;
        }
        case TGNetworkConfigRowTypeSelectable: {
            TGSelectableCell *selectableCell = [self.tableView dequeueReusableCellWithIdentifier:kTGSelectableCellReuseIdentifier forIndexPath:indexPath];
            selectableCell.textLabel.text = row.title;
            returnCell = selectableCell;
            break;
        }
        case TGNetworkConfigRowTypeInfo: {
            TGNetworkInfoCell *infoCell = [self.tableView dequeueReusableCellWithIdentifier:kTGNetworkInfoCellReuseIdentifier forIndexPath:indexPath];
            infoCell.textLabel.text = row.title;
            infoCell.detailTextLabel.text = row.subtitle;
            returnCell = infoCell;
            break;
        }
        default:
            NSAssert(YES, @"Row model should have a row type");
            break;
    }
    return returnCell;
}

#pragma mark - TableView header

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TGHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:KTGHeaderViewReuseIdentifier];
    [headerView setTitle:[self.model headerTitleForSection:section]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTGSectionHeaderHeight;
}

#pragma mark - TableView footer

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //This is to essentially remove the footer.
    //Returning 0.0f will set the footer height to some default value
    return FLT_MIN;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TGNetworkConfigRowModel *row = [self.model rowForIndexPath:indexPath];
    switch (row.actionType) {
        case TGNetworkConfigActionName: {
            TGNetworkNameViewController *nameVC = [[TGNetworkNameViewController alloc] initWithNibName:nil bundle:nil];
            nameVC.textFieldText = row.subtitle;
            [self.navigationController pushViewController:nameVC animated:YES];
            break;
        }
        case TGNetworkConfigActionChannel: {
            TGNetworkChannelViewController *channelVC = [[TGNetworkChannelViewController alloc] initWithNibName:nil bundle:nil];
            channelVC.selectedIndex = [row.subtitle integerValue];
            [self.navigationController pushViewController:channelVC animated:YES];
            break;
        }
        case TGNetworkConfigActionSecurity: {
            TGNetworkSecurityViewController *securityVC = [[TGNetworkSecurityViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:securityVC animated:YES];
            break;
        }
        case TGNetworkConfigActionPassword: {
            break;
        }
        default:
            break;
    }
}

#pragma mark - Lazy Load

- (TGNetworkConfigModel *)model {
    if (!_model) {
        _model = [[TGNetworkConfigModel alloc] init];
    }
    return _model;
}

@end

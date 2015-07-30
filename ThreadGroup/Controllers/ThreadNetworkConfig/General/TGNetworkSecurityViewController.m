//
//  TGNetworkSecurityViewController.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkSecurityViewController.h"
#import "TGNetworkPickerCell.h"
#import "TGNetworkSliderCell.h"
#import "TGHeaderView.h"

static NSString * const kTGNetworkPickerCellReuseIdentifier = @"TGNetworkPickerCellReuseIdentifier";
static NSString * const kTGNetworkSliderCellReuseIdentifier = @"TGNetworkSliderCellReuseIdentifier";
static NSString * const KTGHeaderViewReuseIdentifier = @"TGHeaderViewReuseIdentifier";
static CGFloat const kTGHeaderViewHeightConstant = 36.0f;

@interface TGNetworkSecurityViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TGNetworkSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.estimatedRowHeight = 50.0f;

    [self.tableView registerNib:[UINib nibWithNibName:@"TGNetworkPickerCell" bundle:nil] forCellReuseIdentifier:kTGNetworkPickerCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TGNetworkSliderCell" bundle:nil] forCellReuseIdentifier:kTGNetworkSliderCellReuseIdentifier];
    [self.tableView registerClass:[TGHeaderView class] forHeaderFooterViewReuseIdentifier:KTGHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *returnCell;
    switch (indexPath.section) {
        case 0: {
            TGNetworkPickerCell *pickerCell = [self.tableView dequeueReusableCellWithIdentifier:kTGNetworkPickerCellReuseIdentifier forIndexPath:indexPath];
            pickerCell.isCheckMarkHidden = YES;
            pickerCell.textLabel.text = @"Security Options";
            returnCell = pickerCell;
            break;
        }
        case 1: {
            TGNetworkSliderCell *sliderCell = [self.tableView dequeueReusableCellWithIdentifier:kTGNetworkSliderCellReuseIdentifier forIndexPath:indexPath];
            returnCell = sliderCell;
            break;
        }
        default:
            break;
    }
    return returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTGHeaderViewHeightConstant;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TGHeaderView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:KTGHeaderViewReuseIdentifier];
    if (section == 0) {
        [header setTitle:@"Security"];
    } else {
        [header setTitle:@"Key Rotation Duration"];
    }
    return header;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[TGNetworkPickerCell class]]) {
        TGNetworkPickerCell *pickerCell = (TGNetworkPickerCell *)cell;
        pickerCell.isCheckMarkHidden = !pickerCell.isCheckMarkHidden;
    }
}

@end

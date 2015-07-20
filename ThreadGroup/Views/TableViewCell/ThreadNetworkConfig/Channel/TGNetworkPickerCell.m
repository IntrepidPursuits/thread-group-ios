//
//  TGNetworkChannelCell.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkPickerCell.h"

@implementation TGNetworkPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)setIsCheckMarkHidden:(BOOL)isCheckMarkHidden {
    _isCheckMarkHidden = isCheckMarkHidden;
    if (isCheckMarkHidden) {
        self.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end

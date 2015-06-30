//
//  TGTableViewCell.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/17/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGTableViewCell.h"
#import "TGRouterItem.h"

@interface TGTableViewCell()

//TODO; Refactor this to take a network object
@property (weak, nonatomic) IBOutlet UILabel *routerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkAddressLabel;
@property (strong, nonatomic) TGRouterItem *router;

@end

@implementation TGTableViewCell

#pragma mark - Public

- (void)configureWithRouter:(TGRouterItem *)router {
    self.router = router;
    [self updateLayout];
}

#pragma mark - Layout

- (void)updateLayout {
    self.routerNameLabel.text = self.router.name;
    self.networkNameLabel.text = @"A Network";
    self.networkAddressLabel.text = @"DE:AD:BE:EF";
}

@end

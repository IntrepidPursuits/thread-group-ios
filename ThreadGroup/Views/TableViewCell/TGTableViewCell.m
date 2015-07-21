//
//  TGTableViewCell.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/17/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGTableViewCell.h"
#import "TGRouter.h"

@interface TGTableViewCell()

//TODO; Refactor this to take a network object
@property (weak, nonatomic) IBOutlet UILabel *routerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkAddressLabel;
@property (strong, nonatomic) TGRouter *router;

@end

@implementation TGTableViewCell

#pragma mark - Public

- (void)configureWithRouter:(TGRouter *)router {
    self.router = router;
    [self updateLayout];
}

#pragma mark - Layout

- (void)updateLayout {
    self.routerNameLabel.text = self.router.name;
    self.networkNameLabel.text = self.router.networkName;
    
    NSString *networkAddress = [NSString stringWithFormat:@"%@:%ld", self.router.ipAddress, (long)self.router.port];
    self.networkAddressLabel.text = networkAddress;
}

@end

//
//  TGTableViewCell.h
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/17/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TGTableViewCell : UITableViewCell

//TODO; Refactor this to take a network object
@property (weak, nonatomic) IBOutlet UILabel *routerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkAddressLabel;

@end

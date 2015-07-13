//
//  TGGeneralCell.m
//  ThreadGroup
//
//  Created by Lu Quan Tan on 7/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGGeneralCell.h"

/*
 This is the general cell of the tableview cell. It will be selectable.
 
 I need to set the background color of the cell, the font and color of the label and detail label.
 
 The cell with hve a disclosure button
 
 I got to add a seperator view to the cell. Probably on the bottom side.
 
 One question what is the UI for the IOS side when a cell is selected. It will be different for the channel number picker and the changing of network name
 
 
 */

@implementation TGGeneralCell

- (void)awakeFromNib {
    self.layoutMargins = UIEdgeInsetsZero;
}

@end

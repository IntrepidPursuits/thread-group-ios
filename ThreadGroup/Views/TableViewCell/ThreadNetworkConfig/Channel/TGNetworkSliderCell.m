//
//  TGNetworkSliderCell.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 7/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkSliderCell.h"

@interface TGNetworkSliderCell()

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TGNetworkSliderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSInteger roundedValue = nearbyintf(sender.value);
    self.timeLabel.text = [NSString stringWithFormat:@"%d", roundedValue];
}

@end

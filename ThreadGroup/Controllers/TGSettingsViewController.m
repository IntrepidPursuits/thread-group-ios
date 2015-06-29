//
//  TGSettingsViewController.m
//  ThreadGroup
//
//  Created by Patrick Butkiewicz on 6/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGSettingsViewController.h"
#import "TGSettingsManager.h"

@interface TGSettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *debugModeSwitch;

@end

@implementation TGSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.debugModeSwitch setOn:[[TGSettingsManager sharedManager] debugModeEnabled]];
}

- (IBAction)debugModeValueChanged:(id)sender {
    BOOL switchOn = [(UISwitch *)sender isOn];
    [[TGSettingsManager sharedManager] setDebugModeEnabled:switchOn];
}

@end

//
//  TGNetworkConfigViewController.m
//  ThreadGroup
//
//  Created by Lu Quan Tan on 7/10/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNetworkConfigViewController.h"

@interface TGNetworkConfigViewController ()

@end

/*
 Create a tableview in the xib and connect to implementation
 
 Remember to set the title of the controller so that its name with appear on the navigation bar header
 
 the constraints and stuff can be all put within the xib.
 
 this controller will also be the data source and delegate of the table view
 
 remember to set the datasoruce and delegate to self
 
 STATE:
 
 I cant update the state everytime i open the settings screen, so i defintely should cache the settings and update them when the app is opened for the first time or when the user makes a change or addition to the network settings. This is assuming that we are the only ones that will change the network info. Can network info be changed internally by the thread network or by a third party individual
 */

@implementation TGNetworkConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  TGNavigationViewController.m
//  ThreadGroup
//
//  Created by Anbita Siregar on 8/12/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGNavigationViewController.h"
#import "TGPopupContentViewController.h"
#import "TGPopupContentAnimator.h"
#import "TGButton.h"
#import "UIColor+ThreadGroup.h"
#import "TGNavigationAnimator.h"
#import "TGTransitioningDelegate.h"
#import "UIImage+ThreadGroup.h"

@interface TGNavigationViewController () <TGPopupContentViewControllerDelegate, UINavigationControllerDelegate>

//PopupContentViewController
@property (strong, nonatomic) TGPopupContentViewController *popupContentVC;

@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) UIAlertController *moreMenu;

@end

@implementation TGNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    self.modalPresentationStyle = UIModalPresentationCustom;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor threadGroup_grey];
}

- (void)setupNavBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage tg_navThreadLogo]];
    [self.navigationItem.titleView setContentMode:UIViewContentModeScaleAspectFit];
    UIBarButtonItem *logButton = [[UIBarButtonItem alloc] initWithImage:[UIImage tg_navLogInfo] style:UIBarButtonItemStylePlain target:self action:@selector(logButtonPressed:)];
    UIBarButtonItem *moreInfoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage tg_navMoreMenu] style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonPressed:)];
    self.navigationItem.leftBarButtonItem = logButton;
    self.navigationItem.rightBarButtonItem = moreInfoButton;
}

#pragma mark - Lazy load

- (TGPopupContentViewController *)popupContentVC {
    if (!_popupContentVC) {
        _popupContentVC = [[TGPopupContentViewController alloc] initWithNibName:nil bundle:nil];
        _popupContentVC.transitioningDelegate = self.transitionDelegate;
        _popupContentVC.delegate = self;
    }
    return _popupContentVC;
}

#pragma mark - Header View

- (void)moreButtonPressed:(UIButton *)sender {
    NSLog(@"Show drop down menu");
    [self presentViewController:self.moreMenu animated:YES completion:nil];
}

- (void)logButtonPressed:(UIButton *)sender {
    NSLog(@"Show App Log");
    self.popupContentVC.popupType = TGPopupTypeLog;
    self.buttons = [self createButtonsFor:self.popupContentVC];
    [self.popupContentVC setContentTitle:@"Application Debug Log" andButtons:self.buttons];
    self.popupContentVC.textContent = [[TGLogManager sharedManager] getLog];
    [self presentViewController:self.popupContentVC animated:YES completion:nil];
}

#pragma mark - MoreMenu

- (void)showTermsOfService {
    NSLog(@"Show Terms of Service");
    self.popupContentVC.popupType = TGPopupTypeTOS;
    self.buttons = [self createButtonsFor:self.popupContentVC];
    [self.popupContentVC setContentTitle:@"Terms of Service" andButtons:self.buttons];
    //Rather than Lorem Ipsum, I just have the log showing
    self.popupContentVC.textContent = [[TGLogManager sharedManager] getLog];
    [self presentViewController:self.popupContentVC animated:YES completion:nil];
}

- (void)showAbout {
    NSLog(@"Show About");
    self.popupContentVC.popupType = TGPopupTypeAbout;
    self.popupContentVC.textViewAlignment = NSTextAlignmentCenter; //Text alignment is reset back to justified in popup's controller
    self.buttons = [self createButtonsFor:self.popupContentVC];
    [self.popupContentVC setContentTitle:@"About" andButtons:self.buttons];
    self.popupContentVC.textContent = [self textForAbout];
    [self presentViewController:self.popupContentVC animated:YES completion:nil];
}

- (void)showHelp {
    NSLog(@"Show Help");
    self.popupContentVC.popupType = TGPopupTypeAbout;
    self.buttons = [self createButtonsFor:self.popupContentVC];
    [self.popupContentVC setContentTitle:@"Help" andButtons:self.buttons];
    //Rather than Lorem Ipsum, I just have the log showing
    self.popupContentVC.textContent = [[TGLogManager sharedManager] getLog];
    [self presentViewController:self.popupContentVC animated:YES completion:nil];
}

#pragma mark - TGPopupContentViewControllerDelegate

- (void)popupContentViewControllerDidPressButtonAtIndex:(NSUInteger)index {
    switch (self.popupContentVC.popupType) {
        case TGPopupTypeLog:
            [self handleButtonPressedAtIndex:index forPopupType:TGPopupTypeLog];
            break;
        case TGPopupTypeTOS:
            [self handleButtonPressedAtIndex:index forPopupType:TGPopupTypeTOS];
            break;
        case TGPopupTypeAbout:
            [self handleButtonPressedAtIndex:index forPopupType:TGPopupTypeAbout];
            break;
        case TGPopupTypeHelp:
            [self handleButtonPressedAtIndex:index forPopupType:TGPopupTypeHelp];
            break;
        default:
            NSAssert(YES, @"TGPopupType is undefined");
            break;
    }
}

#pragma mark - Button creation

- (NSArray *)createButtonsFor:(TGPopupContentViewController *)popupVC {
    NSMutableArray *buttons = [NSMutableArray new];
    switch (popupVC.popupType) {
        case TGPopupTypeLog: {
            TGButton *shareButton = [[TGButton alloc] initWithTitle:@"" andImage:[UIImage tg_shareAction]];
            TGButton *clearButton = [[TGButton alloc] initWithTitle:@"CLEAR" andImage:nil];
            TGButton *okButton = [[TGButton alloc] initWithTitle:@"OK" andImage:nil];
            
            [buttons addObject:shareButton];
            [buttons addObject:clearButton];
            [buttons addObject:okButton];
            
            break;
        }
        case TGPopupTypeTOS:
        case TGPopupTypeAbout:
        case TGPopupTypeHelp: {
            TGButton *okButton = [[TGButton alloc] initWithTitle:@"OK" andImage:nil];
            [buttons addObject:okButton];
            break;
        }
        default:
            NSAssert(YES, @"TGPopupType is undefined");
            break;
    }
    return buttons;
}

#pragma mark - Button Actions

- (void)handleButtonPressedAtIndex:(NSUInteger)index forPopupType:(TGPopupType)popupType {
    if (popupType == TGPopupTypeLog) {
        switch (index) {
            case 0: {
                NSLog(@"Share button pressed!");
                UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[self.popupContentVC.textContent] applicationActivities:nil];
                activity.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToTwitter, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo];
                [self.presentedViewController presentViewController:activity animated:YES completion:nil];
                break;
            }
            case 1: {
                NSLog(@"Clear button pressed!");
                [[TGLogManager sharedManager] resetLog];
                self.popupContentVC.textContent = [[TGLogManager sharedManager] getLog];
                [self.popupContentVC resetTextView];
                break;
            }
            case 2: {
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            }
            default:
                NSAssert(index > 2, @"Button index is out of bounds!");
                break;
        }
    } else if (popupType == TGPopupTypeAbout || popupType == TGPopupTypeTOS || popupType == TGPopupTypeHelp) {
        NSLog(@"Ok Button pressed");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TextContent

- (NSString *)textForAbout {
    NSString *title = @"Thread Group Sample Comminisioning Application for iOS";
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *version = infoDictionary[(NSString *)kCFBundleVersionKey];
    NSString *versionString = [NSString stringWithFormat:@"Version: %@", version];
    NSString *additionalInfo = @"For demonstration and reference purposes only";
    NSString *intrepid = @"Brought to you by Intrepid Pursuits\nhttp://www.intrepid.io";
    NSString *thread = @"Owned and maintained by Thread Group inc.\nhttp://www.threadgroup.org";
    NSMutableString *string = [NSMutableString new];
    [string appendFormat:@"%@\n\n",title];
    [string appendFormat:@"%@\n\n",versionString];
    [string appendFormat:@"%@\n\n",additionalInfo];
    [string appendFormat:@"%@\n\n",intrepid];
    [string appendFormat:@"%@",thread];
    
    return string;
}

#pragma mark - UIAlertController

- (UIAlertController *)moreMenu {
    if (!_moreMenu) {
        _moreMenu = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *tos = [UIAlertAction actionWithTitle:@"Terms of Service" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showTermsOfService];
        }];
        UIAlertAction *about =  [UIAlertAction actionWithTitle:@"About" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showAbout];
        }];
        UIAlertAction *help =  [UIAlertAction actionWithTitle:@"Help" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showHelp];
        }];
        
        [_moreMenu addAction:defaultAction];
        [_moreMenu addAction:tos];
        [_moreMenu addAction:about];
        [_moreMenu addAction:help];
    }
    return _moreMenu;
}

#pragma mark - Lazy

- (TGTransitioningDelegate *)transitionDelegate {
    if (!_transitionDelegate) {
        _transitionDelegate = [TGTransitioningDelegate new];
    }
    return _transitionDelegate;
}

@end

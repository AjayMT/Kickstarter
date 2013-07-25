//
//  GeneralPreferencesViewController.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 27/06/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "GeneralPreferencesViewController.h"

@interface GeneralPreferencesViewController ()

@end

@implementation GeneralPreferencesViewController
@synthesize launchAtLogin, launchAtLoginController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.launchAtLoginController = [[LaunchAtLoginController alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    if (launchAtLoginController.launchAtLogin) {
        launchAtLogin.state = NSOnState;
    } else {
        launchAtLogin.state = NSOffState;
    }
}

- (NSString *)identifier
{
    return NSStringFromClass(self.class);
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return @"General";
}

- (IBAction)toggleLaunchAtLogin:(id)sender
{
    if ([sender state] == NSOnState) {
        launchAtLoginController.launchAtLogin = YES;
    } else {
        launchAtLoginController.launchAtLogin = NO;
    }
}

@end

//
//  UpdatesPreferencesViewController.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 03/07/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "UpdatesPreferencesViewController.h"
#import <Sparkle/Sparkle.h>

@interface UpdatesPreferencesViewController ()

@end

@implementation UpdatesPreferencesViewController
@synthesize updateCheckInterval, automaticallyCheckForUpdates;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([SUUpdater sharedUpdater].automaticallyChecksForUpdates) {
            automaticallyCheckForUpdates.state = NSOnState;
        } else {
            automaticallyCheckForUpdates.state = NSOffState;
        }
    }
    
    return self;
}

- (IBAction)toggleAutomaticallyCheckForUpdates:(id)sender
{
    if ([sender state] == NSOnState) {
        [SUUpdater sharedUpdater].automaticallyChecksForUpdates = YES;
        updateCheckInterval.enabled = YES;
    } else {
        [SUUpdater sharedUpdater].automaticallyChecksForUpdates = NO;
        updateCheckInterval.enabled = NO;
    }
}

- (IBAction)changeUpdateCheckInterval:(id)sender
{
    [SUUpdater sharedUpdater].updateCheckInterval = updateCheckInterval.selectedItem.tag;
}

- (IBAction)checkForUpdates:(id)sender
{
    [[SUUpdater sharedUpdater] checkForUpdates:sender];
}

- (NSString *)identifier
{
    return NSStringFromClass(self.class);
}

- (NSString *)toolbarItemLabel
{
    return @"Updates";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"prefs_update.png"];
}

@end

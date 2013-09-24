//
//  PanelPreferencesViewController.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 15/09/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "PanelPreferencesViewController.h"
#import <MASShortcut+UserDefaults.h>

@interface PanelPreferencesViewController ()
@end

@implementation PanelPreferencesViewController
@synthesize shortcutView, shortcutUserDefaultsKey, hotkeyNotificationName, fuzzyMatchingCheckbox;
@synthesize fuzzyMatchingUserDefaultsKey, shortcutViewContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shortcutUserDefaultsKey = @"KickstarterPanelGlobalHotkey";
        self.fuzzyMatchingUserDefaultsKey = @"KickstarterPanelFuzzyMatching";
        self.hotkeyNotificationName = @"KickstarterPanelHotkeyPressed";
        self.shortcutView = [[MASShortcutView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
        
        shortcutView.associatedUserDefaultsKey = shortcutUserDefaultsKey;
        [MASShortcut registerGlobalShortcutWithUserDefaultsKey:shortcutUserDefaultsKey handler:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:hotkeyNotificationName object:self];
        }];
    }
    
    return self;
}

- (void)awakeFromNib
{
    shortcutView.frame = NSMakeRect(0, 0,
                                    shortcutViewContainer.frame.size.width,
                                    shortcutViewContainer.frame.size.height);
    [shortcutViewContainer addSubview:shortcutView];
    
    BOOL fuzzyMatching = [[NSUserDefaults standardUserDefaults] boolForKey:fuzzyMatchingUserDefaultsKey];
    if (fuzzyMatching) {
        fuzzyMatchingCheckbox.state = NSOnState;
    } else {
        fuzzyMatchingCheckbox.state = NSOffState;
    }
}

- (IBAction)toggleFuzzyMatching:(id)sender
{
    if ([sender state] == NSOnState)
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:fuzzyMatchingUserDefaultsKey];
    else
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:fuzzyMatchingUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)identifier
{
    return NSStringFromClass(self.class);
}

- (NSString *)toolbarItemLabel
{
    return @"Kickstarter Panel";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"prefs_panel.png"];
}

@end

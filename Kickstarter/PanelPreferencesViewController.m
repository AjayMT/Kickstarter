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
@synthesize shortcutView, shortcutUserDefaultsKey, hotkeyNotificationName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shortcutUserDefaultsKey = @"KickstarterPanelGlobalHotkey";
        self.hotkeyNotificationName = @"KickstarterPanelHotkeyPressed";
        self.shortcutView = [[MASShortcutView alloc] initWithFrame:NSMakeRect(122, 121, 163, 19)];
        
        shortcutView.associatedUserDefaultsKey = shortcutUserDefaultsKey;
        [MASShortcut registerGlobalShortcutWithUserDefaultsKey:shortcutUserDefaultsKey handler:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:hotkeyNotificationName object:self];
        }];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self.view addSubview:shortcutView];
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

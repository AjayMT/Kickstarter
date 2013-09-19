//
//  PanelPreferencesViewController.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 15/09/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "PanelPreferencesViewController.h"

@interface PanelPreferencesViewController ()
@end

@implementation PanelPreferencesViewController
@synthesize shortcutView, shortcutUserDefaultsKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shortcutUserDefaultsKey = @"KickstarterPanelGlobalHotkey";
        self.shortcutView.associatedUserDefaultsKey = shortcutUserDefaultsKey;
    }
    
    return self;
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

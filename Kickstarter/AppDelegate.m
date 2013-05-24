//
//  AppDelegate.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 21/05/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize mainMenu, mainStatusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self reloadSetupMenu];
    
    self.mainStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    mainStatusItem.menu = mainMenu;
    mainStatusItem.title = @"Kickstarter";
    mainStatusItem.highlightMode = YES;
}

- (void)reloadSetupMenu
{
    NSMenu *setupMenu = [[NSMenu alloc] initWithTitle:@"Setups"];
    NSString *filePath = [[[NSBundle mainBundle] bundlePath]
                          stringByAppendingPathComponent:@"Contents/Resources/Setups.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    for (NSString *setup in dict) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:setup action:@selector(launchSetup:)
                                                   keyEquivalent:@""];
        [setupMenu addItem:menuItem];
    }
    
    [[mainMenu itemWithTitle:@"Setups"] setSubmenu:setupMenu];
}

- (void)launchSetup:(NSMenuItem *)sender
{
    NSString *filePath = [[[NSBundle mainBundle] bundlePath]
                          stringByAppendingPathComponent:@"Contents/Resources/Setups.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *setups = [dict objectForKey:sender.title];
    
    for (NSArray *apps in setups) {
        for (NSString *app in apps) {
            [[NSWorkspace sharedWorkspace] launchApplication:app];
        }
    }
}

@end

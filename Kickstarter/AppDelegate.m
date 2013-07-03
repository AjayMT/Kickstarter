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
    self.mainStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    mainStatusItem.menu = mainMenu;
    mainStatusItem.title = @"KS";
    mainStatusItem.highlightMode = YES;
}

@end

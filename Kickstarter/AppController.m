//
//  AppController.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 22/05/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "AppController.h"

@interface AppController ()
@end

@implementation AppController
@synthesize captureWindow, captureName, manageSetupsWindow, manageSetupsTableView;
@synthesize setups, filePath, setupArrayController, editSetupWindow, editSetupTableView;
@synthesize setupMenu;

- (id)init
{
    if (self = [super init]) {
        self.filePath = [[[NSBundle mainBundle] bundlePath]
                         stringByAppendingPathComponent:@"Contents/Resources/Setups.plist"];
        self.setups = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self loadSetupMenu];
    setupMenu.autoenablesItems = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:nil
                                                object:captureWindow];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:nil
                                                object:manageSetupsWindow];
}

- (void)receiveNotification:(id)sender
{
    if ([[sender name] isEqualToString:NSWindowWillCloseNotification] && [sender object] == captureWindow) {
        captureName.stringValue = @"";
    }
}

- (IBAction)launchSetup:(id)sender
{
    NSString *setupName = [sender title];
    
    if ([sender isKindOfClass:[NSButton class]]) {
        setupName = [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow];
    }
    
    for (NSString *app in [[setups objectForKey:setupName] objectAtIndex:0]) {
        [[NSWorkspace sharedWorkspace] launchApplication:app];
    }
}

- (void)loadSetupMenu
{
    [setupMenu removeAllItems];
    
    for (NSString *setup in self.setupArray) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:setup action:@selector(launchSetup:)
                                                   keyEquivalent:@""];
        menuItem.enabled = YES;
        menuItem.target = self;
        [setupMenu addItem:menuItem];
    }
}

- (void)reloadData
{
    [setups writeToFile:filePath atomically:YES];
    [self loadSetupMenu];
    [setupArrayController setContent:self.setupArray];
}

- (IBAction)captureSetup:(id)sender
{
    NSString *captureKey = captureName.stringValue;
    
    if ([captureKey isEqualToString:@""]) {
        return;
    }
    
    NSArray *runningApps = [NSWorkspace sharedWorkspace].runningApplications;
    NSMutableArray *appArray = [NSMutableArray array];
    
    for (NSRunningApplication *app in runningApps) {
        [appArray addObject:app.localizedName];
    }
    
    [setups insertValue:appArray atIndex:0 inPropertyWithKey:captureKey];
    
    [self reloadData];
    [captureWindow performClose:self];
}

- (IBAction)deleteSetup:(id)sender
{
    if (self.setupArray.count == 0) {
        return;
    }
    
    NSString *setup = [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow];
    [setups removeObjectForKey:setup];
    [self reloadData];
}

- (NSArray *)setupArray
{
    return setups.allKeys;
}

@end

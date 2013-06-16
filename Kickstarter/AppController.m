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
@synthesize setupMenu, appArrayController, setupShell, setupShellCommands;

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
    setupShellCommands.font = [NSFont fontWithName:@"Monaco" size:11.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:nil
                                                object:nil];
}

- (void)receiveNotification:(id)sender
{
    if ([[sender name] isEqualToString:NSWindowWillCloseNotification] && [sender object] == captureWindow) {
        captureName.stringValue = @"";
    }
    
    if ([[sender name] isEqualToString:NSTableViewSelectionDidChangeNotification] && [sender object] == manageSetupsTableView) {
        [self reloadData];
    }
    
    if ([[sender name] isEqualToString:NSWindowDidBecomeKeyNotification] && [sender object] == editSetupWindow) {
        if (manageSetupsTableView.selectedRow != -1) {
            NSArray *theSetup = [setups objectForKey:
                                 [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow]];
            NSArray *shellInfo = [theSetup objectAtIndex:0];
            
            NSInteger indexOfCurrentShell = [@[@"/bin/bash", @"/bin/sh", @"/bin/zsh"] indexOfObject:[shellInfo
                                                                                               objectAtIndex:0]];
            [setupShell selectItemAtIndex:indexOfCurrentShell];
            setupShellCommands.string = [shellInfo objectAtIndex:1];
        }
    }
}

- (IBAction)launchSetup:(id)sender
{
    NSString *setupName = [sender title];
    
    if ([sender isKindOfClass:[NSButton class]]) {
        if (manageSetupsTableView.selectedRow == -1) {
            return;
        }
        setupName = [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow];
    }
    
    NSMutableArray *runningApps = [NSMutableArray array];
    for (id app in [[NSWorkspace sharedWorkspace] runningApplications]) {
        [runningApps addObject:[app localizedName]];
    }
    for (id app in [[setups objectForKey:setupName] objectAtIndex:1]) {
        if (! [runningApps containsObject:app]) {
            [[NSWorkspace sharedWorkspace] launchApplication:app];
        }
    }
    
    NSArray *theApp = [[setups objectForKey:setupName] objectAtIndex:0];
    NSString *script = [theApp objectAtIndex:1];
    NSString *filename = [NSString pathWithComponents:@[@"/", @"tmp", setupName]];
    [script writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [[NSTask launchedTaskWithLaunchPath:[theApp objectAtIndex:0] arguments:@[filename]] waitUntilExit];
    [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
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
    setupArrayController.content = self.setupArray;
    appArrayController.content = self.appArray;
}

- (IBAction)captureSetup:(id)sender
{
    NSString *captureKey = captureName.stringValue;
    
    if ([captureKey isEqualToString:@""]) {
        return;
    }
    
    if ([self.setupArray containsObject:captureKey]) {
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Replace setup?"
                                            defaultButton:@"Yes"
                                          alternateButton:@"No"
                                              otherButton:nil
                                informativeTextWithFormat:@"The setup '%@' already exists. Replace it?", captureKey];
        
        int result = (int)theAlert.runModal;
        if (result == NSAlertDefaultReturn) {
            [setups removeObjectForKey:captureKey];
        } else if (result == NSAlertAlternateReturn) {
            return;
        }
    }
    
    NSArray *runningApps = [NSWorkspace sharedWorkspace].runningApplications;
    NSMutableArray *apps = [NSMutableArray array];
    for (NSRunningApplication *app in runningApps) {
        [apps addObject:app.localizedName];
    }
    [setups insertValue:apps atIndex:0 inPropertyWithKey:captureKey];
    [setups insertValue:@[@"/bin/bash", @""] atIndex:0 inPropertyWithKey:captureKey];
    
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

- (IBAction)saveSetup:(id)sender
{
    if (manageSetupsTableView.selectedRow == -1) return;
    
    NSString *currentSetupName = [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow];
    NSMutableArray *currentSetup = [setups objectForKey:currentSetupName];
    NSArray *shellInfo = @[setupShell.titleOfSelectedItem, setupShellCommands.string];
    
    [currentSetup removeObjectsInRange:NSMakeRange(0, 1)];
    [currentSetup addObject:shellInfo];
    [currentSetup addObject:self.appArray];
    
    [setups removeObjectForKey:currentSetupName];
    [setups insertValue:[currentSetup objectAtIndex:0] atIndex:0 inPropertyWithKey:currentSetupName];
    [setups insertValue:[currentSetup objectAtIndex:1] atIndex:0 inPropertyWithKey:currentSetupName];
    
    [editSetupWindow performClose:self];
    [self reloadData];
}

- (NSArray *)setupArray
{
    return setups.allKeys;
}

- (NSArray *)appArray
{
    int index = 0;
    
    if (manageSetupsWindow.isVisible) {
        index = (int)manageSetupsTableView.selectedRow;
    }
    
    if (self.setupArray.count == 0 || index == -1) {
        return @[];
    }
    
    return [[setups objectForKey:[self.setupArray objectAtIndex:index]] objectAtIndex:1];
}

@end

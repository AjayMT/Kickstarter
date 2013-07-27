//
//  AppController.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 22/05/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "AppController.h"
#import "GeneralPreferencesViewController.h"
#import "UpdatesPreferencesViewController.h"

@interface AppController ()
@end

@implementation AppController
@synthesize captureWindow, captureName, manageSetupsWindow, manageSetupsTableView;
@synthesize setups, filePath, setupArrayController, editSetupWindow, editSetupTableView;
@synthesize setupMenu, appArrayController, setupShell, setupShellCommands, addAppWindow;
@synthesize addAppPopUpButton, preferencesViewControllers, preferencesWindowController;

- (id)init
{
    if (self = [super init]) {
        NSString *applicationSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)
                                            objectAtIndex:0];
        NSString *setupFileExists = [NSString stringWithContentsOfFile:[applicationSupportPath stringByAppendingPathComponent:@"Kickstarter/Setups.plist"]
                                                       encoding:NSUTF8StringEncoding error:nil];
        if (! setupFileExists) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[applicationSupportPath stringByAppendingPathComponent:@"Kickstarter"]
                                      withIntermediateDirectories:YES attributes:nil error:nil];
            NSDictionary *theDict = @{};
            [theDict writeToFile:[applicationSupportPath stringByAppendingPathComponent:@"Kickstarter/Setups.plist"] atomically:YES];
        }
        self.filePath = [applicationSupportPath stringByAppendingPathComponent:@"Kickstarter/Setups.plist"];
        self.setups = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        self.preferencesViewControllers = @[[[GeneralPreferencesViewController alloc]
                                             initWithNibName:@"GeneralPreferencesViewController" bundle:[NSBundle mainBundle]],
                                                [[UpdatesPreferencesViewController alloc]
                                            initWithNibName:@"UpdatesPreferencesViewController" bundle:[NSBundle mainBundle]]];
        self.preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:preferencesViewControllers];
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
    
    if ([[sender name] isEqualToString:NSWindowWillCloseNotification] && [sender object] == manageSetupsWindow) {
        [self reloadEditSetupWindow:self];
        [editSetupWindow performClose:self];
    }
    
    if ([[sender name] isEqualToString:NSWindowDidBecomeKeyNotification] && [sender object] == editSetupWindow) {
        [self reloadEditSetupWindow:self];
    }
    
    if ([[sender name] isEqualToString:NSTableViewSelectionDidChangeNotification] && [sender object] == manageSetupsTableView) {
        [self reloadEditSetupWindow:self];
    }
}

- (IBAction)launchSetup:(id)sender
{
    NSString *setupName = [sender title];
    
    if ([sender isKindOfClass:[NSButton class]]) {
        if (manageSetupsTableView.selectedRow == -1) return;
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

- (void)reloadSetups
{
    self.setups = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
}

- (void)reloadData
{
    [setups writeToFile:filePath atomically:YES];
    setupArrayController.content = self.setupArray;
    [self loadSetupMenu];
    [self reloadEditSetupWindow:self];
}

- (IBAction)reloadEditSetupWindow:(id)sender
{
    [self reloadSetups];
    
    if ([sender isKindOfClass:[NSButton class]]) {
        if ([[sender title] isEqualToString:@"Cancel"]) [editSetupWindow performClose:self];
    }
    
    appArrayController.content = self.appArray;
    [setupShell selectItemAtIndex:0];
    setupShellCommands.string = @"";
    
    if (manageSetupsTableView.selectedRow == -1) return;
    
    NSArray *currentSetup = [setups objectForKey:[self.setupArray objectAtIndex:manageSetupsTableView.selectedRow]];
    NSArray *shellInfo = [currentSetup objectAtIndex:0];
    
    [setupShell selectItemAtIndex:[setupShell.itemTitles indexOfObject:[shellInfo objectAtIndex:0]]];
    setupShellCommands.string = [shellInfo objectAtIndex:1];
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
        NSString *thePath = [NSString stringWithFormat:@"/Applications/%@.app", app.localizedName];
        NSString *theOtherPath = [NSString stringWithFormat:@"%@/Applications/%@.app", NSHomeDirectory(),
                                  app.localizedName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:thePath] ||
            [[NSFileManager defaultManager] fileExistsAtPath:theOtherPath]) {
            [apps addObject:app.localizedName];
        }
    }
    [setups insertValue:apps atIndex:0 inPropertyWithKey:captureKey];
    [setups insertValue:@[@"/bin/bash", @""] atIndex:0 inPropertyWithKey:captureKey];
    
    [self reloadData];
    [captureWindow performClose:self];
}

- (IBAction)deleteSetup:(id)sender
{
    if (self.setupArray.count == 0) return;
    
    NSString *setup = [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow];
    [setups removeObjectForKey:setup];
    [self reloadData];
}

- (IBAction)saveSetup:(id)sender
{
    if (manageSetupsTableView.selectedRow == -1) return;
    
    NSString *currentSetupName = [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow];
    NSArray *shellInfo = @[setupShell.titleOfSelectedItem, setupShellCommands.string];
    NSArray *currentSetup = @[shellInfo, self.appArray];
    
    [setups removeObjectForKey:currentSetupName];
    [setups insertValue:[currentSetup objectAtIndex:1] atIndex:0 inPropertyWithKey:currentSetupName];
    [setups insertValue:[currentSetup objectAtIndex:0] atIndex:0 inPropertyWithKey:currentSetupName];
    
    [self reloadData];
    [editSetupWindow performClose:self];
}

- (IBAction)addAppToCurrentSetup:(id)sender
{   
    if (manageSetupsTableView.selectedRow == -1) return;
    
    NSString *currentSetupName = [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow];
    NSString *appName = addAppPopUpButton.selectedItem.title;
    NSMutableArray *currentSetup = [setups objectForKey:currentSetupName];
    NSMutableArray *setupApps = [NSMutableArray arrayWithArray:self.appArray];
    
    if ([setupApps containsObject:appName]) return;
    
    [setupApps addObject:appName];
    currentSetup = [NSMutableArray arrayWithObjects:[currentSetup objectAtIndex:0], setupApps, nil];
    
    [setups removeObjectForKey:currentSetupName];
    [setups insertValue:currentSetup.lastObject atIndex:0 inPropertyWithKey:currentSetupName];
    [setups insertValue:[currentSetup objectAtIndex:0] atIndex:0 inPropertyWithKey:currentSetupName];
    
    [self reloadData];
    [addAppWindow performClose:self];
}

- (IBAction)removeAppFromCurrentSetup:(id)sender
{
    if (editSetupTableView.selectedRow == -1) return;
    
    NSString *selectedApp = [self.appArray objectAtIndex:editSetupTableView.selectedRow];
    NSString *currentSetupName = [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow];
    NSMutableArray *currentSetup = [setups objectForKey:currentSetupName];
    NSMutableArray *setupApps = [NSMutableArray arrayWithArray:self.appArray];
    
    [setupApps removeObject:selectedApp];
    currentSetup = [NSMutableArray arrayWithObjects:[currentSetup objectAtIndex:0], setupApps, nil];
    
    [setups removeObjectForKey:currentSetupName];
    [setups insertValue:currentSetup.lastObject atIndex:0 inPropertyWithKey:currentSetupName];
    [setups insertValue:[currentSetup objectAtIndex:0] atIndex:0 inPropertyWithKey:currentSetupName];
    
    [self reloadData];
}

- (IBAction)showAddAppWindow:(id)sender
{
    NSMutableArray *installedApps = [NSMutableArray array];
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Applications" error:nil]) {
        if ([file hasSuffix:@".app"]) {
            [installedApps addObject:file.stringByDeletingPathExtension];
        }
    }
    for (NSString *file in [[NSFileManager defaultManager]
                            contentsOfDirectoryAtPath:@"~/Applications".stringByExpandingTildeInPath error:nil]) {
        if ([file hasSuffix:@".app"]) {
            [installedApps addObject:file.stringByDeletingPathExtension];
        }
    }
    
    [addAppPopUpButton addItemsWithTitles:[installedApps sortedArrayUsingSelector:@selector(compare:)]];
    [addAppWindow makeKeyAndOrderFront:sender];
}

- (IBAction)showPreferences:(id)sender
{
    [preferencesWindowController showWindow:sender];
}

- (NSArray *)setupArray
{
    return [setups.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)appArray
{
    int index = (int)manageSetupsTableView.selectedRow;
    
    if (self.setupArray.count == 0 || index == -1) {
        return @[];
    }
    
    return [[setups objectForKey:[self.setupArray objectAtIndex:index]] lastObject];
}

@end

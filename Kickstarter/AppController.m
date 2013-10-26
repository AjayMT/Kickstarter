//
//  AppController.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 22/05/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "AppController.h"
#import "GeneralPreferencesViewController.h"
#import "PanelPreferencesViewController.h"
#import "KSUtils.h"
#import "KSView.h"
#import "NSString+FuzzyMatching.h"

@interface AppController ()
@end

@implementation AppController
@synthesize captureWindow, captureName, manageSetupsWindow, manageSetupsTableView;
@synthesize setups, filePath, setupArrayController, editSetupWindow, editSetupTableView;
@synthesize setupMenu, appArrayController, setupShell, setupShellCommands, addAppWindow;
@synthesize addAppPopUpButton, preferencesViewControllers, preferencesWindowController;
@synthesize kickstarterPanel, panelTextField, panelSearchResults;

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
        
        // Preference panes
        self.preferencesViewControllers = @[
                                            [[GeneralPreferencesViewController alloc]
                                             initWithNibName:@"GeneralPreferencesViewController"
                                             bundle:[NSBundle mainBundle]],
                                            [[PanelPreferencesViewController alloc]
                                             initWithNibName:@"PanelPreferencesViewController"
                                             bundle:[NSBundle mainBundle]]
                                            ];
        self.preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:preferencesViewControllers];
        [preferencesWindowController selectControllerAtIndex:0];
        preferencesWindowController.window.styleMask = preferencesWindowController.window.styleMask
        & ~NSResizableWindowMask;
        
        // Panel initialization
        int panelY = [NSScreen mainScreen].frame.size.height - 700;
        int panelX = ([NSScreen mainScreen].frame.size.width / 2) - 300;
        NSRect panelFrame = NSMakeRect(panelX, panelY, 600, 100);
        
        self.kickstarterPanel = [[KSFloatingWindow alloc] initWithContentRect:panelFrame];
        self.panelTextField = [[KSPanelTextField alloc] init];
        self.panelSearchResults = [NSMutableArray array];
        panelTextField.controller = self;
        panelTextField.controllerAction = @selector(handlePanelTextFieldEvent:);
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self reloadSetupMenu];
    setupMenu.autoenablesItems = NO;
    setupShellCommands.font = [NSFont fontWithName:@"Monaco" size:11.0];
    
    [self reloadPanel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
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
    
    // Global hotkey
    NSString *hotkeyNotificationName = [preferencesViewControllers[1] hotkeyNotificationName];
    if ([[sender name] isEqualToString:hotkeyNotificationName]) [self showKickstarterPanel:self];
}

- (IBAction)launchSetup:(id)sender
{
    NSString *setupName;
    
    if ([sender isKindOfClass:[NSButton class]]) {
        if (manageSetupsTableView.selectedRow == -1) return;
        setupName = [self.setupArray objectAtIndex:manageSetupsTableView.selectedRow];
    } else if ([sender isKindOfClass:[NSString class]]) {
        setupName = sender;
    } else setupName = [sender title];
    
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
    BOOL runQuietly = [[NSUserDefaults standardUserDefaults] boolForKey:[preferencesViewControllers[0] runShellScriptsQuietlyUserDefaultsKey]];
    
    if (! runQuietly) {
        NSString *shell = theApp[0];
        NSString *terminalApplication = [preferencesViewControllers[0] terminalApplicationName];
        script = [NSString stringWithFormat:@"#!%@\n%@\n/bin/rm -rf %@", shell, script, filename];
        [script writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        [[NSTask launchedTaskWithLaunchPath:@"/bin/chmod" arguments:@[@"+x", filename]] waitUntilExit];
        [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"-a", terminalApplication, filename]] waitUntilExit];
    } else {
        [[NSTask launchedTaskWithLaunchPath:[theApp objectAtIndex:0] arguments:@[filename]] waitUntilExit];
        [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
    }
    
    if (NSClassFromString(@"NSUserNotification") && NSClassFromString(@"NSUserNotificationCenter")) {
        NSUserNotification *theNotification = [NSUserNotification new];
        theNotification.title = [NSString stringWithFormat:@"Successfully launched setup '%@'", setupName];
        theNotification.hasActionButton = NO;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:theNotification];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:[NSUserNotificationCenter defaultUserNotificationCenter] selector:@selector(removeAllDeliveredNotifications) userInfo:nil repeats:NO];
    }
}

- (void)reloadSetupMenu
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
    [self reloadSetupMenu];
    [self reloadEditSetupWindow:self];
}

- (void)reloadPanel
{
    BOOL fuzzyMatching = [[NSUserDefaults standardUserDefaults]
                          boolForKey:[preferencesViewControllers[1] fuzzyMatchingUserDefaultsKey]];
    NSString *query = panelTextField.stringValue;
    self.panelSearchResults = [NSMutableArray array];
    
    for (NSString *setupName in self.setupArray) {
        if ([setupName.lowercaseString rangeOfString:query.lowercaseString
                                       fuzzyMatching:fuzzyMatching].location != NSNotFound) {
            [panelSearchResults addObject:setupName];
        }
    }
    if ([query isEqualToString:@""]) panelSearchResults = [NSMutableArray array];
    
    int resultsHeight = 50 * (int)panelSearchResults.count;
    NSRange previousSelectedRange = panelTextField.currentEditor.selectedRange;
    
    NSRect panelFrame = NSMakeRect(kickstarterPanel.frame.origin.x, kickstarterPanel.frame.origin.y, kickstarterPanel.frame.size.width, 100 + resultsHeight);
    [kickstarterPanel setFrame:panelFrame display:YES animate:NO];
    NSRect contentViewRect = [KSUtils makeInnerRectWithOuterRect:kickstarterPanel.frame padding:10];
    NSRect textFieldRect = NSMakeRect(10, 10, 560, 60);
    KSView *contentView = [[KSView alloc] initWithFrame:contentViewRect];
    
    kickstarterPanel.backgroundColor = [NSColor colorWithCalibratedWhite:0.8 alpha:0.3];
    contentView.backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
    panelTextField.backgroundColor = contentView.backgroundColor;
    panelTextField.font = [NSFont fontWithName:@"Lucida Grande" size:45];
    panelTextField.frame = textFieldRect;
    
    [kickstarterPanel.contentView setSubviews:@[]];
    [contentView addSubview:panelTextField];
    
    for (int i = 0; i < panelSearchResults.count; i++) {
        NSRect theRect = NSMakeRect(textFieldRect.origin.x,
                                    textFieldRect.origin.y + textFieldRect.size.height + (50 * i),
                                    textFieldRect.size.width, 50);
        NSTextField *theTextField = [KSUtils makeLabelWithFrame:theRect
                                                           text:[panelSearchResults objectAtIndex:i]];
        theTextField.font = [NSFont fontWithName:@"Lucida Grande" size:20];
        [contentView addSubview:theTextField];
    }
    
    [kickstarterPanel.contentView addSubview:contentView];
    [panelTextField selectText:self];
    panelTextField.currentEditor.selectedRange = previousSelectedRange;
}

- (void)handlePanelTextFieldEvent:(NSNumber *)eventType
{
    if ([eventType isEqualToNumber:@(KSPanelTextFieldEventTypeInsert)]) [self reloadPanel];
    if ([eventType isEqualToNumber:@(KSPanelTextFieldEventTypeReturn)]) {
        if (panelSearchResults.count > 0) {
            [kickstarterPanel close];
            [self launchSetup:[panelSearchResults objectAtIndex:0]];
        }
    }
    if ([eventType isEqualToNumber:@(KSPanelTextFieldEventTypeCancel)]) [kickstarterPanel close];
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
    
    NSArray *currentSetup = [setups objectForKey:self.setupArray[manageSetupsTableView.selectedRow]];
    NSArray *shellInfo = currentSetup[0];
    
    [setupShell selectItemWithTitle:shellInfo[0]];
    setupShellCommands.string = shellInfo[1];
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

- (IBAction)showKickstarterPanel:(id)sender
{
    panelTextField.stringValue = @"";
    
    int panelY = [NSScreen mainScreen].frame.size.height - 700;
    int panelX = ([NSScreen mainScreen].frame.size.width / 2) - 300;
    NSRect panelFrame = NSMakeRect(panelX, panelY, 600, 100);
    [kickstarterPanel setFrame:panelFrame display:YES];
    
    [kickstarterPanel makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    [self reloadPanel];
}

- (IBAction)emailTheDeveloper:(id)sender
{
    [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"mailto:ajay.tatachar@gmail.com"]];
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

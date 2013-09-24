//
//  PanelPreferencesViewController.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 15/09/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MASPreferencesViewController.h>
#import <MASShortcutView.h>
#import <MASShortcutView+UserDefaults.h>

@interface PanelPreferencesViewController : NSViewController <MASPreferencesViewController>
@property (nonatomic, retain) IBOutlet NSButton *fuzzyMatchingCheckbox;
@property (nonatomic, retain) IBOutlet NSView *shortcutViewContainer;
@property (nonatomic, retain) MASShortcutView *shortcutView;
@property (nonatomic, retain) NSString *shortcutUserDefaultsKey;
@property (nonatomic, retain) NSString *fuzzyMatchingUserDefaultsKey;
@property (nonatomic, retain) NSString *hotkeyNotificationName;

- (IBAction)toggleFuzzyMatching:(id)sender;
@end

//
//  UpdatesPreferencesViewController.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 03/07/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferences.h"

@interface UpdatesPreferencesViewController : NSViewController <MASPreferencesViewController>
@property (nonatomic, retain) IBOutlet NSPopUpButton *updateCheckInterval;
@property (nonatomic, retain) IBOutlet NSButton *automaticallyCheckForUpdates;

- (IBAction)toggleAutomaticallyCheckForUpdates:(id)sender;
- (IBAction)changeUpdateCheckInterval:(id)sender;
- (IBAction)checkForUpdates:(id)sender;
@end

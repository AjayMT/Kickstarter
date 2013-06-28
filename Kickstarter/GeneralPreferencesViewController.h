//
//  GeneralPreferencesViewController.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 27/06/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferences.h"
#import "LaunchAtLoginController.h"

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>
@property (nonatomic, retain) IBOutlet NSPopUpButton *setupToLaunch;
@property (nonatomic, retain) IBOutlet NSButton *launchAtLogin;
@property (nonatomic, retain) IBOutlet NSButton *launchSetupAtStartup;
@property (nonatomic, retain) LaunchAtLoginController *launchAtLoginController;

- (IBAction)toggleLaunchAtLogin:(id)sender;
- (IBAction)toggleLaunchSetupAtStartup:(id)sender;
@end

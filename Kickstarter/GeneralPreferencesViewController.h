// GeneralPreferencesViewController.h

#import <Cocoa/Cocoa.h>
#import <MASPreferencesViewController.h>
#import "LaunchAtLoginController.h"

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>
@property (nonatomic, retain) IBOutlet NSButton *launchAtLogin;
@property (nonatomic, retain) IBOutlet NSButton *runShellScriptsQuietly;
@property (nonatomic, retain) IBOutlet NSPopUpButton *terminalApplication;
@property (nonatomic, retain) LaunchAtLoginController *launchAtLoginController;
@property (nonatomic, retain) NSString *runShellScriptsQuietlyUserDefaultsKey;
@property (nonatomic, retain) NSString *terminalApplicationUserDefaultsKey;

- (IBAction)toggleLaunchAtLogin:(id)sender;
- (IBAction)toggleRunShellScriptsQuietly:(id)sender;
- (IBAction)changeTerminalApplication:(id)sender;
- (NSString *)terminalApplicationName;
@end

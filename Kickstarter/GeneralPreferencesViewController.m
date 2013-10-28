// GeneralPreferencesviewController.m

#import "GeneralPreferencesViewController.h"

@interface GeneralPreferencesViewController ()
@end

@implementation GeneralPreferencesViewController
@synthesize launchAtLogin, launchAtLoginController, runShellScriptsQuietly, runShellScriptsQuietlyUserDefaultsKey;
@synthesize terminalApplication, terminalApplicationUserDefaultsKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.launchAtLoginController = [[LaunchAtLoginController alloc] init];
        self.runShellScriptsQuietlyUserDefaultsKey = @"RunShellScriptsQuietly";
        self.terminalApplicationUserDefaultsKey = @"TerminalApplicationForShellScripts";
        
        if (! [[NSUserDefaults standardUserDefaults] valueForKey:runShellScriptsQuietlyUserDefaultsKey])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:runShellScriptsQuietlyUserDefaultsKey];
        
        if (! [[NSUserDefaults standardUserDefaults] valueForKey:terminalApplicationUserDefaultsKey])
            [[NSUserDefaults standardUserDefaults] setValue:@"Terminal" forKey:terminalApplicationUserDefaultsKey];
    }
    
    return self;
}

- (void)awakeFromNib
{
    BOOL quietRun = [[NSUserDefaults standardUserDefaults] boolForKey:runShellScriptsQuietlyUserDefaultsKey];
    runShellScriptsQuietly.state = (quietRun ? NSOnState : NSOffState);
    terminalApplication.enabled = (quietRun ? NO : YES);
    
    NSString *termApp = [[NSUserDefaults standardUserDefaults] stringForKey:terminalApplicationUserDefaultsKey];
    [terminalApplication selectItemWithTitle:termApp];
    
    if (launchAtLoginController.launchAtLogin) {
        launchAtLogin.state = NSOnState;
    } else {
        launchAtLogin.state = NSOffState;
    }
}

- (NSString *)identifier
{
    return NSStringFromClass(self.class);
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return @"General";
}

- (NSString *)terminalApplicationName
{
    return terminalApplication.selectedItem.title;
}

- (IBAction)toggleLaunchAtLogin:(id)sender
{
    if ([sender state] == NSOnState) {
        launchAtLoginController.launchAtLogin = YES;
    } else {
        launchAtLoginController.launchAtLogin = NO;
    }
}

- (IBAction)toggleRunShellScriptsQuietly:(id)sender
{
    if ([sender state] == NSOnState) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:runShellScriptsQuietlyUserDefaultsKey];
        terminalApplication.enabled = NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:runShellScriptsQuietlyUserDefaultsKey];
        terminalApplication.enabled = YES;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeTerminalApplication:(id)sender
{
    NSString *termApp = [sender selectedItem].title;
    [[NSUserDefaults standardUserDefaults] setValue:termApp forKey:terminalApplicationUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

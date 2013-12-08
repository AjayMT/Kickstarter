// GeneralPreferencesviewController.m

#import "GeneralPreferencesViewController.h"

@interface GeneralPreferencesViewController ()
@end

@implementation GeneralPreferencesViewController
@synthesize launchAtLogin, launchAtLoginController, runShellScriptsQuietly, runShellScriptsQuietlyUserDefaultsKey;
@synthesize terminalApplication, terminalApplicationUserDefaultsKey, setupFilePathUserDefaultsKey;
@synthesize setupFilePath, reloadSetupsNotificationName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.launchAtLoginController = [[LaunchAtLoginController alloc] init];
        self.runShellScriptsQuietlyUserDefaultsKey = @"RunShellScriptsQuietly";
        self.terminalApplicationUserDefaultsKey = @"TerminalApplicationForShellScripts";
        self.setupFilePathUserDefaultsKey = @"SetupFilePath";
        self.reloadSetupsNotificationName = @"ReloadSetups";
        
        if (! [[NSUserDefaults standardUserDefaults] valueForKey:runShellScriptsQuietlyUserDefaultsKey])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:runShellScriptsQuietlyUserDefaultsKey];
        
        if (! [[NSUserDefaults standardUserDefaults] valueForKey:terminalApplicationUserDefaultsKey])
            [[NSUserDefaults standardUserDefaults] setValue:@"Terminal" forKey:terminalApplicationUserDefaultsKey];
        
        if (! [[NSUserDefaults standardUserDefaults] valueForKey:setupFilePathUserDefaultsKey]) {
            NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Kickstarter"];
            [[NSUserDefaults standardUserDefaults] setValue:filepath forKey:setupFilePathUserDefaultsKey];
        }
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
    
    setupFilePath.stringValue = [[NSUserDefaults standardUserDefaults] stringForKey:setupFilePathUserDefaultsKey];
    
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

- (IBAction)showOpenPanelForSetupFile:(id)sender
{
    NSOpenPanel *thePanel = [NSOpenPanel openPanel];
    thePanel.title = @"Choose a directory";
    thePanel.canChooseFiles = NO;
    thePanel.canChooseDirectories = YES;
    thePanel.canCreateDirectories = YES;
    thePanel.prompt = @"Select";
    thePanel.allowsMultipleSelection = NO;
    thePanel.showsHiddenFiles = YES;
    
    NSInteger result = thePanel.runModal;
    if (result == NSOKButton)
        setupFilePath.stringValue = [thePanel.URL.path stringByResolvingSymlinksInPath];
}

- (IBAction)setupFilePathDidChange:(id)sender
{
    NSString *oldPath = [[[NSUserDefaults standardUserDefaults] stringForKey:setupFilePathUserDefaultsKey] stringByAppendingPathComponent:@"Setups.plist"];
    [[NSFileManager defaultManager] copyItemAtPath:oldPath toPath:[setupFilePath.stringValue stringByAppendingPathComponent:@"Setups.plist"] error:nil];
    [[NSUserDefaults standardUserDefaults] setValue:setupFilePath.stringValue forKey:setupFilePathUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:reloadSetupsNotificationName object:self];
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

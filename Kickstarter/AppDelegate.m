// AppDelegate.m

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize mainMenu, mainStatusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Configuring the status item
    self.mainStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    mainStatusItem.menu = mainMenu;
    mainStatusItem.title = @"KS";
    mainStatusItem.highlightMode = YES;
    
    // Creating the application support directory
    NSString *applicationSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Kickstarter"];
    BOOL dirExists = [[NSFileManager defaultManager] fileExistsAtPath:applicationSupportPath];
    if (! dirExists)
        [@{} writeToFile:[applicationSupportPath stringByAppendingPathComponent:@"Setups.plist"] atomically:YES];
}

@end

// AppDelegate.m

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize mainMenu, mainStatusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.mainStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    mainStatusItem.menu = mainMenu;
    mainStatusItem.title = @"KS";
    mainStatusItem.highlightMode = YES;
}

@end

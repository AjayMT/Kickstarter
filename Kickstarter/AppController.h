// AppController.h

#import <Foundation/Foundation.h>
#import <MASPreferencesWindowController.h>
#import "KSFloatingWindow.h"
#import "KSPanelTextField.h"

@interface AppController : NSObject
@property (nonatomic, retain) IBOutlet NSWindow *captureWindow;
@property (nonatomic, retain) IBOutlet NSTextField *captureName;
@property (nonatomic, retain) IBOutlet NSWindow *manageSetupsWindow;
@property (nonatomic, retain) IBOutlet NSTableView *manageSetupsTableView;
@property (nonatomic, retain) IBOutlet NSArrayController *setupArrayController;
@property (nonatomic, retain) IBOutlet NSWindow *editSetupWindow;
@property (nonatomic, retain) IBOutlet NSTableView *editSetupTableView;
@property (nonatomic, retain) IBOutlet NSMenu *setupMenu;
@property (nonatomic, retain) IBOutlet NSArrayController *appArrayController;
@property (nonatomic, retain) IBOutlet NSPopUpButton *setupShell;
@property (nonatomic, retain) IBOutlet NSTextView *setupShellCommands;
@property (nonatomic, retain) IBOutlet NSWindow *addAppWindow;
@property (nonatomic, retain) IBOutlet NSPopUpButton *addAppPopUpButton;
@property (nonatomic, retain) NSMutableDictionary *setups;
@property (nonatomic, retain) NSArray *preferencesViewControllers;
@property (nonatomic, retain) NSMutableArray *panelSearchResults;
@property (nonatomic, retain) MASPreferencesWindowController *preferencesWindowController;
@property (nonatomic, retain) KSFloatingWindow *kickstarterPanel;
@property (nonatomic, retain) KSPanelTextField *panelTextField;
@property (nonatomic, readonly, retain) NSArray *setupArray;
@property (nonatomic, readonly, retain) NSArray *appArray;

- (void)reloadSetupMenu;
- (void)reloadData;
- (void)reloadSetups;
- (void)reloadPanel;
- (void)handlePanelTextFieldEvent:(NSNumber *)eventType;
- (void)receiveNotification:(id)sender;
- (IBAction)reloadEditSetupWindow:(id)sender;
- (IBAction)launchSetup:(id)sender;
- (IBAction)captureSetup:(id)sender;
- (IBAction)deleteSetup:(id)sender;
- (IBAction)saveSetup:(id)sender;
- (IBAction)addAppToCurrentSetup:(id)sender;
- (IBAction)removeAppFromCurrentSetup:(id)sender;
- (IBAction)showAddAppWindow:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)showKickstarterPanel:(id)sender;
- (IBAction)emailTheDeveloper:(id)sender;
@end

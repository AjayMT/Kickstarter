// PanelPreferencesViewController.h

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

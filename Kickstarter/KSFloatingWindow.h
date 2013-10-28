// KSFloatingWindow.h

#import <Cocoa/Cocoa.h>

@interface KSFloatingWindow : NSWindow
- (id)initWithContentRect:(NSRect)contentRect;
- (void)receiveNotification:(id)sender;
@end

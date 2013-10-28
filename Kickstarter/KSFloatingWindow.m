// KSFloatingWindow.m

#import "KSFloatingWindow.h"

@implementation KSFloatingWindow

- (id)initWithContentRect:(NSRect)contentRect
{   
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self) {
        self.alphaValue = 1.0;
        self.opaque = NO;
        self.movableByWindowBackground = YES;
        self.level = NSStatusWindowLevel;
        self.releasedWhenClosed = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:NSWindowDidResignKeyNotification
                                                   object:self];
    }
    
    return self;
}

- (void)receiveNotification:(id)sender
{
    [self close];
}

- (BOOL)canBecomeKeyWindow { return YES; }

- (BOOL)canBecomeMainWindow { return YES; }

@end

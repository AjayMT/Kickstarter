//
//  KSPanelTextField.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 16/08/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "KSPanelTextField.h"

@implementation KSPanelTextField
@synthesize controller, controllerAction;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.focusRingType = NSFocusRingTypeNone;
        [self.cell setLineBreakMode:NSLineBreakByTruncatingHead];
        [self.cell setUsesSingleLineMode:YES];
    }
    
    return self;
}

- (void)textDidChange:(NSNotification *)notification
{
    [controller performSelector:controllerAction withObject:@(KSPanelTextFieldEventTypeInsert)];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    if ([[notification.userInfo objectForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement)
        [controller performSelector:controllerAction withObject:@(KSPanelTextFieldEventTypeReturn)];
}

- (void)doCommandBySelector:(SEL)aSelector
{
    if (aSelector == @selector(cancelOperation:))
        [controller performSelector:controllerAction withObject:@(KSPanelTextFieldEventTypeCancel)];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self.backgroundColor set];
    NSRectFill(dirtyRect);
}

@end

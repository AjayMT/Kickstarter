//
//  KSPanelTextField.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 16/08/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "KSPanelTextField.h"

@implementation KSPanelTextField
@synthesize controller, action;

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

- (void)keyUp:(NSEvent *)theEvent
{
    [controller performSelector:action withObject:theEvent];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self.backgroundColor set];
    NSRectFill(dirtyRect);
}

@end

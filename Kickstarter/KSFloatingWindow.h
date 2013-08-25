//
//  FloatingWindow.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 02/08/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KSFloatingWindow : NSWindow
- (id)initWithContentRect:(NSRect)contentRect;
- (void)receiveNotification:(id)sender;
@end

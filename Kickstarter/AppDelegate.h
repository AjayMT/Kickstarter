//
//  AppDelegate.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 21/05/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic, retain) IBOutlet NSMenu *mainMenu;
@property (nonatomic, retain) NSStatusItem *mainStatusItem;

- (void)reloadSetupMenu;
- (void)launchSetup:(NSMenuItem *)sender;
@end

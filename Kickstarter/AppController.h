//
//  AppController.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 22/05/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject
@property (nonatomic, retain) IBOutlet NSWindow *captureWindow;
@property (nonatomic, retain) IBOutlet NSTextField *captureName;

- (IBAction)captureSetup:(id)sender;
@end

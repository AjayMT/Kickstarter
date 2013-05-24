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
@property (nonatomic, retain) IBOutlet NSWindow *manageSetupsWindow;
@property (nonatomic, retain) IBOutlet NSTableView *manageSetupsTableView;
@property (nonatomic, retain) IBOutlet NSArrayController *setupArrayController;
@property (nonatomic, retain) NSMutableDictionary *setups;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, readonly, retain) NSArray *setupArray;

- (void)reloadData;
- (void)receiveNotification:(id)sender;
- (IBAction)captureSetup:(id)sender;
- (IBAction)deleteSetup:(id)sender;
@end

//
//  AppController.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 22/05/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "AppController.h"

@implementation AppController
@synthesize captureWindow, captureName;

- (IBAction)captureSetup:(id)sender
{
    NSString *captureKey = captureName.stringValue;
    NSString *filePath = [[[NSBundle mainBundle] bundlePath]
                          stringByAppendingPathComponent:@"Contents/Resources/Setups.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *runningApps = [NSWorkspace sharedWorkspace].runningApplications;
    NSMutableArray *appArray = [NSMutableArray array];
    
    for (NSRunningApplication *app in runningApps) {
        [appArray addObject:[app localizedName]];
    }
    
    [dict insertValue:appArray atIndex:0 inPropertyWithKey:captureKey];
    [dict writeToFile:filePath atomically:YES];
    
    [captureWindow performClose:sender];
}

@end

//
//  KSPanelTextField.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 16/08/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KSPanelTextField : NSTextField
@property (nonatomic, retain) id controller;
@property (nonatomic) SEL action;
@end

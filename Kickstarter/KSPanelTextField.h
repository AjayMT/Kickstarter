//
//  KSPanelTextField.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 16/08/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum KSPanelTextFieldEventTypes
{
    KSPanelTextFieldEventTypeReturn,
    KSPanelTextFieldEventTypeCancel,
    KSPanelTextFieldEventTypeInsert
} KSPanelTextFieldEventType;

@interface KSPanelTextField : NSTextField
@property (nonatomic, retain) id controller;
@property (nonatomic) SEL controllerAction;
@end

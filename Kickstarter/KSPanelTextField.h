// KSPanelTextField.h

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

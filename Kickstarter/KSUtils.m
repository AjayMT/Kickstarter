// KSutils.m

#import "KSUtils.h"

@implementation KSUtils

+ (NSRect)makeInnerRectWithOuterRect:(NSRect)outerRect padding:(int)padding
{
    return NSMakeRect(padding, padding, outerRect.size.width - (padding * 2), outerRect.size.height - (padding * 2));
}

+ (NSTextField *)makeLabelWithFrame:(NSRect)frame text:(NSString *)text
{
    NSTextField *theLabel = [[NSTextField alloc] initWithFrame:frame];
    theLabel.stringValue = text;
    theLabel.editable = NO;
    theLabel.selectable = NO;
    theLabel.bezeled = NO;
    theLabel.drawsBackground = NO;
    
    return theLabel;
}

@end

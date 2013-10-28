// KSUtils.h

#import <Foundation/Foundation.h>

@interface KSUtils : NSObject
+ (NSRect)makeInnerRectWithOuterRect:(NSRect)outerRect padding:(int)padding;
+ (NSTextField *)makeLabelWithFrame:(NSRect)frame text:(NSString *)text;
@end

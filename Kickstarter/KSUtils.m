//
//  KSUtils.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 04/08/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

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

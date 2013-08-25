//
//  KSUtils.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 04/08/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSUtils : NSObject
+ (NSRect)makeInnerRectWithOuterRect:(NSRect)outerRect padding:(int)padding;
+ (NSTextField *)makeLabelWithFrame:(NSRect)frame text:(NSString *)text;
@end

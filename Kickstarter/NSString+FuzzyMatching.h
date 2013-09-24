//
//  NSString+FuzzyMatching.h
//  Kickstarter
//
//  Created by Ajay Madhusudan on 22/09/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FuzzyMatching)
- (NSArray *)arrayOfCharacters;
- (NSRange)rangeOfString:(NSString *)aString fuzzyMatching:(BOOL)fuzzyMatching;
@end

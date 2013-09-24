//
//  NSString+FuzzyMatching.m
//  Kickstarter
//
//  Created by Ajay Madhusudan on 22/09/13.
//  Copyright (c) 2013 Ajay Madhusudan. All rights reserved.
//

#import "NSString+FuzzyMatching.h"

@implementation NSString (FuzzyMatching)

- (NSArray *)arrayOfCharacters
{
    NSArray *theArray = @[];
    
    for (int i = 0; i < self.length; i++) {
        theArray = [theArray arrayByAddingObject:[self substringWithRange:NSMakeRange(i, 1)]];
    }
    
    return theArray;
}

- (NSRange)rangeOfString:(NSString *)aString fuzzyMatching:(BOOL)fuzzyMatching
{
    if (!fuzzyMatching) return [self rangeOfString:aString];
    
    NSMutableArray *myCharacters = [NSMutableArray arrayWithArray:[self arrayOfCharacters]];
    NSArray *queryCharacters = [aString arrayOfCharacters];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:queryCharacters];
    int position = 0;
    int length = (int)self.length;
    
    for (NSString *character in queryCharacters) {
        if (![myCharacters containsObject:character]) return NSMakeRange(NSNotFound, 0);
    }
    
    for (int i = 0; i < queryCharacters.count; i++) {
        NSString *character = queryCharacters[i];
        
        if (![myCharacters containsObject:character]) return NSMakeRange(NSNotFound, 0);
        
        int index = (int)[myCharacters indexOfObject:character];
        
        if (i == 0) position = index;
        if (i == (queryCharacters.count - 1)) length = i + 1;
        
        [myCharacters removeObjectsInRange:NSMakeRange(0, index + 1)];
        [temp removeObject:character];
    }
    
    return NSMakeRange(position, length);
}

@end

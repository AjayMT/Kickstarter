// NSString+FuzzyMatching.h

#import <Foundation/Foundation.h>

@interface NSString (FuzzyMatching)
- (NSArray *)arrayOfCharacters;
- (NSRange)rangeOfString:(NSString *)aString fuzzyMatching:(BOOL)fuzzyMatching;
@end

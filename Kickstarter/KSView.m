// KSView.m

#import "KSView.h"

@implementation KSView
@synthesize backgroundColor;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NSColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [backgroundColor set];
    NSRectFill(dirtyRect);
}

@end

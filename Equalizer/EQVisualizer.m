//
//  EQVisualizer.m
//  Equalizer
//
//  Created by Feifan Zhou on 9/25/14.
//  Copyright (c) 2014 nepTune Technologies Inc. All rights reserved.
//

#import "EQVisualizer.h"
#import "FunctionalNSArray.h"
#import "EQPoint.h"

@implementation EQVisualizer

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
	
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	// Draw baseline first
	CGFloat viewHeight = [self bounds].size.height;
	CGFloat baselineY = (2.0/3.0) * viewHeight;
	CGContextBeginPath(context);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.3);
	CGContextSetLineWidth(context, 1.0);
	CGContextMoveToPoint(context, 10, baselineY);
	CGContextAddLineToPoint(context, ([self bounds].size.width - 10), baselineY);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathStroke);
	
	// Draw points
	for (EQPoint *point in self.eqPoints) {
		CGRect circleRect = CGRectMake(point.location.x - 5, baselineY/* point.location.y */- 5, 10.0, 10.0);
		CGContextBeginPath(context);
		if (point.isSelected)
			CGContextSetRGBStrokeColor(context, 1, 0, 0, 1.0);
		else
			CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
		CGContextSetLineWidth(context, 1.0);
		CGContextAddEllipseInRect(context, circleRect);
		CGContextDrawPath(context, kCGPathStroke);
	}
}

# pragma mark - 
# pragma mark Event handlers
- (void)mouseDown:(NSEvent *)theEvent {
	if (!self.eqPoints)
		self.eqPoints = [NSMutableArray array];
	else {
		NSArray *deselectedArray = [self.eqPoints mapWithBlock:^(id obj, NSUInteger idx) {
			EQPoint *point = [[EQPoint alloc] init];
			point.location = ((EQPoint *)obj).location;
			point.isSelected = NO;
			return point;
		}];
		self.eqPoints = [NSMutableArray arrayWithArray:deselectedArray];
	}
	NSPoint eventLocation = [theEvent locationInWindow];
	NSPoint center = [self convertPoint:eventLocation fromView:nil];
	[self.eqPoints addObject:[[EQPoint alloc] initWithPoint:center]];
	[self setNeedsDisplay:YES];
}

@end

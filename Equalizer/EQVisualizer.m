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

- (id)initWithFrame:(NSRect)frameRect {
	if (!(self = [super initWithFrame:frameRect]))
		return nil;
	self.mouseoverPoint = CGPointMake(-10, -10);
	self.eqPoints = [NSMutableArray array];
	
	NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
															   options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow)
																 owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
	return self;
}

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
	
	// Draw mouseover point if needed
	if (self.mouseoverPoint.x < 0 && self.mouseoverPoint.y < 0)
		return;
	CGRect circleRect = CGRectMake(self.mouseoverPoint.x - 5, baselineY - 5, 10.0, 10.0);
	CGContextBeginPath(context);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.25);
	CGContextAddEllipseInRect(context, circleRect);
	CGContextDrawPath(context, kCGPathStroke);
}

# pragma mark -
# pragma mark Utility methods
- (NSPoint)pointFromMouseEvent:(NSEvent *)theEvent {
	NSPoint eventLocation = [theEvent locationInWindow];
	NSPoint center = [self convertPoint:eventLocation fromView:nil];
	return center;
}

# pragma mark - 
# pragma mark Event handlers
- (void)mouseDown:(NSEvent *)theEvent {
	NSArray *deselectedArray = [self.eqPoints mapWithBlock:^(id obj, NSUInteger idx) {
		EQPoint *point = [[EQPoint alloc] init];
		point.location = ((EQPoint *)obj).location;
		point.isSelected = NO;
		return point;
	}];
	self.eqPoints = [NSMutableArray arrayWithArray:deselectedArray];
	NSPoint center = [self pointFromMouseEvent:theEvent];
	[self.eqPoints addObject:[[EQPoint alloc] initWithPoint:center]];
	[self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	NSPoint enterPoint = [self pointFromMouseEvent:theEvent];
	self.mouseoverPoint = enterPoint;
	[self setNeedsDisplay:YES];
}
- (void)mouseExited:(NSEvent *)theEvent {
	self.mouseoverPoint = NSMakePoint(-10, -10);
	[self setNeedsDisplay:YES];
}
- (void)mouseMoved:(NSEvent *)theEvent {
	NSPoint point = [self pointFromMouseEvent:theEvent];
	self.mouseoverPoint = point;
	[self setNeedsDisplay:YES];
}

@end

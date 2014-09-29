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

@interface EQVisualizer () {
	CGFloat _baselineY;
}
@end

@implementation EQVisualizer

# pragma mark -
# pragma mark Utility methods
- (NSPoint)pointFromMouseEvent:(NSEvent *)theEvent {
	NSPoint eventLocation = [theEvent locationInWindow];
	NSPoint center = [self convertPoint:eventLocation fromView:nil];
	return center;
}

- (EQPoint *)hoveringNodeNearPoint:(NSPoint)point {
	NSArray *nearestNodes = [self.eqPoints filterWithBlock:^BOOL(id obj, NSUInteger idx) {
		EQPoint *node = (EQPoint *)obj;
		return node.location.x - 5 <= point.x && node.location.x + 5 >= point.x && node.location.y - 5 <= point.y && node.location.y + 5 >= point.y;
	}];
	return ([nearestNodes count] > 0) ? nearestNodes[0] : nil;
}

- (CGFloat)baselineY {
	if (_baselineY <= 0)
		_baselineY = (2.0/3.0) * [self bounds].size.height;
	return _baselineY;
}

#pragma mark -
#pragma mark View methods
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

# pragma mark -
# pragma mark Drawing methods

- (void)drawBaseline:(CGContextRef)context {
	CGFloat baselineY = [self baselineY];
	CGContextBeginPath(context);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.3);
	CGContextSetLineWidth(context, 1.0);
	CGContextMoveToPoint(context, 10, baselineY);
	CGContextAddLineToPoint(context, ([self bounds].size.width - 10), baselineY);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathStroke);
}
- (void)drawDotAtPoint:(NSPoint)point inContext:(CGContextRef)context {
	CGRect circleRect = CGRectMake(point.x - 5, point.y, 10.0, 10.0);
	CGContextSetLineWidth(context, 1.0);
	CGContextAddEllipseInRect(context, circleRect);
	CGContextDrawPath(context, kCGPathStroke);
	
	// Draw vertical line
	CGContextBeginPath(context);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.1);
	CGContextSetLineWidth(context, 1.0);
	CGContextMoveToPoint(context, point.x, 10);
	CGContextAddLineToPoint(context, point.x, [self bounds].size.height - 10);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathStroke);
}
- (void)drawPoint:(EQPoint *)point inContext:(CGContextRef)context {
	CGContextBeginPath(context);
	if (point.isSelected)
		CGContextSetRGBStrokeColor(context, 1, 0, 0, 1.0);
	else
		CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
	[self drawDotAtPoint:point.location inContext:context];
}
- (void)drawHoverPoint:(NSPoint)point inContext:(CGContextRef)context {
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.25);
	NSPoint modifiedPoint = NSMakePoint(point.x, [self baselineY] - 5);
	[self drawDotAtPoint:modifiedPoint inContext:context];
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
	
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	// Draw baseline first
	[self drawBaseline:context];
	
	// Draw points
	for (EQPoint *point in self.eqPoints)
		[self drawPoint:point inContext:context];
	
	// Draw mouseover point if needed
	if (self.mouseoverPoint.x < 0 && self.mouseoverPoint.y < 0)
		return;
	[self drawHoverPoint:self.mouseoverPoint inContext:context];
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
	center.y = [self baselineY] - 5;
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

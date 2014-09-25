//
//  EQPoint.m
//  Equalizer
//
//  Created by Feifan Zhou on 9/25/14.
//  Copyright (c) 2014 nepTune Technologies. All rights reserved.
//

#import "EQPoint.h"

@implementation EQPoint
- (id)initWithPoint:(NSPoint)point {
	if (!(self = [super init]))
		return nil;
	self.location = point;
	self.isSelected = YES;
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Point: (%.2f, %.2f)", self.location.x, self.location.y];
}
@end

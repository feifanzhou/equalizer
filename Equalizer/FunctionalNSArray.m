//
//  FunctionalNSArray.m
//  Equalizer
//
//  Created by Feifan Zhou on 9/25/14.
//  Copyright (c) 2014 nepTune Technologies. All rights reserved.
//

#import "FunctionalNSArray.h"

@implementation NSArray (Map)

- (NSArray *)mapWithBlock:(id (^)(id obj, NSUInteger idx))block {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[result addObject:block(obj, idx)];
	}];
	return result;
}

@end
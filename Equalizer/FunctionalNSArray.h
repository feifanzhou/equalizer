//
//  FunctionalNSArray.h
//  Equalizer
//
//  Created by Feifan Zhou on 9/25/14.
//  Copyright (c) 2014 nepTune Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

- (NSArray *)mapWithBlock:(id (^)(id obj, NSUInteger idx))block;

@end

//
//  EQPoint.h
//  Equalizer
//
//  Created by Feifan Zhou on 9/25/14.
//  Copyright (c) 2014 nepTune Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EQPoint : NSObject
@property NSPoint location;
@property BOOL isSelected;

- (id)initWithPoint:(NSPoint)point;
@end

//
//  EQVisualizer.h
//  Equalizer
//
//  Created by Feifan Zhou on 9/25/14.
//  Copyright (c) 2014 nepTune Technologies Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EQVisualizer : NSView
@property (strong, nonatomic) NSMutableArray *eqPoints;
@property (assign, nonatomic) NSPoint mouseoverPoint;
@end

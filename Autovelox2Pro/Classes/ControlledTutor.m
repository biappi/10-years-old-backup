//
//  ControlledTutor.m
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 08/09/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "ControlledTutor.h"


@implementation ControlledTutor

@synthesize previous, next, lastDistFromNext, lastDistFromPrev,lastFarDistance;
-(void) dealloc
{
	self.previous=nil;
	self.next=nil;
	[super dealloc];
}
@end

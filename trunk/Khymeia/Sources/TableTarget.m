//
//  Target.m
//  Khymeia
//
//  Created by Pasquale Anatriello on 15/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "TableTarget.h"


@implementation TableTarget

@synthesize table;
@synthesize position;

-(id) initwithTable:(TableTargetType) atable andPosition:(int) aposition;
{
	if (self = [super init])
	{
		self.table=atable;
		self.position=aposition;
	}
	return self;
}

+(id) targetWithTarget:(TableTarget*)aTarget;
{
	return [[[TableTarget alloc] initwithTable:aTarget.table andPosition:aTarget.position] autorelease];
}

@end

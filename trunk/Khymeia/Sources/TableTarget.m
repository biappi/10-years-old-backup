//
//  Target.m
//  Khymeia
//
//  Created by Pasquale Anatriello on 15/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "TableTarget.h"

@implementation Target

@synthesize type;
@synthesize position;

+ (Target *) targetWithType:(TargetTypes)theType position:(int)thePosition;
{
	Target * p = [[Target alloc] init];
	p.type = theType;
	p.position = thePosition;
	
	return [p autorelease];
}

+ (Target *) targetWithTarget:(Target*)theTarget;
{
	Target * p = [[Target alloc] init];
	p.type = theTarget.type;
	
	
	return [p autorelease];
}

@end

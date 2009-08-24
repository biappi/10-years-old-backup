//
//  ControlledAutovelox.m
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 29/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "ControlledAutovelox.h"


@implementation ControlledAutovelox
@synthesize autovelox;
-(id) initWithAnnotation:(Annotation *) an
{
	if(self=[super init])
	{
		roadName=@"";
		lastDistance=-1.0;
		goodEuristicResults=0;
		autovelox=[an retain];
	}
	return self;

}

-(void) dealloc
{
	[autovelox release];
	[super dealloc];
}
@end

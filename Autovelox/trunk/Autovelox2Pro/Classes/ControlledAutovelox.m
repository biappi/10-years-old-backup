//
//  ControlledAutovelox.m
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 29/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "ControlledAutovelox.h"


@implementation ControlledAutovelox
@synthesize autovelox, loc,goodEuristicResults,lastDistance;
-(id) initWithAnnotation:(Annotation *) an
{
	if(self=[super init])
	{
		roadName=@"";
		lastDistance=10000;
		goodEuristicResults=0;
		autovelox=[an retain];
		loc=[[CLLocation alloc] initWithCoordinate:autovelox.coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
		//loc.coordinate=autovelox.coordinate;
	}
	return self;

}

-(void) dealloc
{
	[loc release];
	[autovelox release];
	[super dealloc];
}
@end

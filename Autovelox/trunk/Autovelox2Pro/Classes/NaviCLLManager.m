//
//  NaviCLLManager.m
//  iGeoMobileSDK
//
//  Created by Pasquale Anatriello on 16/03/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "NaviCLLManager.h"


@implementation NaviCLLManager

@synthesize newLocation;
@synthesize oldLocation;
@synthesize gpsError;
@synthesize gpsOn;

static NaviCLLManager * defaultManager;

+ (NaviCLLManager *) defaultCLLManager;
{
	if(!defaultManager)
		[[self alloc] init];
 	return defaultManager;
}

+ (id)allocWithZone:(NSZone *)zone;
{
	if (defaultManager == nil) 
	{
		defaultManager= [super allocWithZone:zone];
		return defaultManager;  // assignment and return on first allocation
	}
    return nil; //on subsequent allocation attempts return nil
}


- (id) init;
{	
	lman=[[CLLocationManager alloc] init];
	lman.delegate=self;
	gpsOn = NO;
}

- (void) startGp
{
	[lman startUpdatingLocation];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"gpsBecomeActive" object:self];
}

- (void) stopGps
{
	[lman stopUpdatingLocation];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"gpsBecomeInactive" object:self];
	gpsOn = NO;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocatio fromLocation:(CLLocation *)oldLocatio;
{
	self.newLocation=newLocatio;
	self.oldLocation=oldLocatio;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"gpsUpdate" object:self];
	gpsOn = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
{
	self.gpsError=error;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"gpsError" object:self];
	gpsOn = NO;
}

- (void)dealloc 
{
	self.newLocation=nil;
	self.oldLocation=nil;
	self.gpsError=nil;
	[lman release];
	[super dealloc];
}
@end

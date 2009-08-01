// 
//  Annotation.m
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 26/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation 

@dynamic title;
@dynamic latitude;
@dynamic subtitle;
@dynamic longitude;

-(CLLocationCoordinate2D) coordinate
{
	CLLocationCoordinate2D pippo;
	pippo.latitude=[self.latitude doubleValue];
	pippo.longitude=[self.longitude doubleValue];
	return pippo;
}

@end

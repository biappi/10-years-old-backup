//
//  GpsAnnotation.m
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "GpsAnnotation.h"


@implementation GpsAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
-(void) setCoord:(CLLocationCoordinate2D)coord;
{
	coordinate=coord;
}
@end

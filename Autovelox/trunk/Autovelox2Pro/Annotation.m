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
@dynamic limit;
@dynamic index;
-(CLLocationCoordinate2D) coordinate
{
	CLLocationCoordinate2D pippo;
	pippo.latitude=[self.latitude doubleValue];
	pippo.longitude=[self.longitude doubleValue];
	return pippo;
}
-(AUTOVELOXTYPE) getType;
{
	if([self.title isEqualToString:@"Autovelox mobile"])
		return AUTOVELOXMOBILE;
	if([self.title isEqualToString:@"Autovelox fisso"])
		return AUTOVELOXFISSO;
	if([self.title isEqualToString:@"Tutor Inizio"])
		return TUTOR_INIZIO;
	if([self.title isEqualToString:@"Tutor Fine"])
		return TUTOR_FINE;
	
	return ECOPASS;
}
@end

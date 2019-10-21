//
//  GpsAnnotation.h
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GpsAnnotation : NSObject <MKAnnotation>
	{
		CLLocationCoordinate2D coordinate;
		NSString * title;
		NSString *subtitle;
		
	}
	
	@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
	@property (nonatomic, retain) NSString * title;
	@property (nonatomic, retain) NSString * subtitle;
-(void) setCoord:(CLLocationCoordinate2D)coordinate;
	
@end

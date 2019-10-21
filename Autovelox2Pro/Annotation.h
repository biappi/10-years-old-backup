//
//  Annotation.h
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 26/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>


typedef enum{
	AUTOVELOXFISSO,
	AUTOVELOXMOBILE,
	ECOPASS,
	TUTOR_INIZIO,
	TUTOR_FINE
} AUTOVELOXTYPE;

@interface Annotation :  NSManagedObject <MKAnnotation> 
{
	CLLocationCoordinate2D coordinate;
}



@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * limit;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * type;
//Indice dell'autovelox
@property (nonatomic, retain) NSNumber * index;

@end




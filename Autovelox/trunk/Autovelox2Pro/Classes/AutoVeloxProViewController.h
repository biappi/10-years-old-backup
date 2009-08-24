//
//  AutoVeloxProViewController.h
//  AutoVeloxPro
//
//  Created by Pasquale Anatriello on 24/07/09.
//  Copyright Navionics 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GpsAnnotation.h"
#import "NaviCLLManager.h"
@interface AutoVeloxProViewController : UIViewController <MKMapViewDelegate> {

	MKMapView * map;
	int numAnnot;
	NSArray * annotationsArray;
	NSMutableArray * appoggio;
	NSManagedObjectContext * managedObjectC;
	NSMutableArray * controlledAutoveloxs;
	BOOL fissi;
	BOOL mobili;
	BOOL tutor;
	BOOL ecopass;
	BOOL centered;
	UIButton *centerGps;
	CLLocationManager * location;
	CLLocationCoordinate2D lastPosition;
	NaviCLLManager * manager;
	GpsAnnotation * gpsAnnotation;
	MKAnnotationView * gpsView;
}
-(void)readAnnotationsFromCSV;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withManagedContext:(NSManagedObjectContext *) managedOC;	

@property (nonatomic, assign) BOOL fissi;
@property (nonatomic, assign) BOOL mobili;
@property (nonatomic, assign) BOOL tutor;
@property (nonatomic, assign) BOOL ecopass;
@end


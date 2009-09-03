//
//  AutoVeloxViewController.h
//  AutoVelox
//
//  Created by Alessio Bonu on 24/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MapKit.h>
//#import "AutoVelox2ProAppDelegate.h"
#import "BottomBarController.h"
#import "AlertView.h"
#import "NormalDetailsView.h"
#import "TutorAlertDetailsView.h"
#import "NaviCLLManager.h"
#import "Annotation.h"
#import "SoundAlert.h"

/*typedef enum 
{
	AlertTypeTutor,
	AlertTypeAutoVeloxMobile,
	AlertTypeAutoVeloxFisso,
	AlertTypeEcopass,		
} AlertType;*/



@interface AutoVeloxViewController : UIViewController <MKReverseGeocoderDelegate>
{
	SoundAlert * sa;
	CLLocationManager *locationManager;
	CLLocation *old;
	NaviCLLManager * gpsManager;
	MKReverseGeocoder *geoCoder;
	MKMapView * map;
	UIView *up;
	UIView *bottom;
	UIImageView *limit;
	UIImageView *signal;	
	UIImageView *tac;
	UIImageView *bar;
	UILabel *strada;
	UILabel *speedLabel;
	UILabel *limitSpeed;
	NormalDetailsView *nDV;
	TutorAlertDetailsView *tAVD;
	AlertView * av;
	BottomBarController *ava;
	NSDate * oldDate;
	NSString *street;
	NSString *city;
	NSString *region;
	NSString *postalCode;
	NSString *country;
	float totalTime;
	float totalSpace;
	float speed;
	float speedNumber;
	int distanceFromTutor;
	int limitTutor;	
	int i;
	int avgSp;
	BOOL topAnimationStarted;
	BOOL ontop;
	BOOL animationStarted;
	int autoveloxNumber;
}

@property(nonatomic,readonly) BOOL animationStarted;

-(id)initWithController:(BottomBarController*)avad withMap:(MKMapView*) map;

-(void)animation;

-(void)alert:( AUTOVELOXTYPE)type withDistance:(int)distance andText:(NSString*)descrizione andLimit:(int) lim;

-(void)alertEnd;

-(void)alertTutorBegan;

-(void)alertTutorEnd;

-(void)updateDistance:(int)distance;

-(void)updateTutorAvgSpeed:(int)avS andDistanceFromTutorEnd:(int)end withLimit:(int)limit;

-(void)setAutoveloxNumberInTenKm:(int)num;

@end

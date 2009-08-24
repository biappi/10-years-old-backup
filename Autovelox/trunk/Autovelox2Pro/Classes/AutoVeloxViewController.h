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
#import "AutoVelox2ProAppDelegate.h"
#import "BottomBarController.h"
#import "AlertView.h"
#import "NormalDetailsView.h"
#import "TutorAlertDetailsView.h"
#import "NaviCLLManager.h"
typedef enum 
{
	AlertTypeTutor,
	AlertTypeAutoVeloxMobile,
	AlertTypeAutoVeloxFisso,
	AlertTypeEcopass,		
} AlertType;



@interface AutoVeloxViewController : UIViewController <MKReverseGeocoderDelegate>
{
	CLLocationManager *locationManager;
	float speed;
	NSString *street;
	NSString *city;
	NSString *region;
	NSString *postalCode;
	NSString *country;
	UIView *up;
	UIView *bottom;
	UIImageView *limit;
	int speedNumber;
	MKReverseGeocoder *geoCoder;
	UILabel *strada;
	UILabel *speedLabel;
	BOOL animationStarted;
	BottomBarController *ava;
	UIImageView *tac;
	UIImageView *bar;
	BOOL topAnimationStarted;
	BOOL ontop;
	AlertView * av;
	MKMapView * map;
	NormalDetailsView *nDV;
	TutorAlertDetailsView *tAVD;
	UIImageView *signal;
	int avgSp;
	NSDate * oldDate;
	float totalTime;
	float totalSpace;
	NaviCLLManager * gpsManager;
}

@property(nonatomic,readonly) BOOL animationStarted;
@property(nonatomic,readonly) int speedNumber;

-(id)initWithController:(BottomBarController*)avad withMap:(MKMapView*) map;

-(void)animation;

-(void)alert:(AlertType)type withDistance:(int)distance;

-(void)alertEnd;

-(void)alertTutorBegan;

-(void)alertTutorEnd;

-(void)updateDistance:(int)distance;

-(void)updateTutorAvgSpeed:(int)avS andDistanceFromTutorEnd:(int)end withLimit:(int)limit;

@end

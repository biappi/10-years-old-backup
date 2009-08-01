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




@interface AutoVeloxViewController : UIViewController <CLLocationManagerDelegate,MKReverseGeocoderDelegate>{
	CLLocationManager *locationManager;
	float speed;
	NSString *street;
	NSString *city;
	NSString *region;
	NSString *postalCode;
	NSString *country;
	UIView *up;
	UIView *bottom;
	MKReverseGeocoder *geoCoder;
	UILabel *strada;
	BOOL animationStarted;
	BottomBarController *ava;
	UIImageView *tac;
	UIImageView *bar;
	BOOL topAnimationStarted;
	BOOL ontop;
}

@property(nonatomic,readonly) BOOL animationStarted;

-(id)initWithController:(BottomBarController*)avad;

-(void)animation;


@end

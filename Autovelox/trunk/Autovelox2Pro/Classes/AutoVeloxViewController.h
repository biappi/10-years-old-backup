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
	BOOL tutor;
	int autoveloxNumber;
}

@property(nonatomic,readonly) BOOL animationStarted;

-(id)initWithController:(BottomBarController*)avad withMap:(MKMapView*) map;

-(void)animation;

/** 
 quando rilevi un PDI generi l'allarme che mi indica la distanza mancante al pdi
 dopo averlo lanciato ricordati di fare il refresh della distanza chiamando il metodo updateDistance
 /parametro type: tipo di PDI che ha lanciato l'allarme
 /parametro distance: distanza iniziale
 /parametro andText: descrizione dell'autovelox
 /parametro lim: limite di velocità 
	- lim = limite di velocità se disponibile
	- lim = 0 se invocato per un tutor
	- lim < 0 se non disponibile
 */
-(AlertView*)alert:( AUTOVELOXTYPE)type withDistance:(int)distance andText:(NSString*)descrizione andLimit:(int) lim;

/**
 usato per settare la view di allarme
 */
-(void)setAlarmView:(AlertView*)alv;

/**
 invocato per segnalere la fine di un allarme
 */
-(void)alertEnd;

/**
allarme da lanciare quando inizia il tutor
 */
-(void)alertTutorBegan;
/**
da lanciare quando termina un allarme
 */
-(void)alertTutorEnd;

/**
 fa l'update della schermata di allerta 
 */
-(void)updateDistance:(int)distance;

/**
fa l'update della schermata di allerta del tutor
 */
-(void) updateTutorDistance:(int)dist;

/**
 resetta la velocità media tra due punti intermedi del tutor
 */
-(void)resetAvgSpeed;

/**
 setta il numero di autovelox nel raggio di 5 km
 */
-(void)setAutoveloxNumberInTenKm:(int)num;

/**
 esegue il suono di allarme se
 */
-(void) doSound;

@end

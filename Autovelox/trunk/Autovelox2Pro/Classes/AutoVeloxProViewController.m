//
//  AutoVeloxProViewController.m
//  AutoVeloxPro
//
//  Created by Pasquale Anatriello on 24/07/09.
//  Copyright Navionics 2009. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AutoVeloxProViewController.h"
#import "Annotation.h"
#import "parseCSV.h"
#import "ControlledAutovelox.h"
#import "ControlledTutor.h"
#import <CoreLocation/CoreLocation.h>
#define SQR2            1.414213562    /* square root of 2              */
#define FLN2             0.69314718    /*  ln(2) : frequently used      */

#define RR0F              6378388.0    /*  earth radius  floating.p     */
#define GR           57.29577951308    /*  qty of degrees = 1 radians   */
#define GR_RR0   8.982799339438E-06    /*  GR divided by RR0            */

#define DFPI            6.283185308    /*  pi greco * 2                 */
#define FPI             3.141592654    /*  pi greco                     */
#define HFPI            1.570796327    /*  pi greco / 2  ( half )       */
#define QFPI            0.785398163    /*  pi greco / 4  ( quarter )    */
#define FPI32            4.71238898    /*  pi greco * 3/2               */

#define KC             1.0067642927    /*  internal conv. constant      */

#define SCMILES            10800.00    /*  miles of the half earth circum. */
#define NML60             111136.20    /*  NML * 60  ( meters for 1 deg. ) */

#define RR0                6378388L    /*  earth radius                 */
#define SCMM              20038300L    /*  earth half circumpherence    */
#define CMM               40076600L    /*  earth circumpherence         */
@implementation AutoVeloxProViewController

@synthesize fissi,mobili,tutor,ecopass;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withManagedContext:(NSManagedObjectContext *) managedOC ;	
{
	if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		gpsUpdated=NO;
		alertNoNet=NO;
		annotationsArray=[[NSMutableArray alloc] init];
		
		appoggio=[[NSMutableArray alloc] init];
		managedObjectC=managedOC;
		//[self readAnnotationsFromCSV];
		
		NSUserDefaults * def=[NSUserDefaults standardUserDefaults];
		int i=[def integerForKey:@"Fissi"];
		if(i)
			fissi=YES;
		else 
			fissi=NO;
		i=[def integerForKey:@"Mobili"];
		if(i)
			mobili =YES;
		else 
			mobili =NO;
		i=[def integerForKey:@"Tutor"];
		if(i)
			tutor =YES;
		else 
			tutor =NO;
		i=[def integerForKey:@"Ecopass"];
		if(i)
			ecopass =YES;
		else 
			ecopass =NO;
		
		
		centered=NO;
		manager=[NaviCLLManager defaultCLLManager];
		[manager startGp];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gpsUpdate) name:@"gpsUpdate" object:nil];
		gpsAnnotation=[[GpsAnnotation alloc] init];
		CLLocationCoordinate2D pippo;
		pippo.latitude=39.37821;
		pippo.longitude=9.04000;
		[gpsAnnotation setCoord:pippo];
		pippo.latitude=0;
		pippo.longitude=0;
		lastPosition=pippo;
		angle=0.0;
		regionChangeRequested=NO;
		currentAlarms =[[NSMutableArray alloc] init];
		inTutor=NO;
		alarmViews=[[NSMutableArray alloc] init];
		currAlarmIndex=0;
	}
	return self;
}

-(void) setAutoView:(AutoVeloxViewController *) vc;
{
	autoView=vc;
}
- (void)gpsUpdate
{
	lastPosition=manager.newLocation.coordinate;
	if(manager.newLocation.course>0)
		angle=manager.newLocation.course;
	gpsUpdated=YES;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	map=[[MKMapView alloc] init];
	map.frame=CGRectMake(0, 170, 320, 270);
	map.delegate=self;
	CLLocationCoordinate2D pippo;
	pippo.latitude=41.89201223640885;
	pippo.longitude=12.48283953157314;
	map.showsUserLocation=YES;
	[map setRegion:MKCoordinateRegionMake(pippo, MKCoordinateSpanMake(5.0, 5.0))];
	self.view=map;
	controlledAutoveloxs=[[NSMutableArray alloc] init];
	[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(controlNearAutovelox:) userInfo:nil repeats:YES];
	[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(centerMap) userInfo:nil repeats:YES];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(evaluateCandidates) userInfo:nil repeats:YES];
	centerGps=[UIButton buttonWithType:UIButtonTypeInfoDark];
	[centerGps setImage:[UIImage imageNamed:@"mirinoUnpressedsmall.png"] forState:UIControlStateNormal];
	//[centerGps setImage:[UIImage imageNamed:@"mirinoPressedsmall.png"] forState:UIControlStateHighlighted];
	centerGps.frame=CGRectMake(275, 15, 30, 30);
	[centerGps addTarget:self action:@selector(center) forControlEvents:UIControlEventTouchDown];
	//[map addAnnotation:gpsAnnotation];
	[self.view addSubview:centerGps];
	//	tmp=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CarSmall.png"]];
	//[map addSubview:tmp];
	//[[((UIView*)[((UIView*)[map.subviews objectAtIndex:0]).subviews objectAtIndex:0]).subviews objectAtIndex:1] addSubview:tmp];
	//tmp.center=[map convertPoint:CGPointMake(100, 100) toView:[((UIView*)[((UIView*)[map.subviews objectAtIndex:0]).subviews objectAtIndex:0]).subviews objectAtIndex:1]];
	//overlay=[((UIView*)[((UIView*)[map.subviews objectAtIndex:0]).subviews objectAtIndex:0]).subviews objectAtIndex:1];
}
-(void) centerMap
{
	//[map addAnnotation:gpsAnnotation];
	//angle+=0.3;
	
	if(centered)
	{
		//[map setCenterCoordinate:gpsAnnotation.coordinate animated:NO];
		//[map setCenterCoordinate:manager.newLocation.coordinate animated:YES];
		double latmap=map.centerCoordinate.latitude;
		//double userlat=gpsAnnotation.coordinate.latitude;
		double userlat=manager.newLocation.coordinate.latitude;
		double controllo=latmap- userlat;
		if(controllo<0)
			controllo*=-1;
		
		latmap=map.centerCoordinate.longitude;
		//userlat=gpsAnnotation.coordinate.longitude;
		userlat=manager.newLocation.coordinate.longitude;
		double controllo2=latmap- userlat;
		if(controllo2<0)
			controllo2*=-1;
		if(controllo >(map.region.span.latitudeDelta/100.0) || controllo2>(map.region.span.longitudeDelta/100.0))
		{
			[map setCenterCoordinate:manager.newLocation.coordinate animated:YES];
		}
		regionChangeRequested=YES;
	}
}
-(void) center;
{
	if(!centered)
	{
		centered=YES;
		//[centerGps setImage:[UIImage imageNamed:@"mirinoPressedsmall.png"] forState:UIControlStateNormal];
		[centerGps setAlpha:0.2];
		//[map setCenterCoordinate:gpsAnnotation.coordinate animated:YES];
		double latmap=map.centerCoordinate.latitude;
		//double userlat=gpsAnnotation.coordinate.latitude;
		double userlat=manager.newLocation.coordinate.latitude;
		double controllo=latmap- userlat;
		if(controllo<0)
			controllo*=-1;
		
		latmap=map.centerCoordinate.longitude;
		//userlat=gpsAnnotation.coordinate.longitude;
		userlat=manager.newLocation.coordinate.longitude;
		double controllo2=latmap- userlat;
		if(controllo2<0)
			controllo2*=-1;
		if(controllo >(map.region.span.latitudeDelta/100.0) || controllo2>(map.region.span.longitudeDelta/100.0))
		{
			[map setCenterCoordinate:manager.newLocation.coordinate animated:YES];
			regionChangeRequested=YES;
		}
		
	}
	
}

- (void)controlNearAutovelox:(NSTimer*)theTimer
{
	
	
	CLLocationCoordinate2D userPosition=[map userLocation].coordinate;
	NSNumber * latmax=[NSNumber numberWithDouble:( userPosition.latitude + (0.05))];
	NSNumber * latmin=[NSNumber numberWithDouble:( userPosition.latitude - (0.05))];
	NSNumber * lonmax=[NSNumber numberWithDouble:( userPosition.longitude + (0.05))];
	NSNumber * lonmin=[NSNumber numberWithDouble:( userPosition.longitude - (0.05))];
	
	//NSLog(@"searching latmax %@ latmin %@ lonMax %@ lonmin %@",latmax,latmin,lonmax,lonmin );
	
	
	
	NSString * predicString=[NSString stringWithFormat:@"latitude > %@ && latitude < %@ &&longitude < %@ && longitude > %@ ", latmin,latmax,lonmax,lonmin];
	BOOL firstAnd=YES;
	if(!fissi && !mobili && !ecopass && !tutor)
		return;
	if(fissi)
	{
		if(firstAnd)
		{
			firstAnd=NO;
			NSString * toApp=[NSString stringWithFormat:@" &&( (type==%d)",AUTOVELOXFISSO];
			predicString=[predicString stringByAppendingString:toApp];
		}
		else {
			NSString * toApp=[NSString stringWithFormat:@" || (type==%d)",AUTOVELOXFISSO];
			predicString=[predicString stringByAppendingString:toApp];
		}
		
	}
	if(mobili)
	{
		if(firstAnd)
		{
			firstAnd=NO;
			NSString * toApp=[NSString stringWithFormat:@" &&( (type==%d)",AUTOVELOXMOBILE];

			predicString=[predicString stringByAppendingString:toApp];
		}
		else {
			NSString * toApp=[NSString stringWithFormat:@" || (type==%d)",AUTOVELOXMOBILE];

			predicString=[predicString stringByAppendingString:toApp];
		}
	}
	if(tutor)
	{
		if(firstAnd)
		{
			firstAnd=NO;
			NSString * toApp=[NSString stringWithFormat:@" &&( (type==%d)",TUTOR_INIZIO];
			predicString=[predicString stringByAppendingString:toApp];
		}
		else {
			NSString * toApp=[NSString stringWithFormat:@" || (type==%d)",TUTOR_INIZIO];

			predicString=[predicString stringByAppendingString:toApp];
		}
	}
	if(ecopass)
	{
		if(firstAnd)
		{
			firstAnd=NO;
			NSString * toApp=[NSString stringWithFormat:@" &&( (type==%d)",ECOPASS];
			predicString=[predicString stringByAppendingString:toApp];
		}
		else {
			NSString * toApp=[NSString stringWithFormat:@" || (type==%d)",ECOPASS];
			predicString=[predicString stringByAppendingString:toApp];
		}
	}
	predicString=[predicString stringByAppendingString:@")"];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicString];
	
	
	
	
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Annotation"
								   
											  inManagedObjectContext:managedObjectC];
	
	[request setEntity:entity];
	[request setPredicate:predicate];
	NSError * err;
	NSArray *array = [[managedObjectC executeFetchRequest:request error:&err] retain];
	//NSLog(@"found %d results",[array count]);
	for(Annotation * an in array)
	{
		
		//CLLocation * a=[[CLLocation alloc] initWithLatitude:an.coordinate.latitude longitude:an.coordinate.longitude];
		//double dist=[user getDistanceFrom:a];
		BOOL found=NO;
		for(ControlledAutovelox * autovelox in controlledAutoveloxs)
		{
			if( an==autovelox.autovelox)
			{
				found=YES;
				break;
			}
		}
		if(!found)
		{
			//ADDING A TUTOR
			if([an.type intValue]==TUTOR_INIZIO)
			{
				NSLog(@"Adding tutor %@ with index %d",[an subtitle],[an index]);
				int indice=[[an index] intValue];
				predicString=[NSString stringWithFormat:@"(type==%d)",TUTOR_INIZIO];
				NSString * toAppend=[NSString stringWithFormat:@" && (index== %d) && (subtitle LIKE[cd] '%@') ",indice+1,[an subtitle]];
				predicString=[predicString stringByAppendingString:toAppend];
				//predicString=[predicString stringByAppendingString:@" && (index== %d)",indice+1];
				predicate = [NSPredicate predicateWithFormat:predicString];
				[request setEntity:entity];
				[request setPredicate:predicate];
				NSError * err;
				NSArray *arrayNext = [[managedObjectC executeFetchRequest:request error:&err] retain];
				predicString=[NSString stringWithFormat:@"(type==%d)",TUTOR_INIZIO];
				toAppend=[NSString stringWithFormat:@" && (index== %d) && (subtitle LIKE[cd] '%@')",indice-1,[an subtitle]];
				predicString=[predicString stringByAppendingString:toAppend];
				predicate = [NSPredicate predicateWithFormat:predicString];
				[request setEntity:entity];
				[request setPredicate:predicate];
				NSArray *arrayPrev = [[managedObjectC executeFetchRequest:request error:&err] retain];
				ControlledTutor * a=[[ControlledTutor alloc] initWithAnnotation:an];
				if([arrayPrev count])
				{
					a.previous=[arrayPrev objectAtIndex:0];
					NSLog(@"previous found named %@",a.previous.subtitle);
				}
				if([arrayNext count]==0)
				{
					predicString=[NSString stringWithFormat:@"(type==%d)",TUTOR_FINE];
					toAppend=[NSString stringWithFormat:@" && (subtitle LIKE[cd] '%@')",[an subtitle]];
					predicString=[predicString stringByAppendingString:toAppend];
					//predicString=[predicString stringByAppendingString:@" && (index== %d)",indice+1];
					predicate = [NSPredicate predicateWithFormat:predicString];
					[request setEntity:entity];
					[request setPredicate:predicate];
					NSArray *arrayNext = [[managedObjectC executeFetchRequest:request error:&err] retain];
					if([arrayNext count])
					{
						a.next=[arrayNext objectAtIndex:0];
						NSLog(@"Next found and is the end named %@",a.next.subtitle);
					}
					else{
						NSLog(@"Next not found");
					}
				}
				else {
					
					a.next=[arrayNext objectAtIndex:0];
					NSLog(@"Next found named %@",a.next.subtitle);
				}
				[controlledAutoveloxs addObject:a];
				[a release];
				
			}
			else{
				ControlledAutovelox * a=[[ControlledAutovelox alloc] initWithAnnotation:an];
				[controlledAutoveloxs addObject:a];
				[a release];
			}
		}
	}
	[autoView setAutoveloxNumberInTenKm:[controlledAutoveloxs count]];
	[array release];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
	if(!alertNoNet)
	{
		alertNoNet=YES;
		UIAlertView * a=[[UIAlertView alloc] initWithTitle:@"Rete dati non disponibile" message:@" Verranno visualizzati la posizione ed i PDI ma non la mappa il programma funzionera' comunque normalmente" delegate:nil cancelButtonTitle:@"Cancella" otherButtonTitles:nil];
		[a show];
		[a release];
	}
}


-(CGPoint) latLongToMM:(CLLocationCoordinate2D)coordinate
{
	double intd;
	CGPoint point;
	intd = atan(tan(coordinate.latitude / GR) / KC) + HFPI;
	
	point.y = (int)(log(tan(intd / 2.0)) * RR0F);
	
	
	point.x = (int)(coordinate.longitude * RR0F / GR);

	if (point.x > SCMM)
	{
		point.x = SCMM;
	}
	else if (point.x < -SCMM)
	{
		point.x = -SCMM;
	}
	return point;
	
}
-(void) evaluateCandidates
{
	
	if(gpsUpdated)
	{
		gpsUpdated=NO;
#pragma mark CONTROL AND UPDATE THE TUTOR
		if(inTutor)
		{
			
			//SONO IN UN TUTOR CONTROLLARLO E UPDATARLO
			CLLocation * loc=[[CLLocation alloc] initWithCoordinate:currentTutor.next.coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:0];
			double currDist=[manager.newLocation getDistanceFrom:loc];
			[autoView updateTutorDistance:(int) currDist];
			//NSLog(@"Sono in un tutor ho settato la distanza dal prossimo a %f",currDist);
			if(currDist> currentTutor.lastDistFromNext)
			{
				currentTutor.lastFarDistance+=(currDist-currentTutor.lastDistFromNext);
				currentTutor.lastDistFromNext=currDist;
				if(currentTutor.lastFarDistance>2000)
				{
					[autoView alertTutorEnd];
					inTutor=NO;
					NSLog(@"Mi sono allontanato consecutivamente per 2km esco dal modo tutor");
				}
			}
			else if(currDist<currentTutor.lastDistFromNext){
				currentTutor.lastFarDistance=0;
			}
			/*if(currDist<1000)
			{
				[autoView doSound];
			}*/
			if(currDist<40)
			{
				if([currentTutor.next.type intValue]==TUTOR_FINE)
				{
					[autoView alertTutorEnd];
					inTutor=NO;
					NSLog(@"Arrivato alla fine del tutor esco dal modo tutor");
				}
				else{
					
					
					NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
					
					NSEntityDescription *entity = [NSEntityDescription entityForName:@"Annotation"
												   
															  inManagedObjectContext:managedObjectC];
					
					//[request setEntity:entity];
					int indice=[[currentTutor.next index] intValue];
					NSString * predicString=[NSString stringWithFormat:@"(type==%d)",TUTOR_INIZIO];
					NSString * toAppend=[NSString stringWithFormat:@" && (index== %d) && (subtitle LIKE[cd] '%@')",indice+1,[currentTutor.autovelox subtitle]];
					predicString=[predicString stringByAppendingString:toAppend];
					//predicString=[predicString stringByAppendingString:@" && (index== %d)",indice+1];
					NSPredicate *predicate = [NSPredicate predicateWithFormat:predicString];
					[request setEntity:entity];
					[request setPredicate:predicate];
					NSError * err;
					NSArray *arrayNext = [[managedObjectC executeFetchRequest:request error:&err] retain];
					
					ControlledTutor * a=[[ControlledTutor alloc] initWithAnnotation:currentTutor.next];
					if([arrayNext count]==0)
					{
						predicString=[NSString stringWithFormat:@"(type==%d)",TUTOR_FINE];
						toAppend=[NSString stringWithFormat:@" && (subtitle LIKE[cd] '%@') ",[currentTutor.autovelox subtitle]];
						predicString=[predicString stringByAppendingString:toAppend];
						//predicString=[predicString stringByAppendingString:@" && (index== %d)",indice+1];
						predicate = [NSPredicate predicateWithFormat:predicString];
						[request setEntity:entity];
						[request setPredicate:predicate];
						NSArray *arrayNext = [[managedObjectC executeFetchRequest:request error:&err] retain];
						if([arrayNext count])
							a.next=[arrayNext objectAtIndex:0];
					}
					else {
						a.next=[arrayNext objectAtIndex:0];
					}
					//[controlledAutoveloxs addObject:a];
					[currentTutor release];
					currentTutor=a;
					
					[autoView resetAvgSpeed];
					
					
					
					
				}
			}
			
		}
		/*double currDist=[manager.newLocation getDistanceFrom: currentAlarm.loc];
		 [autoView updateDistance:(int) currDist];
		 if(currDist>(currentAlarm.lastDistance+200) ||currDist < 30)
		 {
		 [autoView alertEnd];
		 [currentAlarm release];
		 currentAlarm=nil;
		 }*/
#pragma mark SWITCH BETWEEN ACTIVE ALARMS DONE
		/*
		 Setto un nuovo allarme (lo stesso se c'è solo un allarme) aggiorno e controllo se eliminarlo
		 */  
	if([alarmViews count])
	{
		currAlarmIndex++;
		currAlarmIndex=currAlarmIndex%([alarmViews count]);
		[autoView setAlarmView:((AlertView*)((ControlledAutovelox*)[alarmViews objectAtIndex:currAlarmIndex]).alarmView)];
		double currDist=[manager.newLocation getDistanceFrom: ((ControlledAutovelox*)[alarmViews objectAtIndex:currAlarmIndex]).loc];
		[autoView updateDistance:(int) currDist];
		NSLog(@"Setted distance from alarm to %f",currDist);
	}
		/*
		 Controllo tra gli altri allarmi se c'è qualcuno da eliminare
		 */
		NSMutableArray *toRem=[[NSMutableArray alloc] init];
		for(ControlledAutovelox * a in alarmViews)
		{
			double currDi=[manager.newLocation getDistanceFrom:a.loc];
			if(currDi<40)
			{
				[toRem addObject:a];
				/*if([alarmViews indexOfObject:a]==currAlarmIndex)
				{
					[autoView alertEnd];
				}*/
				if([a.autovelox.type intValue]==TUTOR_INIZIO)
				{
					if(!inTutor)
					{
						if(currentTutor)
						{
							[currentTutor release];
							currentTutor=nil;
						}
						currentTutor=[a retain];
						[autoView alertTutorBegan];
						CLLocation * loc=[[CLLocation alloc] initWithCoordinate:currentTutor.next.coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:0];
						double currDist=[manager.newLocation getDistanceFrom:loc];
						[autoView updateTutorDistance:(int) currDist];
						currentTutor.lastDistFromNext=currDist;
						inTutor=YES;
					}
				}
			}
			else 
			{
				if(currDi>a.lastDistance+10)
				{
					
					/*if([alarmViews indexOfObject:a]==currAlarmIndex)
					{
						[autoView alertEnd];
					}*/
					[toRem addObject:a];
					NSLog(@"Removed alarm %@ distance increased",a.autovelox.subtitle);
				
				}
				else{
					a.lastDistance=currDi;
					/*if ([a isKindOfClass:[ControlledTutor class]]) {
					 ((ControlledTutor *) a).lastFarDistance=0;
					 }*/
				}
			}
			
#pragma mark REMOVE CLOSED ALARMS DONE
#pragma mark REMOVE TUTOR ALARM IF NEW TUTOR OR IF OUTSIDE THE TUTOR
			//SWITCH THE ALARMS CONTROL THE TUTOR
		}
		if([alarmViews count]==[toRem count])
		{
			[autoView alertEnd];
		}
		[alarmViews removeObjectsInArray:toRem];
		[toRem release];
		//HERE
		CGPoint mmUserPos=[self latLongToMM:manager.newLocation.coordinate];
		NSMutableArray * autoToRemove=[[NSMutableArray alloc] init];
		//NSLog(@"controlling %d autoveloxs",[controlledAutoveloxs count]);
		for(ControlledAutovelox * a in controlledAutoveloxs)
		{
			BOOL checkAngle=NO;
			float angleDir;
			if(manager.newLocation.course>0)
			{
				CGPoint mmCoordinate=[self latLongToMM:a.loc.coordinate];
				float denomY=mmCoordinate.y-mmUserPos.y;
				float denomX=mmCoordinate.x-mmUserPos.x;	
				angleDir=(atan(denomY/denomX)*57.2957795131);
				if(mmUserPos.x<mmCoordinate.x && mmUserPos.y<mmCoordinate.y)
					angleDir= 90-angleDir;
				else if(mmUserPos.x>mmCoordinate.x && mmUserPos.y<mmCoordinate.y)
					angleDir= 270-angleDir;
				else if(mmUserPos.x>mmCoordinate.x && mmUserPos.y>mmCoordinate.y)
					angleDir= 270-angleDir;
				else if(mmUserPos.x<mmCoordinate.x && mmUserPos.y>mmCoordinate.y)
					angleDir= 90-angleDir;
				checkAngle=YES;
			}	
			
			
			double currDist=[manager.newLocation getDistanceFrom: a.loc];
			double distFromNext=0.0;
			double distFromPrev=0.0;
			
			if(currDist>5000)
			{
				[autoToRemove addObject:a];
			}
			else {
				if([a.autovelox.type intValue]==TUTOR_INIZIO)
				{
					ControlledTutor *tut=(ControlledTutor*) a;
					if(tut.next)
					{
						distFromNext=[manager.newLocation getDistanceFrom: [[[CLLocation alloc] initWithCoordinate:tut.next.coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:0] autorelease]];
					}
					if(tut.previous)
					{
						distFromPrev=[manager.newLocation getDistanceFrom: [[[CLLocation alloc] initWithCoordinate:tut.next.coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:0] autorelease]];
					}
					
					//MAKE SOME CHANGES HERE NOW SHOULD WORK BUT MUST BE TESTED
					if(checkAngle && (abs(manager.newLocation.course -angleDir)<6) && currDist<a.lastDistance && distFromNext<tut.lastDistFromNext && distFromPrev>=tut.lastDistFromPrev)
					{
						a.goodEuristicResults=a.goodEuristicResults+1;
					}
					else {
						if(checkAngle && distFromNext!=tut.lastDistFromNext)
							a.goodEuristicResults=0;
						a.lastDistance=currDist;
						tut.lastDistFromNext=distFromNext;
						tut.lastDistFromPrev=distFromPrev;
					}
					
					
				}
				else{
					
					if(checkAngle && (abs(manager.newLocation.course -angleDir)<6) && currDist<a.lastDistance)
					{
						a.goodEuristicResults=a.goodEuristicResults+1;
					}
					else {
						if(checkAngle)
							a.goodEuristicResults=0;
					}
					a.lastDistance=currDist;
				}
				if(a.lastDistance<400 && a.goodEuristicResults>0)
				{
#pragma mark THROW GPSGENERICALARM  GENERATE ECOPASS ALARM
					[currentAlarms addObject:a];
					//	[autoView alert:[a.autovelox getType] withDistance:a.lastDistance]; 
					if([a.autovelox.type intValue]==AUTOVELOXFISSO){
						UIView *toAdd=[autoView alert:AUTOVELOXFISSO withDistance:a.lastDistance andText:a.autovelox.subtitle andLimit:[a.autovelox.limit intValue]];
						a.alarmView=toAdd;
						[alarmViews addObject:a];
						currAlarmIndex=[alarmViews indexOfObject:a];
					}
					else if ([a.autovelox.type intValue]==AUTOVELOXMOBILE){
						UIView *toAdd=[autoView alert:AUTOVELOXMOBILE withDistance:a.lastDistance andText:a.autovelox.subtitle andLimit:[a.autovelox.limit intValue]];
						a.alarmView=toAdd;
						[alarmViews addObject:a];
						currAlarmIndex=[alarmViews indexOfObject:a];
					}
#pragma mark YOU NEED TO DO A BETTER CHECK HERE 
					else if([a.autovelox.type intValue]==TUTOR_INIZIO &&!inTutor){
						UIView *toAdd=[autoView alert:TUTOR_INIZIO withDistance:a.lastDistance andText:a.autovelox.subtitle andLimit:[a.autovelox.limit intValue]];
						a.alarmView=toAdd;
						[alarmViews addObject:a];
						currAlarmIndex=[alarmViews indexOfObject:a];
					}
					
				}
				
			}
		}	
			

		
		[controlledAutoveloxs removeObjectsInArray:autoToRemove];
		[autoToRemove release];
	}
	
}
	
	- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
		[super didReceiveMemoryWarning];
		
		// Release any cached data, images, etc that aren't in use.
	}
	
	- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
	{
		//if((![annotation isKindOfClass:[Annotation class]]) && (![annotation isKindOfClass:[GpsAnnotation class]]))
		//	return nil;
		
		if(![annotation isKindOfClass:[Annotation class]])
		{
			return nil;
		}
		MKAnnotationView * view=[mapView dequeueReusableAnnotationViewWithIdentifier:@"autovelox"];
		if(!view)
		{
			view=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"autovelox"] autorelease];
			view.canShowCallout=YES;
		}
		else {
			view.annotation=annotation;
		}
		Annotation * tmp=(Annotation *) annotation;
		if([tmp.type intValue]==AUTOVELOXFISSO){
			view.image=[UIImage imageNamed:@"autoVeloxFisso40.png"];
		}
		else if([tmp.type intValue]==AUTOVELOXMOBILE)
		{
			view.image=[UIImage imageNamed:@"autoVeloxMobile40.png"];
		}
		else if([tmp.type intValue]==TUTOR_INIZIO)
		{
			view.image=[UIImage imageNamed:@"tutorInizioSmall.png"];
		}
		else if([tmp.type intValue]==TUTOR_FINE)
		{
			view.image=[UIImage imageNamed:@"tutorFineSmall.png"];
		}
		else if([tmp.type intValue]==ECOPASS)
		{
			view.image=[UIImage imageNamed:@"Ecopass40.png"];
		}
		
		
		[view setNeedsDisplay];
		return view;
		
	}
	
	- (void)dealloc {
		[super dealloc];
		[autoView release];
		[centerGps release];
		[annotationsArray release];
		[gpsAnnotation release];
		if(appoggio)
			[appoggio release];
	}


	- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
	{
	
				
		if(regionChangeRequested)
			regionChangeRequested=NO;
		else {
			centered=NO;
			centerGps.alpha=1;
		}
		
		//NSLog(@"Did change");
		MKCoordinateRegion region=[mapView region];
		//NSLog(@"Region with center %f %f and span %f %f",region.center.latitude,region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta);
		//NSArray * tmp=map.annotations;
		
		if(map.region.span.latitudeDelta>0.1)
		{
			if(appoggio &&[appoggio count])
			{
				[map removeAnnotations:appoggio];
				[appoggio removeAllObjects];
			}
			return;
			
		}
		if(map.region.span.latitudeDelta<0.004189)
		{
			[map setRegion:MKCoordinateRegionMake(map.centerCoordinate, MKCoordinateSpanMake(0.0042, map.region.span.longitudeDelta)) animated:YES];
		}
		NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Annotation"
									   
												  inManagedObjectContext:managedObjectC];
		
		[request setEntity:entity];
		
		double latspan=region.span.latitudeDelta;
		double lonspan=region.span.longitudeDelta;
		NSNumber * latmax=[NSNumber numberWithDouble:( region.center.latitude + (latspan/2))];
		NSNumber * latmin=[NSNumber numberWithDouble:( region.center.latitude - (latspan/2))];
		NSNumber * lonmax=[NSNumber numberWithDouble:( region.center.longitude + (lonspan/2))];
		NSNumber * lonmin=[NSNumber numberWithDouble:( region.center.longitude - (lonspan/2))];
		NSString * predicString=[NSString stringWithFormat:@"latitude > %@ && latitude < %@ &&longitude < %@ && longitude > %@ ", latmin,latmax,lonmax,lonmin];
		BOOL firstAnd=YES;
		if(!fissi && !mobili && !ecopass && !tutor)
			return;
		
		
		if(fissi)
		{
			if(firstAnd)
			{
				firstAnd=NO;
				NSString * toApp=[NSString stringWithFormat:@" &&( (type==%d)",AUTOVELOXFISSO];
				predicString=[predicString stringByAppendingString:toApp];
			}
			else {
				NSString * toApp=[NSString stringWithFormat:@" || (type==%d)",AUTOVELOXFISSO];
				predicString=[predicString stringByAppendingString:toApp];
			}
			
		}
		if(mobili)
		{
			if(firstAnd)
			{
				firstAnd=NO;
				NSString * toApp=[NSString stringWithFormat:@" &&( (type==%d)",AUTOVELOXMOBILE];
				
				predicString=[predicString stringByAppendingString:toApp];
			}
			else {
				NSString * toApp=[NSString stringWithFormat:@" || (type==%d)",AUTOVELOXMOBILE];
				
				predicString=[predicString stringByAppendingString:toApp];
			}
		}
		if(tutor)
		{
			if(firstAnd)
			{
				firstAnd=NO;
				NSString * toApp=[NSString stringWithFormat:@" &&( ((type==%d) ||(type==%d))",TUTOR_INIZIO,TUTOR_FINE];
				predicString=[predicString stringByAppendingString:toApp];
			}
			else {
				NSString * toApp=[NSString stringWithFormat:@" || ((type==%d)||(type==%d))",TUTOR_INIZIO,TUTOR_FINE];
				
				predicString=[predicString stringByAppendingString:toApp];
			}
		}
		if(ecopass)
		{
			if(firstAnd)
			{
				firstAnd=NO;
				NSString * toApp=[NSString stringWithFormat:@" &&( (type==%d)",ECOPASS];
				predicString=[predicString stringByAppendingString:toApp];
			}
			else {
				NSString * toApp=[NSString stringWithFormat:@" || (type==%d)",ECOPASS];
				predicString=[predicString stringByAppendingString:toApp];
			}
		}
		
		predicString=[predicString stringByAppendingString:@")"];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:predicString];
		[request setPredicate:predicate];
		
		NSError *error = nil;
		
		NSArray *array = [managedObjectC executeFetchRequest:request error:&error];
		//if(appoggio)
		//	[appoggio addObjectsFromArray:array];
		NSMutableArray * newAnn=[[NSMutableArray alloc] init];
		NSMutableArray * oldAnn=[[NSMutableArray alloc] init];
		for(Annotation * ann in array)
		{
			if(![appoggio containsObject:ann])
			{
				[newAnn addObject:ann];
			}
		}
		[mapView addAnnotations:newAnn];
		for(Annotation * ann in appoggio)
		{
			if(![array containsObject:ann] )
				[oldAnn addObject:ann];
		}
		
		//	NSLog(@"Annotations found %d",[newAnn count]);
		[map addAnnotations:newAnn];
		[map removeAnnotations:oldAnn];
		[appoggio removeObjectsInArray:oldAnn];
		[appoggio addObjectsFromArray:newAnn];
		[newAnn release];
		[oldAnn release];
		//[[((UIView*)[map.subviews objectAtIndex:0]).subviews objectAtIndex:0] bringSubviewToFront:[((UIView*)[((UIView*)[map.subviews objectAtIndex:0]).subviews objectAtIndex:0]).subviews objectAtIndex:1]];
		//[self inspectView:map depth:0 path:@""];
	}
	-(void) updateAnnotationViews;
	{
		[map setRegion:map.region];
	}
	@end

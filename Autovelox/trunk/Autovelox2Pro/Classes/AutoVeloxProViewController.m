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
		
		
	}
	return self;
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(NSString *)stringPad:(int)numPad {
	NSMutableString *pad = [NSMutableString stringWithCapacity:1024];
	for (int i=0; i<numPad; i++) {
		[pad appendString:@"  "];
	}
	return pad; 
}



-(void)inspectView: (UIView *)theView depth:(int)depth path:(NSString *)path {
	
	if (depth==0) {
		NSLog(@"-------------------- <view hierarchy> -------------------");
	}
	
	NSString *pad = [self stringPad:depth];
	
	// print some information about the current view
	//
	NSLog([NSString stringWithFormat:@"%@.description: %@",pad,[theView description]]);
	if ([theView isKindOfClass:[UIImageView class]]) {
		NSLog([NSString stringWithFormat:@"%@.class: UIImageView",pad]);
	} else if ([theView isKindOfClass:[UILabel class]]) {
		NSLog([NSString stringWithFormat:@"%@.class: UILabel",pad]);
		NSLog([NSString stringWithFormat:@"%@.text: ",pad,[(UILabel *)theView text]]);		
	} else if ([theView isKindOfClass:[UIButton class]]) {
		NSLog([NSString stringWithFormat:@"%@.class: UIButton",pad]);
		NSLog([NSString stringWithFormat:@"%@.title: ",pad,[(UIButton *)theView titleForState:UIControlStateNormal]]);		
	}
	NSLog([NSString stringWithFormat:@"%@.frame: %.0f, %.0f, %.0f, %.0f", pad, theView.frame.origin.x, theView.frame.origin.y,
		   theView.frame.size.width, theView.frame.size.height]);
	NSLog([NSString stringWithFormat:@"%@.subviews: %d",pad, [theView.subviews count]]);
	NSLog(@" ");
	
	// gotta love recursion: call this method for all subviews
	//
	for (int i=0; i<[theView.subviews count]; i++) {
		NSString *subPath = [NSString stringWithFormat:@"%@/%d",path,i];
		NSLog([NSString stringWithFormat:@"%@--subview-- %@",pad,subPath]);		
		[self inspectView:[theView.subviews objectAtIndex:i]  depth:depth+1 path:subPath];
	}
	
	if (depth==0) {
		NSLog(@"-------------------- </view hierarchy> -------------------");
	}
	
}

-(void) setAutoView:(AutoVeloxViewController *) vc;
{
	autoView=vc;
}
- (void)gpsUpdate
{
	
	
	NSLog(@"Location updated");

	//[self inspectView:map depth:0 path:@""];
	lastPosition=manager.newLocation.coordinate;
	//[map removeAnnotation:gpsAnnotation];
	//[gpsAnnotation setCoord:manager.newLocation.coordinate];
	//[map addAnnotation:gpsAnnotation];
	
	//if(centered)
	//	[map setCenterCoordinate:manager.newLocation.coordinate animated:YES];
	if(manager.newLocation.course>0)
		angle=manager.newLocation.course;
	
	//[tmp setTransform:CGAffineTransformMakeRotation((angle * 3.14159)/180)];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	map=[[MKMapView alloc] init];
	 map.frame=CGRectMake(0, 170, 320, 270);
	 map.delegate=self;
	CLLocationCoordinate2D pippo;
	pippo.latitude=39.37821;
	pippo.longitude=9.04000;
	map.showsUserLocation=YES;
	
	[map setRegion:MKCoordinateRegionMake(pippo, MKCoordinateSpanMake(1.0, 1.0))];
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
	
	//[map setCenterCoordinate:userPosition];
	//CLLocation * user=[[CLLocation alloc] initWithLatitude:userPosition.latitude longitude:userPosition.longitude];

	NSNumber * latmax=[NSNumber numberWithDouble:( userPosition.latitude + (0.05))];
	NSNumber * latmin=[NSNumber numberWithDouble:( userPosition.latitude - (0.05))];
	NSNumber * lonmax=[NSNumber numberWithDouble:( userPosition.longitude + (0.05))];
	NSNumber * lonmin=[NSNumber numberWithDouble:( userPosition.longitude - (0.05))];
	
	//NSLog(@"searching latmax %@ latmin %@ lonMax %@ lonmin %@",latmax,latmin,lonmax,lonmin );
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
				  
							  @"latitude > %@ && latitude < %@ &&longitude <%@ && longitude > %@", latmin,latmax,lonmax,lonmin];
	
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
			ControlledAutovelox * a=[[ControlledAutovelox alloc] initWithAnnotation:an];
			[controlledAutoveloxs addObject:a];
			[a release];
		}
	}
	[autoView setAutoveloxNumberInTenKm:[controlledAutoveloxs count]];
	[array release];
}

-(CGPoint) latLongToMM:(CLLocationCoordinate2D)coordinate
{
	double intd;
	CGPoint point;
	intd = atan(tan(coordinate.latitude / GR) / KC) + HFPI;
	
	point.y = (int)(log(tan(intd / 2.0)) * RR0F);
	
	
	point.x = (int)(coordinate.longitude * RR0F / GR);
	
	/*-----------------------------------------------*/
	/* Possible numeric errors must be filtered here */
	/*-----------------------------------------------*/
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
	CGPoint mmUserPos=[self latLongToMM:manager.newLocation.coordinate];
	NSMutableArray * autoToRemove=[[NSMutableArray alloc] init];
	//NSLog(@"controlling %d autoveloxs",[controlledAutoveloxs count]);
	for(ControlledAutovelox * a in controlledAutoveloxs)
	{
		BOOL checkAngle=NO;
		float angleDir;
		//if(manager.newLocation.course>0)
		if(YES)
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
		if(currDist>5000)
		{
			[autoToRemove addObject:a];
		}
		else {
			//double dist=[a.loc getDistanceFrom:manager.newLocation];
			if(checkAngle && (abs(manager.newLocation.course -angleDir)<7) && currDist<a.lastDistance)
			{
				a.goodEuristicResults=a.goodEuristicResults+1;
				
			}
			else {
				if(checkAngle)
					a.goodEuristicResults=0;
			}
			a.lastDistance=currDist;
			if(a.lastDistance<1000 && a.goodEuristicResults>0)
			{
				UIAlertView *alert = [[UIAlertView alloc] init];
				[alert setTitle:@"Autovelox"];
				[alert setMessage:a.autovelox.subtitle];
				[alert show];
				[autoView alert:AUTOVELOXFISSO withDistance:a.lastDistance]; 
			}
		}

		
	}
	
	[controlledAutoveloxs removeObjectsInArray:autoToRemove];
	[autoToRemove release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
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
	if([tmp.title isEqualToString:@"Autovelox fisso"]){
			view.image=[UIImage imageNamed:@"autoVeloxFisso40.png"];
	}
	else if([tmp.title isEqualToString:@"Autovelox mobile"])
	{
		view.image=[UIImage imageNamed:@"autoVeloxMobile40.png"];
	}
	else if([tmp.title isEqualToString:@"Tutor Inizio"])
	{
		view.image=[UIImage imageNamed:@"tutorsmall.png"];
	}
	else if([tmp.title isEqualToString:@"Tutor Fine"])
	{
		view.image=[UIImage imageNamed:@"tutorFineSmall.png"];
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
	//if(animated)
	//[overlay addSubview:tmp];
	//CGPoint center=[map convertCoordinate:manager.newLocation.coordinate toPointToView:overlay];
	//tmp.center=center;
	//[[((UIView*)[((UIView*)[map.subviews objectAtIndex:0]).subviews objectAtIndex:0]).subviews objectAtIndex:1] bringSubviewToFront:tmp];
	//tmp.layer.zPosition=1000000;
	
	/*double latmap=map.centerCoordinate.latitude;
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
	//if(controllo >(map.region.span.latitudeDelta/100.0) || controllo2>(map.region.span.longitudeDelta/100.0))
	//{
	//	centered=NO;
	//	centerGps.alpha=1;
	//}
	*/
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
			predicString=[predicString stringByAppendingString:@" &&( (title LIKE[cd] 'Autovelox fisso')"];
		}
		else {
			predicString=[predicString stringByAppendingString:@" || (title LIKE[cd] 'Autovelox fisso')"];
		}

	}
	if(mobili)
	{
		if(firstAnd)
		{
			firstAnd=NO;
			predicString=[predicString stringByAppendingString:@" && ((title LIKE[cd] 'Autovelox mobile')"];
		}
		else {
			predicString=[predicString stringByAppendingString:@" || (title LIKE[cd] 'Autovelox mobile')"];
		}
	}
	if(tutor)
	{
		if(firstAnd)
		{
			firstAnd=NO;
			predicString=[predicString stringByAppendingString:@" && ((title LIKE[cd] 'Tutor*')"];
		}
		else {
			predicString=[predicString stringByAppendingString:@" || (title LIKE[cd] 'Tutor*')"];
		}
	}
	if(ecopass)
	{
		if(firstAnd)
		{
			firstAnd=NO;
			predicString=[predicString stringByAppendingString:@" && ((title LIKE[cd] 'Ecopass')"];
		}
		else {
			predicString=[predicString stringByAppendingString:@" || (title LIKE[cd] 'Ecopass')"];
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

@end

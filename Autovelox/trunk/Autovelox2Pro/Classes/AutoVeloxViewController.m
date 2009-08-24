//
//  AutoVeloxViewController.m
//  AutoVelox
//
//  Created by Alessio Bonu on 24/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "AutoVeloxViewController.h"



#define ANIMOFFS 200
#define VIAOFFS 100
#define LABWIDT 720
#define ANIMDUR 6.0
#define REPANIM 1000000
#define TAGSFONDO 777
#define TAGNDV 111
#define AVTAG 222
#define TAVDTAG 333


@interface AutoVeloxViewController (PrivateMethods)
//- (void) updateSpeed:(int)sp;
-(void)animationSlideOn;
-(void)animationSlideOff;
-(int)averageSpeed:(CLLocation*)newLoc andOldLoc:(const CLLocation*) oldLoc andTime:(float)time;
@end

@implementation AutoVeloxViewController
@synthesize animationStarted,speedNumber;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(id)initWithController:(BottomBarController*)avad withMap:(MKMapView *) m;
{
    if (self = [super init]) 
	{
		map=m;
		animationStarted=NO;
		topAnimationStarted=NO;
		ava=avad;
        // Custom initialization
		/*locationManager=[[CLLocationManager alloc] init];
		locationManager.delegate=self;
		locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
		[locationManager startUpdatingLocation];*/
		CLLocationCoordinate2D firstPoint;
		firstPoint.latitude=0;
		firstPoint.longitude=0;
		
		geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:firstPoint];
		geoCoder.delegate=self;
		ontop=YES;
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:::)];
		gpsManager=[NaviCLLManager defaultCLLManager];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gpsUpdate) name:@"gpsUpdate" object:nil];
	}
    return self;
}
-(void) loadView
{
	up=[[UIView alloc]init];
	up.frame=CGRectMake(0, 0, 320, 170);
	up.backgroundColor=[UIColor blackColor];
	UIImageView *tmp=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back.png"]];
	tmp.tag=TAGSFONDO;
	[up addSubview:tmp];
	[tmp release];
	//up.alpha=0.9;
	self.view=up;
	
	self.view.userInteractionEnabled=YES;
	//tac=[[UIImageView alloc]initWithFrame:CGRectMake(0,20, 135,135)];
	//tac.image=[UIImage imageNamed: @"speed.png"];
	
	UIView *redGreenLight=[[UIView alloc]init];
	UILabel *velocita=[[UILabel alloc] initWithFrame:CGRectMake(7, 80, 170, 40)];
	velocita.text=@"Velocità Rilevata";
	velocita.textColor=[UIColor whiteColor];
	velocita.backgroundColor=[UIColor clearColor];
	[self.view addSubview:velocita];
	[velocita release];
	UILabel *mis=[[UILabel alloc] initWithFrame:CGRectMake(98, 123, 50, 40)];
	mis.text=@"Km/h";
	mis.backgroundColor=[UIColor clearColor];
	mis.textColor=[UIColor whiteColor];
	[self.view addSubview:mis];
	[mis release];
	
	//redGreenLight.backgroundColor=[UIColor greenColor];
	//redGreenLight.frame=CGRectMake(5, 115, 97, 40);
	//redGreenLight.alpha=0.7;
	
	speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 85, 40)];
	speedLabel.textColor=[UIColor whiteColor];
	speedLabel.textAlignment=UITextAlignmentRight;
	UIFont * fo=[UIFont fontWithName:@"Arial" size:50.0];
	speedLabel.font=fo;
	speedLabel.backgroundColor=[UIColor clearColor];
	speedLabel.text=@"000";
	
	
	
	limit=[[UIImageView alloc] init];
	limit.frame=CGRectMake(32, 23, 75, 67);
	limit.image=[UIImage imageNamed:@"arrow.png"];
	[self.view addSubview:limit];
	//[self.view addSubview:tac];
	[self.view addSubview:speedLabel];
	[redGreenLight sendSubviewToBack:tac];
	bar=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slideUp.png"]];
	bar.frame=CGRectMake(0, 155, 320,15);
	[self.view addSubview:bar];
	
	
	nDV = [[NormalDetailsView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];
	nDV.tag=TAGNDV;
	[self.view addSubview:nDV];
	signal=[[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 40, 40)];
	signal.image=[UIImage imageNamed:@"gps_red.png"];
	signal.backgroundColor=[UIColor clearColor];
	[self.view addSubview:signal];
	
}

-(void)animation
{
	ava.strada.textAlignment=UITextAlignmentCenter;
	//strada.frame=CGRectMake(-VIAOFFS, 450, LABWIDT ,20 );
	ava.strada.textAlignment=UITextAlignmentCenter;
	[UIView beginAnimations:@"animation" context:nil]; 
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:REPANIM];
	[UIView setAnimationDuration:ANIMDUR];
	CGRect move=ava.strada.frame;
	move.origin.x-=ANIMOFFS;
	ava.strada.frame=move;
	move.origin.x+=ANIMOFFS;
	ava.strada.frame=move;
	[UIView commitAnimations]; 
	ava.strada.frame=CGRectMake(0, 10, LABWIDT ,20 );
	animationStarted=YES;	
}



- (void)gpsUpdate
{
	float interval;
	if(oldDate)
	{
		interval=[oldDate timeIntervalSinceNow];
		[oldDate release];
	}
	oldDate=[[NSDate date] retain];
	if(geoCoder)
		[geoCoder release];	
	geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:gpsManager.newLocation.coordinate];
	if(gpsManager.newLocation.speed!=speedNumber)
	{
		speedNumber=gpsManager.newLocation.speed;
		
		speedLabel.text =[NSString stringWithFormat:@"%d",gpsManager.newLocation.speed];
		[speedLabel setNeedsDisplay];
	}
	geoCoder.delegate=self;
	[geoCoder start];
	if(gpsManager.newLocation.horizontalAccuracy<50)
	{
		signal.image=[UIImage imageNamed:@"gps_green.png"];
	}
	else if(gpsManager.newLocation.horizontalAccuracy>50 && gpsManager.newLocation.horizontalAccuracy<200)
	{
		signal.image=[UIImage imageNamed:@"gps_yellow.png"];
	}
	else
	{
		signal.image=[UIImage imageNamed:@"gps_red.png"];
	}
	[self averageSpeed:gpsManager.newLocation andOldLoc:(const CLLocation*)gpsManager.oldLocation andTime:interval];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	street = placemark.thoroughfare;
	city = placemark.locality;
	postalCode = placemark.postalCode;
	region = placemark.administrativeArea;
	country = placemark.country;
	//NSLog([NSString stringWithFormat:@"strada: %@\nCodice postale: %@\nCity: %@\nRegion: %@\nCountry: %@\n",street,postalCode,city,region,country ]);
	if(street==nil)
		street=@"";
	else
		street=[street stringByAppendingString:@","];
	if(postalCode==nil)
		postalCode=@"";
	else
		postalCode = [postalCode stringByAppendingString:@","];
	if(city==nil)
		city=@"";
	else
		city = [city stringByAppendingString:@","];
	if(region == nil)
		region=@"";
	else
		region= [region stringByAppendingString:@","];
	if(country == nil)
		country=@"";
	else
		country= [country stringByAppendingString:@"."];
	NSString *newText=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",street,postalCode,city,region,country ];
	
	if(![newText isEqualToString:@", , , ."] &&![newText isEqualToString:@""]&& ![strada.text isEqualToString:newText])
	{
		ava.strada.text=newText;
		ava.strada.frame=CGRectMake(-VIAOFFS, 10, LABWIDT ,20 );
		[ava.strada setNeedsDisplay];
	}
	if(!animationStarted)
		[self animation];
}



- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)animationSlideOff;
{
	[UIView beginAnimations:@"SlideOff" context:nil];
	[UIView setAnimationDuration:0.5];
	//[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:map cache:NO];
	[map setFrame:CGRectMake(0, 77, 320, 405)];
	self.view.frame=CGRectMake(0, -93, 320, 170);	
	//CGPointMake(self.view.center.x, self.view.center.y-135);
	bar.image=[UIImage imageNamed:@"slideDown.png"];	
	nDV.frame=CGRectMake(145, 85, 160, 160);	
	[UIView commitAnimations];
	((UIImageView*)[self.view viewWithTag:TAGSFONDO]).image=nil;
	ontop=NO;
	signal.frame=CGRectMake(98, 105, 40, 40);
}

-(void)animationSlideOn;
{
	[UIView beginAnimations:@"SlideOn" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:map cache:NO];
	self.view.frame=CGRectMake(0, 0, 320, 170);
	bar.image=[UIImage imageNamed:@"slideUp.png"];
	[map setFrame:CGRectMake(0,170, 320, 270)];		
	nDV.frame=CGRectMake(145, 0, 160, 160);
	
	((UIImageView*)[self.view viewWithTag:TAGSFONDO]).image=[UIImage imageNamed:@"back.png"];
	//((UIImageView*)[self.view viewWithTag:TAGSFONDO]).backgroundColor=[UIColor clearColor];
	
	[UIView commitAnimations];

	signal.frame=CGRectMake(0, 12, 40, 40);
	ontop=YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(ontop)
	{
		[self animationSlideOff];		
	}
	else
	{	
		[self animationSlideOn];
	}
	
}

-(void)alertEnd;
{
	nDV = [[NormalDetailsView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];
	nDV.tag=TAGNDV;
	[[self.view viewWithTag:AVTAG] removeFromSuperview];
	[[self.view viewWithTag:AVTAG] release];
	[self.view addSubview:nDV];
}

-(void)alert:(AlertType)type withDistance:(int)distance;
{
	if(type=AlertTypeTutor)
	{
		if(!ontop)
			[self animationSlideOn];
	}
	else if(type=AlertTypeAutoVeloxMobile)
	{
		if(!ontop)
			[self animationSlideOn];
	}
	else if(type=AlertTypeAutoVeloxFisso)
	{
		if(!ontop)
			[self animationSlideOn];
	}
	else if(type=AlertTypeEcopass)
	{
		if(!ontop)
			[self animationSlideOn];
	}
	av=[[AlertView alloc]initWithFrame:CGRectMake(145, 0, 160, 160)];
	av.tag=AVTAG;
	[[self.view viewWithTag:TAGNDV] removeFromSuperview];
	[[self.view viewWithTag:TAGNDV] release];
	limit.image=[UIImage imageNamed:@"divieto.png"];
	[limit setNeedsDisplay];
	[self.view addSubview:av];
}

-(void)alertTutorBegan;
{
	[[self.view viewWithTag:AVTAG] removeFromSuperview];
	[[self.view viewWithTag:AVTAG] release];
	
	tAVD=[[TutorAlertDetailsView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];
	tAVD.tag=TAVDTAG;
	[self.view addSubview:tAVD];
}

-(void)alertTutorEnd;
{
	[[self.view viewWithTag:TAVDTAG] removeFromSuperview];
	[[self.view viewWithTag:TAVDTAG] release];
	nDV = [[NormalDetailsView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];
	nDV.tag=TAGNDV;
	limit.image=[UIImage imageNamed:@"arrow.png"];
	[limit setNeedsDisplay];
	[self.view addSubview:nDV];
}

-(int)averageSpeed:(CLLocation*)newLoc andOldLoc:(const CLLocation*) oldLoc andTime:(float)time;
{
	totalTime+=time;
	float distance;
	if(newLoc.horizontalAccuracy<50)
	{
		distance=[newLoc getDistanceFrom:oldLoc];
	}
	totalSpace+=distance;
	return (int)totalSpace/totalTime;
}

-(void)updateDistance:(int)distance;
{
	av.distance=distance;
	[av setNeedsDisplay];
}

-(void)updateTutorAvgSpeed:(int)avS andDistanceFromTutorEnd:(int)end withLimit:(int)lim;
{
	tAVD.averageSpeed=avS;
	tAVD.velocitaConsentita=lim;
	tAVD.distanzaFineTutor=end;
	[tAVD setNeedsDisplay];
}

 - (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	NSLog(@"stop");
}
- (void)dealloc 
{
	//rilascia tutto
    [super dealloc];
	[up release];
	[speedLabel release];
	[locationManager release];
	[av release];
	[tAVD release];
	[tac release];
	[bottom release];
	[geoCoder release];
	[ava release]; //perchè è passato in retain
}


@end

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

@interface AutoVeloxViewController (PrivateMethods)

- (void)	animationSlideOn;

- (void)	animationSlideOff;

- (int)		averageSpeed:(CLLocation*)newLoc andOldLoc:(const CLLocation*) oldLoc andTime:(float)time;

- (void)	setLimit;

-(void)		updateTutorAvgSpeed:(int)avS andDistanceFromTutorEnd:(int)end withLimit:(int)limit;

@end

@implementation AutoVeloxViewController

@synthesize animationStarted;//,speedNumber,limitTutor,distanceFromTutor;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(id)initWithController:(BottomBarController*)avad withMap:(MKMapView *) m;
{
    if (self = [super init]) 
	{
		map=m;
		animationStarted=NO;
		topAnimationStarted=NO;
		ava=avad;		
		CLLocationCoordinate2D firstPoint;
		firstPoint.latitude=0;
		firstPoint.longitude=0;
		i=1;
		geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:firstPoint];
		geoCoder.delegate=self;
		ontop=YES;
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:::)];
		gpsManager=[NaviCLLManager defaultCLLManager];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gpsUpdate) name:@"gpsUpdate" object:nil];
		sa=[[SoundAlert alloc]init];
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
	speedLabel.text=@"0";
	
	limitSpeed = [[UILabel alloc] initWithFrame:CGRectMake(33, 23, 75, 67)];
	limitSpeed.textAlignment=UITextAlignmentCenter;
	limitSpeed.textColor=[UIColor blackColor];
	limitSpeed.backgroundColor=[UIColor clearColor];
	
	limitSpeed.text=@"";
	[self.view addSubview:limitSpeed];
	
	
	limit=[[UIImageView alloc] init];
	limit.frame=CGRectMake(32, 23, 75, 67);
	limit.image=[UIImage imageNamed:@"arrow.png"];
	
	[self.view addSubview:limit];
	[limitSpeed bringSubviewToFront:limit];
	//[self.view addSubview:tac];
	[self.view addSubview:speedLabel];
	[redGreenLight sendSubviewToBack:tac];
	bar=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slideUp.png"]];
	bar.frame=CGRectMake(0, 155, 320,15);
	[self.view addSubview:bar];
	
	/*NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	int al=[u integerForKey:@"AlertStatus"];
	if(al==0)
	{*/
	nDV = [[NormalDetailsView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];
	[self.view addSubview:nDV];
	/*}
	else if (al==1)
	{ 
		totalTime=[u integerForKey:@"TotalTime"];
		totalSpace=[u integerForKey:@"TotalDistance"];
		old=[u objectForKey:@"OldLocation"];
		i=0;
		[self alertTutorBegan];
	}*/
	
	/*TutorAlertDetailsView *tdv=[[TutorAlertDetailsView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];
	[self.view addSubview:tdv];
	AlertView *a=[[AlertView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];
	[self.view addSubview:a];*/
	
	signal=[[UIImageView alloc] initWithFrame:CGRectMake(0, 21, 40, 20)];
	signal.image=[UIImage imageNamed:@"gps_red.png"];
	signal.backgroundColor=[UIColor clearColor];
	[self.view addSubview:signal];
	[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(geoCode) userInfo:nil repeats:YES];

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

-(void)updateAutoveloxNumber:(int)num;
{
	nDV.numberOfAutovelox=num;
	[nDV update];
}
-(void) geoCode;
{
	if(gpsManager.newLocation)
	{
		geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:gpsManager.newLocation.coordinate];
		geoCoder.delegate=self;
		[geoCoder start];
	}
}
- (void)gpsUpdate
{
	double interval;

	if(!old)
	{
		old=[gpsManager.newLocation retain];
		NSLog(@"created old");
	}
	
	if(gpsManager.newLocation.speed!=speedNumber)
	{
		if(gpsManager.newLocation.speed>0)
			speedNumber=gpsManager.newLocation.speed*3.6;
		
		speedLabel.text =[NSString stringWithFormat:@"%.0f",speedNumber];
		[speedLabel setNeedsDisplay];
	}
	
	if(gpsManager.newLocation.horizontalAccuracy<20)
	{
		signal.image=[UIImage imageNamed:@"gps_green.png"];
	}
	else if(gpsManager.newLocation.horizontalAccuracy>20 && gpsManager.newLocation.horizontalAccuracy<100)
	{
		signal.image=[UIImage imageNamed:@"gps_yellow.png"];
	}
	else
	{
		signal.image=[UIImage imageNamed:@"gps_red.png"];
	}
	if(tutor)
	{
		if(old.coordinate.latitude!=gpsManager.newLocation.coordinate.latitude ||old.coordinate.longitude !=gpsManager.newLocation.coordinate.longitude)
		{
			if(oldDate)
			{
				interval= -1 *[oldDate timeIntervalSinceNow];
				NSLog(@"intervallo : %f",interval);
				avgSp = 3.6* [self averageSpeed:gpsManager.newLocation andOldLoc:old andTime:interval];
				[self updateTutorAvgSpeed:avgSp andDistanceFromTutorEnd:distanceFromTutor withLimit:limitTutor];
				[oldDate release];
			}
			oldDate=[[NSDate date] retain];
			[old release];
			old=[gpsManager.newLocation retain];
		}
		/*NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
		int al=[u integerForKey:@"AlertStatus"];
		if(al && i==0)
		{
			avgSp = [self averageSpeed:gpsManager.newLocation andOldLoc:old  andTime:interval];
			i++;
		}
		else
		{*/
			
		/*	i++;
		}*/
		/*if(avgSp>limitTutor)
			tAVD.alert=YES;*/
	}
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	[geocoder release];
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
	[geocoder release];
}

-(void)resetAvgSpeed;
{
	totalTime=0;
	totalSpace=0;
	if(old)
	{
		[old release];

	}
	old=[gpsManager.newLocation retain];
		/*NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	[u setFloat:totalSpace forKey:@"TotalDistance"];
	[u setFloat:totalTime forKey:@"TotalTime"];
	[u setObject:old forKey:@"OldLocation"];*/
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
	[map setFrame:CGRectMake(0, 77, 320, 362)];
	self.view.frame=CGRectMake(0, -93, 320, 170);	
	//CGPointMake(self.view.center.x, self.view.center.y-135);
	bar.image=[UIImage imageNamed:@"slideDown.png"];	
	nDV.frame=CGRectMake(145, 85, 160, 160);	
	[UIView commitAnimations];
	((UIImageView*)[self.view viewWithTag:TAGSFONDO]).image=nil;
	ontop=NO;
	signal.frame=CGRectMake(98, 113, 40, 20);
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
	signal.frame=CGRectMake(0, 21, 40, 20);
	ontop=YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	if(ontop)
	{
		//[self alert:TUTOR_INIZIO withDistance:800 andText:@"tutor" andLimit:0];
		//[self alertTutorBegan];
		[self animationSlideOff];	
	}
	else
	{	
		[self animationSlideOn];
	}
	
}

-(void)alertEnd;
{
	if(tAVD)
	{
		tAVD.alpha=1;
	}
	nDV = [[NormalDetailsView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];
	limit.image=[UIImage imageNamed:@"arrow.png"];
	limitSpeed.text=@"";
	[av removeFromSuperview];
	av=nil;
	[av release];
	[self.view addSubview:nDV];
	
}

-(void)setAlarmView:(AlertView*)alv;
{
	if(tAVD)
	{
		tAVD.alpha=0;
	}
	[av removeFromSuperview];
	[av release];
	av=nil;
	av=[alv retain];
	[self.view addSubview:av];
}

-(void) doSound;
{
	NSUserDefaults * def=[NSUserDefaults standardUserDefaults];
	int sound=[def integerForKey:@"Sound"];
	if(sound==1)
		[sa playButtonPressed];
}

-(AlertView*)alert:(AUTOVELOXTYPE)type withDistance:(int)distance andText:(NSString*)descrizione andLimit:(int) lim;
{
	if(tAVD)
	{
		tAVD.alpha=0;
	}
	limitTutor=lim;
	[self doSound];
	AlertView * tmp=[[AlertView alloc]initWithFrame:CGRectMake(145, 0, 160, 160)];
	if(type==TUTOR_INIZIO)
	{
		if(!ontop)
			[self animationSlideOn];
		tmp.tipo=@"Tutor";
		limit.image=[UIImage imageNamed:@"cameraTutor.png"];
		[limit setNeedsDisplay];
	}
	else if(type==AUTOVELOXMOBILE)
	{
		if(!ontop)
			[self animationSlideOn];
		tmp.tipo=@"AutoVelox Mobile";
		limit.image=[UIImage imageNamed:@"divieto.png"];
		[limit setNeedsDisplay];
	}
	else if(type==AUTOVELOXFISSO)
	{
		if(!ontop)
			[self animationSlideOn];
		tmp.tipo=@"AutoVelox Fisso";
		limit.image=[UIImage imageNamed:@"divieto.png"];
		[limit setNeedsDisplay];
	}
	tmp.descr=descrizione;
	[self setLimit];
	[nDV removeFromSuperview];
	[nDV release];
	nDV=nil;
	[self setAlarmView:tmp];
	return tmp;
	
}

-(void) setLimit;
{	
	if(limitTutor>0)
	{
		UIFont * fo;
		limit.image = [UIImage imageNamed:@"divieto.png"];
		if(limitTutor<100)
		{
			limitSpeed.frame = CGRectMake(33, 23, 75, 67);
			fo=[UIFont fontWithName:@"Arial" size:35.0];
		}
		else
		{
			limitSpeed.frame = CGRectMake(32, 23, 75, 67);
			fo=[UIFont fontWithName:@"Arial" size:30.0];
		}
		limitSpeed.text=[NSString stringWithFormat:@"%d",limitTutor];
		
	}
	else if(limitTutor<0) //limit not available
	{
		UIFont * fo;
		limit.image = [UIImage imageNamed:@"divieto.png"];
		limitSpeed.frame = CGRectMake(32, 23, 75, 67);
		fo=[UIFont fontWithName:@"Arial" size:30.0];
		limitSpeed.text=@"N.A.";
	}
	else if(limitTutor==0)//tutor management
	{
		limit.image = [UIImage imageNamed:@"cameraTutor.png"];
	}
}

-(void)alertTutorBegan;
{
	tutor=YES;
	/*NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	int al=[u integerForKey:@"AlertStatus"];
	if(!al)
	{
		[u setInteger:1 forKey:@"AlertStatus"];		
	}
	else
	{
	}*/
	if(nDV)
	{
		[nDV removeFromSuperview];
		[nDV release];
		nDV=nil;
	}
	limitTutor=0;
	[self setLimit];	
	[av removeFromSuperview];
	av=nil;
	[av release];	
	tAVD=[[TutorAlertDetailsView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];
	[self.view addSubview:tAVD];
}

-(void)alertTutorEnd;
{
	tutor=NO;
	/*NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	int al=[u integerForKey:@"AlertStatus"];
	if(al)
	{
		[u setInteger:0 forKey:@"AlertStatus"];		
	}*/
	[tAVD removeFromSuperview];
	tAVD=nil;
	[tAVD release];
	nDV = [[NormalDetailsView alloc] initWithFrame:CGRectMake(145, 0, 160, 160)];

	limit.image=[UIImage imageNamed:@"arrow.png"];
	[limit setNeedsDisplay];
	[self.view addSubview:nDV];
}

-(int)averageSpeed:(CLLocation*)newLoc andOldLoc:(const CLLocation*) oldLoc andTime:(float)time;
{
	if(newLoc && oldLoc)
	{
		totalTime += time;
		float distance;
		
		distance = [newLoc getDistanceFrom:oldLoc];
		NSLog(@"distance %f ",distance);
		
		totalSpace += distance;
		NSLog(@"Total space %f ",totalSpace);
		NSLog(@"Total time %f ",totalTime);
		return ((int) (totalSpace/totalTime));
		/*NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
		[u setFloat:totalSpace forKey:@"TotalDistance"];
		[u setFloat:totalTime forKey:@"TotalTime"];
		[u setObject:oldLoc forKey:@"OldLocation"];*/
	}
	else 
		return 0;
}

-(void)updateDistance:(int)distance;
{
	if(av)
	{
		NSLog(@"called set distance %d",distance);
		av.distance=distance;
		[av setNeedsDisplay];
	}
	else{
		NSLog(@"called set distance %d but the view was not allocated",distance);
	}
}

-(void)setAutoveloxNumberInTenKm:(int)num;
{
	if(nDV)
	{
		nDV.numberOfAutovelox=num;
		[nDV setNeedsDisplay];
	}
}

-(void) updateTutorDistance:(int)dist;
{
	tAVD.distanzaFineTutor=dist;
	[tAVD update];
}

-(void)updateTutorAvgSpeed:(int)avS andDistanceFromTutorEnd:(int)end withLimit:(int)lim;
{
	if(tAVD)
	{
		tAVD.averageSpeed=avS;
		//tAVD.velocitaConsentita=lim;
		//tAVD.distanzaFineTutor=end;
		[tAVD update];
	}
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
	if(tAVD)
		[tAVD release];
	if(nDV)
		[nDV release];
	if(av)
		[av release];
	[tac release];
	[bottom release];
	[geoCoder release];
	[ava release]; //perchè è passato in retain
	[sa release];
}


@end

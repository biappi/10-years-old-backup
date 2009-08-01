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


@implementation AutoVeloxViewController
@synthesize animationStarted;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(id)initWithController:(BottomBarController*)avad;
{
    if (self = [super init]) 
	{
		animationStarted=NO;
		topAnimationStarted=NO;
		ava=avad;
        // Custom initialization
		locationManager=[[CLLocationManager alloc] init];
		locationManager.delegate=self;
		locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
		
		[locationManager startUpdatingLocation];
		CLLocationCoordinate2D firstPoint;
		firstPoint.latitude=0;
		firstPoint.longitude=0;
		
		geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:firstPoint];
		geoCoder.delegate=self;
		ontop=YES;
	}
    return self;
}
-(void) loadView
{
	up=[[UIView alloc]init];
	up.frame=CGRectMake(0, 20, 320, 150);
	up.backgroundColor=[UIColor blackColor];
	//up.alpha=0.9;
	self.view=up;
	self.view.userInteractionEnabled=YES;
	tac=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 135,135)];
	tac.image=[UIImage imageNamed: @"tachimeter.png"];
	[self.view addSubview:tac];
	UIView *redGreenLight=[[UIView alloc]init];
	redGreenLight.backgroundColor=[UIColor greenColor];
	redGreenLight.frame=CGRectMake(95, 95, 20, 20);
	[self.view addSubview:redGreenLight];
	[self.view sendSubviewToBack:redGreenLight];
	bar=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slideUp.png"]];
	bar.frame=CGRectMake(0, 135, 320,15);
	[self.view addSubview:bar];
	
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
	animationStarted=YES;
	CGRect move=ava.strada.frame;
	move.origin.x-=ANIMOFFS;
	ava.strada.frame=move;
	move.origin.x+=ANIMOFFS;
	ava.strada.frame=move;
	[UIView commitAnimations]; 
	
	ava.strada.frame=CGRectMake(0, 10, LABWIDT ,20 );
	animationStarted=NO;
	
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	if(geoCoder)
		[geoCoder release];	
	geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
	geoCoder.delegate=self;
	[geoCoder start];
	
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
	NSLog([NSString stringWithFormat:@"strada: %@\nCodice postale: %@\nCity: %@\nRegion: %@\nCountry: %@\n",street,postalCode,city,region,country ]);
	NSString *newText=[NSString stringWithFormat:@"%@, %@, %@, %@, %@.",street,postalCode,city,region,country ];
	if(![newText isEqualToString:@", , , ."] &&![newText isEqualToString:@""]&& ![strada.text isEqualToString:newText])
	{
		ava.strada.text=newText;
		ava.strada.frame=CGRectMake(-VIAOFFS, 10, LABWIDT ,20 );
		[ava.strada setNeedsDisplay];
	}
	if(!animationStarted)
		[self animation];

	
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(ontop)
	{
		[UIView beginAnimations:@"SlideOff" context:nil];
		[UIView setAnimationDuration:0.5];
		self.view.center=CGPointMake(self.view.center.x, self.view.center.y-135);
		bar.image=[UIImage imageNamed:@"slideDown.png"];
		[UIView commitAnimations];
		
		ontop=NO;
	}
	else{
		[UIView beginAnimations:@"SlideOn" context:nil];
		[UIView setAnimationDuration:0.5];
		self.view.center=CGPointMake(self.view.center.x, self.view.center.y+135);
		bar.image=[UIImage imageNamed:@"slideUp.png"];
		[UIView commitAnimations];
		
		ontop=YES;
	
	}
}

- (void)dealloc {
	//rilascia tutto
    [super dealloc];
	[up release];
	[locationManager release];
	[tac release];
	[bottom release];
	[geoCoder release];
	[ava release]; //perchè è passato in retain
}


@end

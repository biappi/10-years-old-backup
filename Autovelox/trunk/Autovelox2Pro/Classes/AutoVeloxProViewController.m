//
//  AutoVeloxProViewController.m
//  AutoVeloxPro
//
//  Created by Pasquale Anatriello on 24/07/09.
//  Copyright Navionics 2009. All rights reserved.
//

#import "AutoVeloxProViewController.h"
#import "Annotation.h"
#import "parseCSV.h"
#import "ControlledAutovelox.h"
#import <CoreLocation/CoreLocation.h>
@implementation AutoVeloxProViewController

@synthesize fissi,mobili,tutor,ecopass;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withManagedContext:(NSManagedObjectContext *) managedOC;	
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
	[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(controlNearAutovelox:) userInfo:nil repeats:YES];
}

- (void)controlNearAutovelox:(NSTimer*)theTimer
{
	
	CLLocationCoordinate2D userPosition=[map userLocation].coordinate;
	
	//[map setCenterCoordinate:userPosition];
	//CLLocation * user=[[CLLocation alloc] initWithLatitude:userPosition.latitude longitude:userPosition.longitude];

	NSNumber * latmax=[NSNumber numberWithDouble:( userPosition.latitude + (0.1))];
	NSNumber * latmin=[NSNumber numberWithDouble:( userPosition.latitude - (0.1))];
	NSNumber * lonmax=[NSNumber numberWithDouble:( userPosition.longitude + (0.1))];
	NSNumber * lonmin=[NSNumber numberWithDouble:( userPosition.longitude - (0.1))];
	
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
	
	[array release];
}

-(void) readAnnotationsFromCSV
{
	NSLog(@"parse begun %@",[NSDate date]);
	NSString * path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/AutoveloxFissi.csv"];
	CSVParser *parser = [CSVParser new];
	[parser setDelimiter:','];
	[parser openFile: path];
	NSMutableArray *csvContent = [parser parseFile];
	int c;
	for (c = 0; c < [csvContent count]; c++) {
		NSArray * content=[csvContent objectAtIndex: c];
		CLLocationCoordinate2D pippo;
		pippo.latitude=[[content objectAtIndex:1] doubleValue];
		pippo.longitude=[[content objectAtIndex:0] doubleValue];
		Annotation *annotation = (Annotation *)[NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:managedObjectC];		
		annotation.latitude=[NSNumber numberWithDouble:pippo.latitude];
		annotation.longitude=[NSNumber numberWithDouble:pippo.longitude];
		annotation.title=@"Autovelox fisso";
		annotation.subtitle=[content objectAtIndex:3];
		//NSLog(@"Parsing %d",c);
	}
	
	path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/AutoveloxMobili.csv"];
	[parser openFile: path];
	csvContent = [parser parseFile];
	for (c = 0; c < [csvContent count]; c++) {
		NSArray * content=[csvContent objectAtIndex: c];
		CLLocationCoordinate2D pippo;
		pippo.latitude=[[content objectAtIndex:1] doubleValue];
		pippo.longitude=[[content objectAtIndex:0] doubleValue];
		Annotation *annotation = (Annotation *)[NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:managedObjectC];
		
		annotation.latitude=[NSNumber numberWithDouble:pippo.latitude];
		annotation.longitude=[NSNumber numberWithDouble:pippo.longitude];
		annotation.title=@"Autovelox mobile";
		annotation.subtitle=[content objectAtIndex:2];	
		//NSLog(@"Parsing %d",c);
	}
	[parser release];

	NSError *error;
	if (![managedObjectC save:&error]) {
		NSLog(@"ERROR ADDING AUTOVELOXS");
	}
		NSLog(@"parse end %@",[NSDate date]);
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	if(![annotation isKindOfClass:[Annotation class]])
		return nil;
	
	
	MKAnnotationView * view=[mapView dequeueReusableAnnotationViewWithIdentifier:@"autovelox"];
	if(!view)
	{
	view=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"autovelox"];
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
	return view;

}

- (void)dealloc {
    [super dealloc];
	if(appoggio)
		[appoggio release];
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	NSLog(@"Did change");
	MKCoordinateRegion region=[mapView region];
	NSLog(@"Region with center %f %f and span %f %f",region.center.latitude,region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta);
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
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Annotation"
								   
											  inManagedObjectContext:managedObjectC];
	
	[request setEntity:entity];
	
	double latspan=region.span.latitudeDelta;
	double lonspan=region.span.longitudeDelta;
	NSLog(@"latspan %f longspan %f",latspan, lonspan);
	NSNumber * latmax=[NSNumber numberWithDouble:( region.center.latitude + (latspan/2))];
	NSNumber * latmin=[NSNumber numberWithDouble:( region.center.latitude - (latspan/2))];
	NSNumber * lonmax=[NSNumber numberWithDouble:( region.center.longitude + (lonspan/2))];
	NSNumber * lonmin=[NSNumber numberWithDouble:( region.center.longitude - (lonspan/2))];
	NSString * predicString=[NSString stringWithFormat:@"latitude > %@ && latitude < %@ &&longitude <%@ && longitude > %@ ", latmin,latmax,lonmax,lonmin];
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
			predicString=[predicString stringByAppendingString:@" && ((title LIKE[cd] 'Tutor')"];
		}
		else {
			predicString=[predicString stringByAppendingString:@" || (title LIKE[cd] 'Tutor')"];
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
	
	NSLog(@"Annotations found %d",[newAnn count]);
	[map addAnnotations:newAnn];
	[map removeAnnotations:oldAnn];
	[appoggio removeObjectsInArray:oldAnn];
	[appoggio addObjectsFromArray:newAnn];
	[newAnn release];
	[oldAnn release];
	
}

@end

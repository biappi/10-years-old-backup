//
//  RootViewController.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 29/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "RootViewController.h"
#import "SetupTableViewController.h"

@implementation RootViewController
@synthesize ld,totaLines;
-(id) initWithContext:(NSManagedObjectContext *)c;
{
	if (self = [super initWithNibName:nil bundle:nil]) {
		managedObjectContext=[c retain];
    }
    return self;
	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	// Override point for customization after app launch    
	ctr=[[AutoVeloxProViewController alloc]  initWithNibName:nil bundle:(NSBundle *)nil withManagedContext:managedObjectContext];	
	//UIView *rootView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	UIView * tmpView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	//[window insertSubview:tmpView atIndex:1];
	[tmpView addSubview:ctr.view];
	BottomBarController *bt=[[BottomBarController alloc]init];
	AutoVeloxViewController *av=[[AutoVeloxViewController alloc] initWithController:[bt retain] withMap:((MKMapView*)ctr.view)];
	[ctr setAutoView:av];
	[tmpView addSubview:av.view];
	UIButton *info=[UIButton buttonWithType:UIButtonTypeInfoDark];
	//[info setImage:[UIImage imageNamed:@"mirinoUnpressedsmall.png"] forState:UIControlStateNormal];
	//[info setImage:[UIImage imageNamed:@"mirinoPressedsmall.png"] forState:UIControlStateHighlighted];
	info.frame=CGRectMake(270, 390, 40, 40);
	[info addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
	[tmpView addSubview:info];
	[tmpView addSubview:bt.view];
	self.view=tmpView;
	self.view.autoresizingMask =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	ld=[[LoadDataViewController alloc] initWithNibName:nil bundle:nil];
	//ld.managedObjectC=self.managedObjectContext;
	[self.view addSubview:ld.view];
	NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	int loadDb=[u integerForKey:@"DBLoaded"];
	if(loadDb)
	{		
		[self performSelector:@selector(read) withObject:nil afterDelay:0.5];
		
		[u setInteger:0 forKey:@"DBLoaded"];

	}
	else
	{
		LoadDataView * ldv=(LoadDataView*) ld.view;
		ldv.line=1;
		ldv.lines=1;
		ldv.animDur=1.0;
		[ldv animat];
		[self performSelector:@selector(readFinished) withObject:nil afterDelay:1.5];	}
		[tmpView release];
	

}

-(void) read
{
	//[self readAnnotationsFromCSV];
	[NSThread detachNewThreadSelector:@selector(readAnnotationsFromCSV) toTarget:self withObject:nil];
	//[self  readAnnotationsFromCSV:(LoadDataView* ) ld.view andManagedObjectCont:managedObjectContext];
}

-(void) readFinished
{
	//UIViewAnimationTransition  trans = UIViewAnimationCurveEaseOut;
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeLD)];
	//[UIView setAnimationTransition: trans forView:self.view  cache: YES];
	[UIView setAnimationDuration:1.0];
	[ld.view setAlpha:0.0];
	[UIView commitAnimations];

}
-(void) removeLD
{
	[ld.view removeFromSuperview];

}

-(void) flip
{
	SetupTableViewController * stv=[[SetupTableViewController alloc] initWithNibName:nil bundle:nil];
	/*[self presentModalViewController:stv animated:YES];
	//[self.view setFrame:CGRectMake(0, 0, 320, 480)];
	[stv release];*/
	
	UIViewAnimationTransition  trans = UIViewAnimationTransitionFlipFromRight;
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationTransition: trans forView:[self.view window]  cache: YES];
	[UIView setAnimationDuration:1.0];
	[self.view addSubview:stv.view];
	[UIView commitAnimations];
}

-(void) readAnnotationsFromCSV
{
	NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
	NSManagedObjectContext * managedO=[managedObjectContext retain];
	LoadDataView * ldv=[ld.view retain];

	NSLog(@"parse begun %@",[NSDate date]);
	NSString * path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/AutoveloxFissi.csv"];
	CSVParser *parserF = [CSVParser new];
	[parserF setDelimiter:','];
	[parserF openFile: path];
	NSMutableArray *csvContentF = [parserF parseFile];
	totaLines+=[csvContentF count];
	path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/AutoveloxMobili.csv"];
	CSVParser *parserM = [CSVParser new];
	[parserM setDelimiter:','];
	[parserM openFile: path];
	NSMutableArray *csvContentM = [parserM parseFile];
	totaLines+=[csvContentM count];
	((LoadDataView*)(ldv)).line=1;
	//uguale perr tutor e ecopass
	
	
	ldv.lines=totaLines;
	
	int c;
	int iter=0;
	NSLog(@"Fissi: %d",[csvContentF count]);
	for (c = 0; c < [csvContentF count]; c++) 
	{
		
		NSArray * content=[csvContentF objectAtIndex: c];
		CLLocationCoordinate2D pippo;
		pippo.latitude=[[content objectAtIndex:1] doubleValue];
		pippo.longitude=[[content objectAtIndex:0] doubleValue];
		Annotation *annotation = (Annotation *)[NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:managedO];		
		annotation.latitude=[NSNumber numberWithDouble:pippo.latitude];
		annotation.longitude=[NSNumber numberWithDouble:pippo.longitude];
		annotation.title=@"Autovelox fisso";
		annotation.subtitle=[content objectAtIndex:3];
		//NSLog(@"Parsing %d",c);
		if(c%(totaLines/20)==0)
		{
			((LoadDataView*)(ldv)).line=c;
			[ldv performSelectorOnMainThread:@selector(animat) withObject:nil waitUntilDone:YES];

		}
	}
	iter+=[csvContentF count];
	
	NSLog(@"Mobili: %d",[csvContentM count]);
	for (c = 0; c < [csvContentM count]; c++) 
	{
		
		NSArray * content=[csvContentM objectAtIndex: c];
		CLLocationCoordinate2D pippo;
		pippo.latitude=[[content objectAtIndex:1] doubleValue];
		pippo.longitude=[[content objectAtIndex:0] doubleValue];
		Annotation *annotation = (Annotation *)[NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:managedO];
		
		annotation.latitude=[NSNumber numberWithDouble:pippo.latitude];
		annotation.longitude=[NSNumber numberWithDouble:pippo.longitude];
		annotation.title=@"Autovelox mobile";
		annotation.subtitle=[content objectAtIndex:2];	
		//NSLog(@"Parsing %d",c);
		if((c+iter)%(totaLines/20)==0)
		{
			ldv.line=c+iter;
			[ldv performSelectorOnMainThread:@selector(animat) withObject:nil waitUntilDone:YES];
		}
	}
	/*
	 //Ecopass
	 path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Ecopass.csv"];
	 [parser openFile: path];
	 csvContent = [parser parseFile];
	 NSLog(@"Ecopass: %d",[csvContent count]);
	 for (c = 0; c < [csvContent count]; c++) 
	 {
	 
	 NSArray * content=[csvContent objectAtIndex: c];
	 CLLocationCoordinate2D pippo;
	 pippo.latitude=[[content objectAtIndex:1] doubleValue];
	 pippo.longitude=[[content objectAtIndex:0] doubleValue];
	 Annotation *annotation = (Annotation *)[NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:managedObjectC];
	 
	 annotation.latitude=[NSNumber numberWithDouble:pippo.latitude];
	 annotation.longitude=[NSNumber numberWithDouble:pippo.longitude];
	 annotation.title=@"Ecopass";
	 annotation.subtitle=[content objectAtIndex:2];	
	 //NSLog(@"Parsing %d",c);
	 }
	 */
	 //Tutor
	 path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Sicve_Inizio.csv"];
	 [parserF openFile: path];
	 csvContentF = [parserF parseFile];
	 NSLog(@"tutor: %d",[csvContentF count]);
	 
	 for (c = 0; c < [csvContentF count]; c++) 
	 {
	 NSArray * content=[csvContentF objectAtIndex: c];
	 CLLocationCoordinate2D pippo;
	 pippo.latitude=[[content objectAtIndex:1] doubleValue];
	 pippo.longitude=[[content objectAtIndex:0] doubleValue];
	 Annotation *annotation = (Annotation *)[NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:managedO];
	 
	 annotation.latitude=[NSNumber numberWithDouble:pippo.latitude];
	 annotation.longitude=[NSNumber numberWithDouble:pippo.longitude];
	 annotation.title=@"Tutor Inizio";
	 annotation.subtitle=[content objectAtIndex:3];	
		 
			 //NSLog(@"Parsing %d",c);
	 }
	path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Sicve_Fine.csv"];
	[parserF openFile: path];
	csvContentF = [parserF parseFile];
	NSLog(@"tutor: %d",[csvContentF count]);
	
	for (c = 0; c < [csvContentF count]; c++) 
	{
		NSArray * content=[csvContentF objectAtIndex: c];
		CLLocationCoordinate2D pippo;
		pippo.latitude=[[content objectAtIndex:1] doubleValue];
		pippo.longitude=[[content objectAtIndex:0] doubleValue];
		Annotation *annotation = (Annotation *)[NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:managedO];
		
		annotation.latitude=[NSNumber numberWithDouble:pippo.latitude];
		annotation.longitude=[NSNumber numberWithDouble:pippo.longitude];
		annotation.title=@"Tutor Fine";
		annotation.subtitle=[content objectAtIndex:3];	
	}		
	 
	[parserM release];
	[parserF release];
	
//NSError *error;
//	if (![managedO save:&error]) {
//		NSLog(@"ERROR ADDING AUTOVELOXS");
//	}
	[managedO performSelectorOnMainThread:@selector(save:) withObject:nil waitUntilDone:YES];
	NSLog(@"parse end %@",[NSDate date]);
	[self performSelectorOnMainThread:@selector(readFinished) withObject:nil waitUntilDone:NO];
	[managedO release];
	[ldv release];
	[pool release];
}

- (void)dealloc {
    [super dealloc];
}


@end

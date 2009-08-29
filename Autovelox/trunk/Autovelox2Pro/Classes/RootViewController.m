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

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

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
		[self performSelector:@selector(readFinished) withObject:nil afterDelay:1.5];	}
		[tmpView release];
	

}
-(void) read
{
	[AutoVeloxProViewController readAnnotationsFromCSV:self andManagedObjectCont:managedObjectContext];
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
	
	//[ld.view removeFromSuperview];
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



- (void)dealloc {
    [super dealloc];
}


@end

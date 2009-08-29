//
//  LoadDataViewController.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 28/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "LoadDataViewController.h"


@implementation LoadDataViewController
@synthesize managedObjectC;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		ldv=[[LoadDataView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
		
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view=ldv;
	[ldv release];

}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//[self performSelector:@selector(readCSV) withObject:nil afterDelay:0.2];
	//[self.view removeFromSuperview];
	
}

/*-(void) readCSV
{
	NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	int loadDb=[u integerForKey:@"DBLoaded"];
	if(loadDb)
	{		
	[AutoVeloxProViewController readAnnotationsFromCSV:(LoadDataView*)self.view andManagedObjectCont:managedObjectC];
	}
	else
		[self readFinished];
}*/

/*-(void) readFinished;
{
	[self presentModalViewController:ap animated:YES];
}*/
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


- (void)dealloc {
    [super dealloc];
}


@end

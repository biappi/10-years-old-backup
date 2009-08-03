//
//  BottomBarController.m
//  AutoVelox
//
//  Created by Alessio Bonu on 26/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "BottomBarController.h"

#define ANIMOFFS 200
#define VIAOFFS 100
#define LABWIDT 720
#define ANIMDUR 6.0

@implementation BottomBarController

@synthesize strada;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        // Custom initialization
		strada=[[UILabel alloc]initWithFrame:CGRectMake(-VIAOFFS, 10,LABWIDT,20 )];
		strada.textColor=[UIColor whiteColor];
		strada.backgroundColor=[UIColor clearColor];
		strada.textAlignment=UITextAlignmentCenter;
		
		//strada.adjustsFontSizeToFitWidth=YES

		
	
	}
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	bottom = [[UIView alloc]init];
	bottom.frame=CGRectMake(0, 440,320, 40);
	self.view=bottom;
	[self.view addSubview:strada];
	bottom.backgroundColor=[UIColor blackColor];
	bottom.alpha=0.8;
	[bottom release];
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


- (void)dealloc {
    [super dealloc];
	[strada release];
	[bottom release];

}


@end

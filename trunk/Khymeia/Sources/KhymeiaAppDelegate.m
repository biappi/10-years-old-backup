//
//  KhymeiaAppDelegate.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright Università di Pisa 2009. All rights reserved.
//

#import "KhymeiaAppDelegate.h"
#import "InterfaceController.h"

@implementation KhymeiaAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application;
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window makeKeyAndVisible];
	
	vc = [[InterfaceController alloc] init];
	[window addSubview:vc.view];
	
	InterfaceController * ic = (InterfaceController *) vc;
	[ic drawCard:nil];
	[ic drawCard:nil];
	[ic drawCard:nil];
}

- (void)dealloc;
{
	[vc release];
    [window release];
    [super dealloc];
}

@end

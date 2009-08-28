//
//  Autovelox2ProAppDelegate.m
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 26/07/09.
//  Copyright Navionics 2009. All rights reserved.
//

#import "Autovelox2ProAppDelegate.h"
#import "AutoVeloxProViewController.h"
#import "AutoVeloxViewController.h"
#import "BottomBarController.h"
#import "SetupTableViewController.h"

#define LABWIDT 720

@implementation Autovelox2ProAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

+ (void)initialize;
{
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated: NO];	
	
	NSMutableDictionary * defaults;
	
	defaults = [NSMutableDictionary dictionary];
	[defaults setObject:[NSNumber numberWithInt:1]    forKey:@"DBLoaded"   ];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"Fissi"];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"Mobili"];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"Tutor"];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"Ecopass"];
 	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}	

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	AutoVeloxProViewController * ctr=[[AutoVeloxProViewController alloc]  initWithNibName:nil bundle:(NSBundle *)nil withManagedContext:self.managedObjectContext];	
	
	UIView * tmpView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[window insertSubview:tmpView atIndex:1];
	[tmpView addSubview:ctr.view];
	BottomBarController *bt=[[BottomBarController alloc]init];
	AutoVeloxViewController *av=[[AutoVeloxViewController alloc] initWithController:[bt retain] withMap:ctr.view];
	
	SetupTableViewController *stvc=[[SetupTableViewController alloc] initWithNibName:nil bundle:nil andController:self andAutoController:ctr];
	[window insertSubview:stvc.view atIndex:0];
	//[stvc.view setHidden:YES]; 
	[tmpView addSubview:av.view];
	UIButton *info=[UIButton buttonWithType:UIButtonTypeInfoDark];
	//[info setImage:[UIImage imageNamed:@"mirinoUnpressedsmall.png"] forState:UIControlStateNormal];
	//[info setImage:[UIImage imageNamed:@"mirinoPressedsmall.png"] forState:UIControlStateHighlighted];
	info.frame=CGRectMake(270, 390, 40, 40);
	[info addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
	[tmpView addSubview:info];
	[tmpView addSubview:bt.view];
	[window makeKeyAndVisible];
	 NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	int loadDb=[u integerForKey:@"DBLoaded"];
	if(loadDb)
	{
		[ctr readAnnotationsFromCSV];
		[u setInteger:0 forKey:@"DBLoaded"];
	}
	[ctr.view bringSubviewToFront:av.view];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}


#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) 
	{
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Autovelox2Pro.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(void)flip;
{
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	[UIView beginAnimations:nil context:context]; 
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
	[UIView setAnimationDuration:1.0]; 
	// Animations 
	[window exchangeSubviewAtIndex:1 withSubviewAtIndex:0]; 
	// Commit Animation Block 
	[UIView commitAnimations]; 
	
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[super dealloc];
}


@end


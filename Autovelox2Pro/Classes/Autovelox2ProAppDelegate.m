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
#import "RootViewController.h"
#define LABWIDT 720
#define NUMBEROFAUTOVELOX 12500; //DA SETTARE QUANDO SI AGGIORNA IL DB

@implementation Autovelox2ProAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

+ (void)initialize;
{
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated: NO];		
	NSMutableDictionary * defaults;	
	defaults = [NSMutableDictionary dictionary];
	[defaults setObject:[NSNumber numberWithInt:0] forKey:@"DBLoaded"   ];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"Fissi"];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"Mobili"];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"Tutor"];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"Ecopass"];
 	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}	


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	
   
	//SetupTableViewController *stvc=[[SetupTableViewController alloc] initWithNibName:nil bundle:nil andController:self andAutoController:ctr];
	//[window insertSubview:stvc.view atIndex:0];
	//[stvc.view setHidden:YES]; 
	//window=nil;
	//window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	window.frame=[[UIScreen mainScreen] bounds];
	[window makeKeyAndVisible];
	RootViewController * root=[[RootViewController alloc] initWithContext:self.managedObjectContext];
	//ld.ap=root;
	[window addSubview:root.view];
	//disable the stand by
	[UIApplication sharedApplication].idleTimerDisabled = TRUE;
	/*		ldvC=[[LoadDataViewController alloc] initWithNibName:nil bundle:nil];
		 ldvC.managedObjectC=managedObjectContext;
		 ldvC.view.backgroundColor=[UIColor clearColor];
		 [window addSubview:ldvC.view];
		 [u setInteger:0 forKey:@"DBLoaded"];
		 [AutoVeloxProViewController readAnnotationsFromCSV:nil andManagedObjectCont:self.managedObjectContext];
	}*/
	
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
	NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	int loadDb=0;
	NSURL *storeUrl = [NSURL fileURLWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"Autovelox2Pro.sqlite"]];
	if(loadDb!=0)
	{
		if(	[[NSFileManager defaultManager] fileExistsAtPath:[storeUrl path]])
		{
			[[NSFileManager defaultManager] removeItemAtPath:storeUrl.path error:nil];
		}
		
	}
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

/*-(void)flip;
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
*/

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [ctr release];
	[window release];
	[super dealloc];
}


@end


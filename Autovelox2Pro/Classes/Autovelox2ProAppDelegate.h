//
//  Autovelox2ProAppDelegate.h
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 26/07/09.
//  Copyright Navionics 2009. All rights reserved.
//
#import "AutoVeloxProViewController.h"
#import "LoadDataViewController.h"

@interface Autovelox2ProAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    UIWindow *window;
	AutoVeloxProViewController * ctr;
	LoadDataViewController *ldvC;
}

- (IBAction)saveAction:sender;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) UIWindow *window;

@end


//
//  RootViewController.h
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 29/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AutoVeloxProViewController.h"
#import "LoadDataViewController.h"
#import <CoreData/CoreData.h>
#import "Annotation.h"
#import "parseCSV.h"
@interface RootViewController : UIViewController {

	AutoVeloxProViewController * ctr;
	NSManagedObjectContext *managedObjectContext;
	LoadDataViewController * ld;
	int totaLines;
}
//+(void) readAnnotationsFromCSV:(LoadDataView *)ldv andManagedObjectCont:(NSManagedObjectContext *) managedO andRootView:(RootViewController*) rv;
-(void) readAnnotationsFromCSV;
-(id) initWithContext:(NSManagedObjectContext *)c;

@property (nonatomic,retain)LoadDataViewController * ld;
@property (nonatomic,assign)int totaLines;

@end

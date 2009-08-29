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
@interface RootViewController : UIViewController {

	AutoVeloxProViewController * ctr;
	NSManagedObjectContext *managedObjectContext;
	LoadDataViewController * ld;
}
-(id) initWithContext:(NSManagedObjectContext *)c;

@end

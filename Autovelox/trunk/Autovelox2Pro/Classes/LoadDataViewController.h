//
//  LoadDataViewController.h
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 28/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadDataView.h"
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>


@interface LoadDataViewController : UIViewController {
	
	LoadDataView *ldv;
	NSManagedObjectContext * managedObjectC;
	//RootViewController * ap;
}

@property (nonatomic,retain) NSManagedObjectContext * managedObjectC;
//@property (nonatomic,retain) RootViewController * ap;
@end

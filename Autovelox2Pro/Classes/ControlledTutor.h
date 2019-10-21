//
//  ControlledTutor.h
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 08/09/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annotation.h"
#import "ControlledAutovelox.h"

@interface ControlledTutor : ControlledAutovelox {
	
	Annotation * next;
	Annotation * previous;
	double lastDistFromNext;
	double lastDistFromPrev;
	double lastFarDistance;
}

@property (nonatomic, retain) Annotation * next;
@property (nonatomic, retain) Annotation * previous;
@property (nonatomic, assign) double lastDistFromNext;
@property (nonatomic, assign) double lastDistFromPrev;
@property (nonatomic, assign) double lastFarDistance;


@end

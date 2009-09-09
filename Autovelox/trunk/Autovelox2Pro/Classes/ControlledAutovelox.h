//
//  ControlledAutovelox.h
//  Autovelox2Pro
//
//  Created by Pasquale Anatriello on 29/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Annotation.h"

@interface ControlledAutovelox : NSObject {

	NSString * roadName;
	double lastDistance;
	int goodEuristicResults;
	Annotation * autovelox;
	CLLocation * loc;
	UIView * alarmView;
}
@property(nonatomic,assign) Annotation * autovelox;
@property(readonly) CLLocation * loc;
@property(nonatomic, assign) double lastDistance;
@property(nonatomic, assign) int goodEuristicResults;
@property(nonatomic, retain) UIView * alarmView;
-(id) initWithAnnotation:(Annotation*)an;
@end

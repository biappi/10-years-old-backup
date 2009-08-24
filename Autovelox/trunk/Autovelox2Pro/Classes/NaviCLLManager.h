//
//  NaviCLLManager.h
//  iGeoMobileSDK
//
//  Created by Pasquale Anatriello on 16/03/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol NaviGPSProtocol

- (void)gpsBecomeActive;
- (void)gpsBecomeInactive;
- (void)gpsUpdate;
@end

@interface NaviCLLManager : NSObject <CLLocationManagerDelegate>{

	CLLocationManager * lman;
	CLLocation * newLocation;
	CLLocation * oldLocation;
	NSError * gpsError;
	bool	gpsOn;
}

+ (NaviCLLManager *) defaultCLLManager;
- (void) startGp;
- (void) stopGps;

@property (nonatomic, retain) CLLocation * newLocation;
@property (nonatomic, retain) CLLocation * oldLocation;
@property (nonatomic, retain) NSError * gpsError;
@property (nonatomic, readonly) bool gpsOn;
@end

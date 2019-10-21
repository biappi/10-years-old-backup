//
//  TutorAlertDetailsView.h
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TutorAlertDetailsView : UIView 
{
	UILabel *avSpeed;
	UILabel *numberSpeed;
	UILabel *distFin;
	UILabel *dis;
	UILabel *unitDis;
	UILabel *unit;
	int averageSpeed;
	int distanzaFineTutor;
	int velocitaConsentita;
	BOOL alert;
}
-(void) update;
@property (nonatomic,assign) int averageSpeed;
@property (nonatomic,assign) int distanzaFineTutor;
@property (nonatomic,assign) int velocitaConsentita;
@property (nonatomic,assign) BOOL alert;

@end

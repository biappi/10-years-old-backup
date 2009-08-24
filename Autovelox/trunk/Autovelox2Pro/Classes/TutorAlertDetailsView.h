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
	int averageSpeed;
	int distanzaFineTutor;
	int velocitaConsentita;
}

@property (nonatomic,assign) int averageSpeed;
@property (nonatomic,assign) int distanzaFineTutor;
@property (nonatomic,assign) int velocitaConsentita;

@end

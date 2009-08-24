//
//  TutorAlertDetailsView.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "TutorAlertDetailsView.h"


@implementation TutorAlertDetailsView

@synthesize distanzaFineTutor,averageSpeed,velocitaConsentita;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) 
	{
        // Initialization code
		self.backgroundColor=[UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	UILabel *avSpeed=[[UILabel alloc] initWithFrame:CGRectMake(5, 15, 185, 65)];
	avSpeed.text=[NSString stringWithFormat:@"Velocità media: %d Km/h",averageSpeed];
	avSpeed.textColor=[UIColor redColor];
	avSpeed.backgroundColor=[UIColor clearColor];
	[self addSubview:avSpeed];
	UILabel *distFin=[[UILabel alloc] initWithFrame:CGRectMake(5, 45, 185, 65)];
	
	if(distanzaFineTutor>=1000)
		distFin.text=[NSString stringWithFormat:@"Distanza fine tutor: %f km",((float)distanzaFineTutor/1000)];
	else
		distFin.text=[NSString stringWithFormat:@"Distanza fine tutor: %d m",distanzaFineTutor];
	distFin.textColor=[UIColor redColor];
	distFin.backgroundColor=[UIColor clearColor];
	[self addSubview:distFin];
	
}


- (void)dealloc {
    [super dealloc];
}


@end

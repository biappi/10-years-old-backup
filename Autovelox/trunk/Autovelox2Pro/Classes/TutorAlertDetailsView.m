//
//  TutorAlertDetailsView.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "TutorAlertDetailsView.h"


@implementation TutorAlertDetailsView

@synthesize distanzaFineTutor,averageSpeed,velocitaConsentita,alert;

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
	UILabel *avSpeed=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 185, 65)];
	avSpeed.text=[NSString stringWithFormat:@"Velocità media:"];
	avSpeed.textAlignment=UITextAlignmentLeft;
	avSpeed.textColor=[UIColor whiteColor];
	avSpeed.backgroundColor=[UIColor clearColor];
	UILabel *numberSpeed=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 90, 45)];
	numberSpeed.text=[NSString stringWithFormat:@"%d",averageSpeed];
	UIFont * fo=[UIFont fontWithName:@"Arial" size:50.0];
	numberSpeed.font=fo;
	numberSpeed.textAlignment=UITextAlignmentRight;
	if(!alert)
		numberSpeed.textColor=[UIColor whiteColor];
	else
		numberSpeed.textColor=[UIColor redColor];
	numberSpeed.backgroundColor=[UIColor clearColor];
	UILabel *unit=[[UILabel alloc] initWithFrame:CGRectMake(95, 60, 50, 45)];
	unit.backgroundColor=[UIColor clearColor];
	unit.textAlignment=UITextAlignmentRight;
	unit.textColor=[UIColor whiteColor];
	unit.text=@"Km/h";
	[self addSubview:avSpeed];
	[avSpeed release];
	[self addSubview:numberSpeed];
	[numberSpeed release];
	[self addSubview:unit];
	[unit release];
	
	UILabel *distFin=[[UILabel alloc] initWithFrame:CGRectMake(5, 68, 185, 65)];
	distFin.text=[NSString stringWithFormat:@"Distanza fine tutor:"];
	distFin.textColor=[UIColor whiteColor];
	distFin.backgroundColor=[UIColor clearColor];
	[self addSubview:distFin];
	[distFin release];
	
	UILabel *dis = [[UILabel alloc] initWithFrame:CGRectMake(10, 112, 90, 45)];
	if(distanzaFineTutor>=1000)
		if(distanzaFineTutor>=10000)
			dis.text=[NSString stringWithFormat:@"%.0d",distanzaFineTutor/1000];
		else 
			dis.text=[NSString stringWithFormat:@"%1.1f",(float)distanzaFineTutor/1000];
	else
		dis.text=[NSString stringWithFormat:@"%d",distanzaFineTutor];
	dis.textColor=[UIColor whiteColor];
	dis.font=fo;
	dis.backgroundColor=[UIColor clearColor];
	dis.textAlignment=UITextAlignmentRight;
	[self addSubview:dis];
	[dis release];
	
	UILabel *unitDis=[[UILabel alloc] initWithFrame:CGRectMake(105, 122, 50, 45)];
	if(distanzaFineTutor>=1000)
		if(distanzaFineTutor>=10000)
			unitDis.text=[NSString stringWithFormat:@"Km",distanzaFineTutor/1000];
		else 
			unitDis.text=[NSString stringWithFormat:@"Km",(float)distanzaFineTutor/1000];
		else
			unitDis.text=[NSString stringWithFormat:@"m",distanzaFineTutor];
	unitDis.textColor=[UIColor whiteColor];
	unitDis.backgroundColor=[UIColor clearColor];
	unitDis.textAlignment=UITextAlignmentLeft;
	[self addSubview:unitDis];
	[unitDis release];

	//rilascia
}


- (void)dealloc {
    [super dealloc];
}


@end

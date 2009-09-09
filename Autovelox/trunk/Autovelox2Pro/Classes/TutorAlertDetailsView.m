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
		avSpeed=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 185, 65)];
        numberSpeed=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 90, 45)];
		distFin=[[UILabel alloc] initWithFrame:CGRectMake(5, 68, 185, 65)];
		dis = [[UILabel alloc] initWithFrame:CGRectMake(10, 112, 90, 45)];
		unitDis=[[UILabel alloc] initWithFrame:CGRectMake(105, 122, 50, 45)];
		unit=[[UILabel alloc] initWithFrame:CGRectMake(95, 60, 50, 45)];

        // Initialization code
		self.backgroundColor=[UIColor clearColor];
		avSpeed.text=[NSString stringWithFormat:@"Velocità media:"];
		avSpeed.textAlignment=UITextAlignmentLeft;
		avSpeed.textColor=[UIColor whiteColor];
		avSpeed.backgroundColor=[UIColor clearColor];
		
		
		UIFont * fo=[UIFont fontWithName:@"Arial" size:50.0];
		numberSpeed.font=fo;
		numberSpeed.textAlignment=UITextAlignmentRight;
		
		numberSpeed.backgroundColor=[UIColor clearColor];
		
		unit.backgroundColor=[UIColor clearColor];
		unit.textAlignment=UITextAlignmentRight;
		unit.textColor=[UIColor whiteColor];
		unit.text=@"Km/h";
		[self addSubview:avSpeed];
		
		[self addSubview:numberSpeed];
		
		[self addSubview:unit];
		
		
		
		distFin.text=[NSString stringWithFormat:@"Distanza controllo:"];
		distFin.textColor=[UIColor whiteColor];
		distFin.backgroundColor=[UIColor clearColor];
		[self addSubview:distFin];
		
		
		
		dis.textColor=[UIColor whiteColor];
		dis.font=fo;
		dis.backgroundColor=[UIColor clearColor];
		dis.textAlignment=UITextAlignmentRight;
		[self addSubview:dis];
		
		
		unitDis.textColor=[UIColor whiteColor];
		unitDis.backgroundColor=[UIColor clearColor];
		unitDis.textAlignment=UITextAlignmentLeft;
		[self addSubview:unitDis];
    }
    return self;
}


	
- (void)drawRect:(CGRect)rect 
{
	
	numberSpeed.text=[NSString stringWithFormat:@"%d",averageSpeed];
	if(!alert)
		numberSpeed.textColor=[UIColor whiteColor];
	else
		numberSpeed.textColor=[UIColor redColor];
	
	if(distanzaFineTutor>=1000)
		if(distanzaFineTutor>=10000)
			dis.text=[NSString stringWithFormat:@"%.0d",distanzaFineTutor/1000];
		else 
			dis.text=[NSString stringWithFormat:@"%1.1f",(float)distanzaFineTutor/1000];
		else
			dis.text=[NSString stringWithFormat:@"%d",distanzaFineTutor];
	if(distanzaFineTutor>=1000)
		if(distanzaFineTutor>=10000)
			unitDis.text=[NSString stringWithFormat:@"Km",distanzaFineTutor/1000];
		else 
			unitDis.text=[NSString stringWithFormat:@"Km",(float)distanzaFineTutor/1000];
		else
			unitDis.text=[NSString stringWithFormat:@"m",distanzaFineTutor];
	
	

	//rilascia
}


- (void)dealloc {
	[avSpeed release];
	[numberSpeed release];
	[distFin release];
	[dis release];
	[unitDis release];
	[unit release];
    [super dealloc];
}


@end

//
//  AlertView.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "AlertView.h"


@implementation AlertView

@synthesize distance;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor=[UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    // Drawing code	
	UILabel *dist=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 185, 65)];
	dist.text=[NSString stringWithFormat:@"Distanza rimanente:"];
	dist.textColor=[UIColor whiteColor];
	dist.backgroundColor=[UIColor clearColor];
	[self addSubview:dist];
	[dist release];
	UILabel *distN=[[UILabel alloc] initWithFrame:CGRectMake(35, 38,70, 65)];
	UIFont * fo = [UIFont fontWithName:@"Arial" size:50.0];
	distN.font = fo;
	if(distance>=1000)
	{
		float d = distance/1000;
		distN.text=[NSString stringWithFormat:@"%f",d];
	}
	else
		distN.text=[NSString stringWithFormat:@"%d",distance];
	distN.textAlignment=UITextAlignmentRight;
	distN.textColor=[UIColor redColor];
	distN.backgroundColor=[UIColor clearColor];
	[self addSubview:distN];
	[distN release];
	
	UILabel *uniN=[[UILabel alloc] initWithFrame:CGRectMake(105, 48,70, 65)];
	if(distance>=1000)
	{
		float d = distance/1000;
		uniN.text=[NSString stringWithFormat:@"Km",d];
	}
	else
		uniN.text=[NSString stringWithFormat:@"m",distance];
	uniN.textAlignment=UITextAlignmentLeft;
	uniN.textColor=[UIColor whiteColor];
	uniN.backgroundColor=[UIColor clearColor];
	[self addSubview:uniN];
	[uniN release];
	
}


- (void)dealloc {
    [super dealloc];
}


@end

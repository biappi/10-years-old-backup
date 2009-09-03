//
//  AlertView.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "AlertView.h"


@implementation AlertView

@synthesize distance,tipo,descr;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor=[UIColor clearColor];
		dist = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 185, 65)];
		uniN = [[UILabel alloc] initWithFrame:CGRectMake(105, 48,70, 65)];
		distN= [[UILabel alloc] initWithFrame:CGRectMake(35, 38,70, 65)];
		type = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 185, 65)];
		description=[[UILabel alloc]initWithFrame:CGRectMake(5, 93, 185, 65)];
    }
    return self;
}

- (void)layoutSubviews
{
	dist.text=[NSString stringWithFormat:@"Distanza rimanente:"];
	dist.textColor=[UIColor whiteColor];
	dist.backgroundColor=[UIColor clearColor];
	[self addSubview:dist];
	
	UIFont * fo = [UIFont fontWithName:@"Arial" size:50.0];
	distN.font = fo;
	
	distN.textAlignment=UITextAlignmentRight;
	distN.textColor=[UIColor redColor];
	distN.backgroundColor=[UIColor clearColor];
	[self addSubview:distN];
	
	
	fo = [UIFont fontWithName:@"Arial" size:20.0];
	type.font = fo;
	type.text=tipo;
	type.textAlignment=UITextAlignmentCenter;
	type.textColor=[UIColor redColor];
	type.backgroundColor=[UIColor clearColor];
	[self addSubview:type];
	
	description.text=descr;
	description.textAlignment=UITextAlignmentCenter;
	description.textColor=[UIColor whiteColor];
	description.numberOfLines=2;
	description.backgroundColor=[UIColor clearColor];
	[self addSubview:description];
	
	
	uniN.textAlignment=UITextAlignmentLeft;
	uniN.textColor=[UIColor whiteColor];
	uniN.backgroundColor=[UIColor clearColor];
	[self addSubview:uniN];
}


- (void)drawRect:(CGRect)rect 
{
    // Drawing code	
	if(distance>=1000)
	{
		float d = distance/1000;
		distN.text=[NSString stringWithFormat:@"%f",d];
	}
	else
		distN.text=[NSString stringWithFormat:@"%d",distance];

	if(distance>=1000)
	{
		float d = distance/1000;
		uniN.text=[NSString stringWithFormat:@"Km",d];
	}
	else
		uniN.text=[NSString stringWithFormat:@"m",distance];	
}


- (void)dealloc {
    [super dealloc];
	[uniN release];
	[distN release];
	[dist release];
	[type release];
	[description release];

}


@end

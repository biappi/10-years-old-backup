//
//  AlertView.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "AlertView.h"


@implementation AlertView

@synthesize tipo,descr;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor=[UIColor clearColor];
		dist = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 185, 65)];
		uniN = [[UILabel alloc] initWithFrame:CGRectMake(105, 48,150, 65)];
		distN= [[UILabel alloc] initWithFrame:CGRectMake(35, 38,70, 65)];
		type = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 185, 65)];
		description=[[UILabel alloc]initWithFrame:CGRectMake(5, 93, 185, 65)];
		[self addSubview:distN];
		[self addSubview:type];
		[self addSubview:description];
		[self addSubview:uniN];

    }
    return self;
}

- (void)layoutSubviews
{
	dist.text=[NSString stringWithFormat:@"Distanza rimanente:"];
	dist.textColor=[UIColor whiteColor];
	dist.backgroundColor=[UIColor clearColor];
	[self addSubview:dist];
	
	UIFont * fo = [UIFont fontWithName:@"Arial" size:30.0];
	distN.font = fo;
	
	distN.textAlignment=UITextAlignmentRight;
	distN.textColor=[UIColor redColor];
	distN.backgroundColor=[UIColor clearColor];
		
	
	fo = [UIFont fontWithName:@"Arial" size:20.0];
	type.font = fo;
	type.text=tipo;
	type.textAlignment=UITextAlignmentCenter;
	type.textColor=[UIColor redColor];
	type.backgroundColor=[UIColor clearColor];
	
	description.text=descr;
	description.textAlignment=UITextAlignmentCenter;
	description.textColor=[UIColor whiteColor];
	description.numberOfLines=2;
	description.backgroundColor=[UIColor clearColor];
	
	
	
	uniN.textAlignment=UITextAlignmentLeft;
	uniN.textColor=[UIColor whiteColor];
	uniN.backgroundColor=[UIColor clearColor];
	}

-(void) setDistance:(int)x
{
	NSLog(@"setted distance");
	distance=x;
	if(distance>=1000)
	{
		float d = distance/1000.0;
		distN.text=[NSString stringWithFormat:@"%f",d];
	}
	else
		distN.text=[NSString stringWithFormat:@"%d",distance];
	
	if(distance>=1000)
	{
		float d = distance/1000.0;
		uniN.text=@"Km";
	}
	else
		uniN.text=@"m";	
	
}

- (int) distance
{
	return distance;
}

- (void)dealloc {
    
	[uniN release];
	[distN release];
	[dist release];
	[type release];
	[description release];
	[super dealloc];
}


@end

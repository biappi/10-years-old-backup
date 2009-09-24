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
		//era 75 ma si sovrapponeva
		type = [[UILabel alloc]initWithFrame:CGRectMake(0, 68, 185, 65)];
		description=[[UILabel alloc]initWithFrame:CGRectMake(5, 102, 185, 60)];
		[self addSubview:distN];
		[self addSubview:type];
		[self addSubview:description];
		[self addSubview:uniN];
		dist.text=[NSString stringWithFormat:@"Distanza rimanente:"];
		dist.textColor=[UIColor whiteColor];
		dist.backgroundColor=[UIColor clearColor];
		[self addSubview:dist];
		
		UIFont * fo = [UIFont fontWithName:@"Arial" size:50.0];
		distN.font = fo;
		
		distN.textAlignment=UITextAlignmentRight;
		distN.textColor=[UIColor whiteColor];
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
    return self;
}


-(void) setDistance:(int)x
{
	NSLog(@"setted distance");
	distance=x;
	if(distance>=1000)
	{
		float d = ((float)distance)/1000.0;
		distN.text=[NSString stringWithFormat:@"%1.1f",d];
	}
	else
		distN.text=[NSString stringWithFormat:@"%d",distance];
	
	if(distance>=1000)
	{
		uniN.text=@"Km";
	}
	else
		uniN.text=@"m";	
	
}
-(void) setDescr:(NSString *) des
{
	if(descr)
	{
		[descr release];
		descr=nil;
	}
	
	descr=[des retain];
	description.text=des;
}

-(void) setTipo:(NSString *) ti
{
	if(tipo)
	{
		[tipo release];
		tipo=nil;
	}
	
	tipo=[ti retain];
	type.text=ti;
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

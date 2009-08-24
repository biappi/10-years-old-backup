//
//  AlertView.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "AlertView.h"


@implementation AlertView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	UILabel *dist=[[UILabel alloc] initWithFrame:CGRectMake(5, 15, 185, 65)];
	dist.text=[NSString stringWithFormat:@"Distanza dall'autovelox:"];
	dist.textColor=[UIColor whiteColor];
	dist.backgroundColor=[UIColor clearColor];
	[self addSubview:dist];
	[dist release];
	UILabel *distN=[[UILabel alloc] initWithFrame:CGRectMake(5, 45, 185, 65)];
	UIFont * fo = [UIFont fontWithName:@"Arial" size:50.0];
	distN.font = fo;
	
	if(distance>=1000)
	{
		float d = distance/1000;
		distN.text=[NSString stringWithFormat:@"%f",d];
	}
	else
		distN.text=[NSString stringWithFormat:@"%d",distance];
	
	distN.textColor=[UIColor redColor];
	distN.backgroundColor=[UIColor clearColor];
	[self addSubview:distN];
	[distN release];
}


- (void)dealloc {
    [super dealloc];
}


@end

//
//  LoadDataView.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 28/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "LoadDataView.h"

@interface LoadDataView(PrivateMethod)
	


@end



@implementation LoadDataView

@synthesize line,lines,animDur;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
        // Initialization code
		//back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		self.image=[UIImage imageNamed:@"HomeScreenItaly.png"];
		car=[[UIImageView alloc] initWithFrame:CGRectMake(50,265, 33, 19)];
		car.image=[UIImage imageNamed:@"CarSmallLeft.png"];
		animDur=0.2;
		[self addSubview:car];
    }
    return self;
}


-(void)animat;
{	
	float li=(float)line;
	float lis=(float) lines;
	[UIView beginAnimations:@"moveCar" context:nil];
	[UIView setAnimationDuration:animDur];
	car.frame=CGRectMake(50+((190*li)/lis), 265, 33, 19);
	//car.center=CGPointMake(car.center.x+10,car.center.y);
	[UIView commitAnimations];
}

- (void)dealloc {
    [super dealloc];
}


@end

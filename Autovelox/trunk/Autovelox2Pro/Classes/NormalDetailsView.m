//
//  NormalDetailsView.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 23/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "NormalDetailsView.h"


@implementation NormalDetailsView

@synthesize numberOfAutovelox;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		numberOfAutovelox=0;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	UILabel *noa=[[UILabel alloc]initWithFrame:CGRectMake(5, 15, 185, 65)];
	noa.text=[NSString stringWithFormat:@"N° di autovelox nel raggio di 10Km: %d",numberOfAutovelox];
	noa.numberOfLines=2;
	noa.backgroundColor=[UIColor clearColor];
	noa.textColor=[UIColor whiteColor];
	[self addSubview:noa];
}



- (void)dealloc {
    [super dealloc];
}


@end

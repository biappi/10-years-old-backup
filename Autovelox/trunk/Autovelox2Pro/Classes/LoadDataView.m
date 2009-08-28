//
//  LoadDataView.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 28/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "LoadDataView.h"


@implementation LoadDataView

@synthesize lines;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	[self addSubview:back];
}


- (void)dealloc {
    [super dealloc];
}


@end

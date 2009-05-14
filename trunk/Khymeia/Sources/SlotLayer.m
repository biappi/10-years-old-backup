//
//  SlotLayer.m
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 14/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SlotLayer.h"

@implementation SlotLayer

- (id) init;
{
	if ((self = [super init]) == nil)
		return nil;
	
	self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1].CGColor;
	self.borderColor     = [UIColor blackColor].CGColor;
	self.borderWidth     = 1;
	
	return self;
}

- (CGSize) preferredFrameSize;
{
	return CGSizeMake(72, 90);
}

@end

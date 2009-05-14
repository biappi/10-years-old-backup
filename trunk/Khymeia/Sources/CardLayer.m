//
//  CardLayer.m
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 14/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CardLayer.h"

@implementation CardLayer

- (id) initWithCard:(Card *)card;
{
	if ((self = [super init]) == nil)
		return nil;
	
	self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
	self.borderColor     = [UIColor blackColor].CGColor;
	self.borderWidth     = 1;
	
	return self;
}

- (CGSize) preferredFrameSize;
{
	return CGSizeMake(72, 90);
}

@end

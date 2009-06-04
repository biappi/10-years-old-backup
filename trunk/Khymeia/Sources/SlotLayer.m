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
	
	self.slotHighlight = NO;
	
	return self;
}

- (CGSize) preferredFrameSize;
{
	return CGSizeMake(72, 90);
}

- (BOOL)slotHighlight;
{
	return slotHighlight;
}

- (void)setSlotHighlight:(BOOL)x;
{
	slotHighlight = x;
	
	if (slotHighlight == NO)
	{
		self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1].CGColor;
		self.borderColor     = [UIColor blackColor].CGColor;
		self.borderWidth     = 1;
		self.masksToBounds   = YES;
	} else {
		self.backgroundColor = [UIColor colorWithRed:0x72 / 255.0 green:0x9f / 255.0 blue:0xcf / 255.0 alpha:1].CGColor;
		self.borderColor     = [UIColor colorWithRed:0x34 / 255.0 green:0x65 / 255.0 blue:0xa4 / 255.0 alpha:1].CGColor;
		self.borderWidth     = 1;
		self.masksToBounds   = YES;		
	}
}

@end

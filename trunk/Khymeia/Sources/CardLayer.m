//
//  CardLayer.m
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 14/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CardLayer.h"

@implementation CardLayer
@synthesize card;
- (id) initWithCard:(Card *)acard;
{
	if ((self = [super init]) == nil)
		return nil;
	self.card=acard;
	self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
	self.borderColor     = [UIColor blackColor].CGColor;
	self.borderWidth     = 1;
	UIImage *img;
	switch (acard.element) {
		case CardElementVoid:
			img=[UIImage imageNamed:@"vacuum.jpg"];
			break;
		case CardElementFire:
			img=[UIImage imageNamed:@"fire.jpg"];
			break;
		case CardElementWater:
			img=[UIImage imageNamed:@"water.jpg"];
			break;
		case CardElementEarth:
			img=[UIImage imageNamed:@"earth.jpg"];
			break;
		case CardElementWind:
			img=[UIImage imageNamed:@"air.jpg"];
			break;
		default:
			break;
	}
	[self setContents:(id) [img CGImage]];
	return self;
}

- (CGSize) preferredFrameSize;
{
	return CGSizeMake(72, 90);
}

@end

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
	UIImage *img=[UIImage imageNamed:acard.image];	
	[self setContents:(id) [img CGImage]];
	
	return self;
}

- (CGSize) preferredFrameSize;
{
	return CGSizeMake(72, 90);
}

- (void) setPosition:(CGPoint) point
{
	[CATransaction begin]; 
	[CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
	[super setPosition:point];
	[CATransaction commit];
	
}

/*-(void) setLevel:(int) i
{
	NSString * level=

}*/

@end

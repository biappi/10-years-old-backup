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

+ (CardLayer *)cardWithCard:(Card *)theCard;
{
	return [[[CardLayer alloc] initWithCard:theCard] autorelease];
}

- (id) initWithCard:(Card *)acard;
{
	if ((self = [super init]) == nil)
		return nil;
	self.card=acard;
	self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
	self.borderColor     = [UIColor blackColor].CGColor;
	self.borderWidth     = 1;
	UIImage *img=[UIImage imageNamed:acard.image];	
	level=[[NSMutableArray alloc] init];
	[self setContents:(id) [img CGImage]];
	[self setLevel:card.level];
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

-(void) setLevel:(int) ii
{
	for(CALayer * l in level)
	{
		[l removeFromSuperlayer];
	}
	[level removeAllObjects];
	int i ;
	NSString * livello=[NSString stringWithFormat:@"%d",ii];
	
	for(i=0; i<livello.length; i++)
	{
		CALayer* layCard=[CALayer layer];
		layCard.borderColor     = [UIColor whiteColor].CGColor;
		layCard.borderWidth     = 1;
		
		layCard.frame=CGRectMake(5+i*10,5,15,15);
		layCard.bounds=CGRectMake(5+i*10,5,15,15);
		NSString * image=[NSString stringWithFormat:@"%c%@",[livello characterAtIndex:i],@".png"];
		UIImage * img=[UIImage imageNamed:image] ;
		
		[level addObject:layCard];
		[self addSublayer:layCard];
		[layCard setContents: (id)[img CGImage]];
		
		
	}

}

@end

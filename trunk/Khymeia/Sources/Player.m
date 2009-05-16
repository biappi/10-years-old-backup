//
//  Player.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize name;
@synthesize health;
@synthesize deck;
@synthesize hand;
@synthesize cemetery;

-(id) init
{
	if (self = [super init])
	{
		
	}
	return self;
}

-(BOOL)isCardInHand:(Card*)aCard;
{
	BOOL cardIsInHand=NO;
	for (Card * card in hand)
	{
		if ([card isEqual:aCard])
		{
			cardIsInHand=YES;
		}
	}
	return cardIsInHand;
}

-(BOOL)removeCardFromHand:(Card*)aCard;
{
	BOOL cardIsInHand=NO;
	for (Card * card in hand)
	{
		if ([card isEqual:aCard])
		{
			cardIsInHand=YES;
		}
	}
	if (cardIsInHand)
		[hand removeObject:aCard];
	return cardIsInHand;
}

@end

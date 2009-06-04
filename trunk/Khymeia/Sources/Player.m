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

+(id)playerWithPlayer:(Player*)aPlayer;
{
	Player *clone = [[Player alloc] init];
	clone.name = [NSString stringWithString:aPlayer.name];
	clone.health = aPlayer.health;
	clone.hand = [NSMutableArray arrayWithArray:aPlayer.hand];
	clone.cemetery = [NSMutableArray arrayWithArray:aPlayer.cemetery];
	clone.deck = [NSMutableArray arrayWithArray:aPlayer.deck];
	return [clone autorelease];
}

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

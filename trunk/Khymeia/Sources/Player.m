//
//  Player.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Player.h"
#import "TableTarget.h"


@implementation Player

@synthesize name;
@synthesize health;
@synthesize deck;
@synthesize hand;
@synthesize cemetery;
@synthesize playArea;

+(id)playerWithPlayer:(Player*)aPlayer;
{
	Player *clone = [[Player alloc] initWithHand:[NSMutableArray arrayWithArray:aPlayer.hand] playArea:[NSMutableArray arrayWithArray:aPlayer.playArea]];
	clone.name = [NSString stringWithString:aPlayer.name];
	clone.health = aPlayer.health;
	clone.cemetery = [NSMutableArray arrayWithArray:aPlayer.cemetery];
	clone.deck = [NSMutableArray arrayWithArray:aPlayer.deck];
	
	return [clone autorelease];
}

-(id) init;
{
	if (self = [super init])
	{
		playArea   = [[NSMutableArray alloc] initWithCapacity:4];
		hand = [[NSMutableArray alloc] initWithCapacity:5];
		
		for (int i=0; i<4; i++)
		{
			[playArea addObject:[NSNull null]];
		}
		
		for (int i=0; i<5; i++)
		{
			[hand addObject:[NSNull null]];
		}
	}
	return self;
}

-(id) initWithHand:(NSMutableArray*)aHand;
{
	if (self = [super init])
	{
		hand = [aHand retain];
		
		playArea   = [[NSMutableArray alloc] initWithCapacity:4];		
		for (int i=0; i<4; i++)
		{
			[playArea addObject:[NSNull null]];
		}
	}
	return self;
}

-(id) initWithHand:(NSMutableArray*)aHand playArea:(NSMutableArray*)aPlayArea;
{
	if (self = [super init])
	{
		hand = [aHand retain];
		playArea = [aPlayArea retain];
	}
	return self;
}

-(void)dealloc
{
	[hand release];
	[cemetery release];
	[deck release];
	[playArea release];
	[name release];
	[super dealloc];
}



- (Card *)cardForTarget:(Target *)t;
{
	switch (t.type)
	{
		case TargetTypePlayerHand:
			return [self.hand objectAtIndex:t.position];
			
		case TargetTypePlayerPlayArea:
			return [self.playArea objectAtIndex:t.position];
			
		case TargetTypePlayerDeck:
			return [self.deck objectAtIndex:t.position];
			
		case TargetTypePlayerCemetery:
			return [self.cemetery objectAtIndex:t.position];
		default:
			return nil;
	}
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
	int i=0,position;
	for (Card * card in hand)
	{
		if ([card isEqual:aCard])
		{
			cardIsInHand=YES;
			position = i;
		}
		i++;
	}
	if (cardIsInHand)
		[self.hand replaceObjectAtIndex:position withObject:[NSNull null]];
	
	return cardIsInHand;
}

- (NSArray *)playAreaFreePositions;
{
	NSMutableArray * ret = [NSMutableArray arrayWithCapacity:4];

	for (int i = 0; i < 4; i++)
		if ([playArea objectAtIndex:i] == [NSNull null])
			[ret addObject:[Target targetWithType:TargetTypePlayerPlayArea position:i]];

	return [NSArray arrayWithArray:ret];
}

- (void)addCard:(Card *)aCard toPosition:(Target *)aTarget;
{
	[playArea replaceObjectAtIndex:aTarget.position withObject:aCard];
}

- (void)discardCardFromTarget:(Target *)aTarget;
{
	Card* card;
	if (!(card= [self cardForTarget:aTarget]))
		return;
	
	[self.cemetery addObject:card];
	
	switch (aTarget.type)
	{
		case TargetTypePlayerHand:
			[self removeCardFromHand:card];
			
		case TargetTypePlayerPlayArea:
			[self.playArea replaceObjectAtIndex:aTarget.position withObject:[NSNull null]];
			
		case TargetTypePlayerDeck:
			[self.deck removeObject:card];
			
		case TargetTypePlayerCemetery:
			[self.cemetery removeObject:card];
	}
	
}

@end

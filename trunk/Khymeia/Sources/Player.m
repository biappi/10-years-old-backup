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
	Player *clone = [[Player alloc] init];
	clone.name = [NSString stringWithString:aPlayer.name];
	
	NSMutableArray *cemetery = [[NSMutableArray alloc] init];
	NSMutableArray *deck = [[NSMutableArray alloc] init];
	NSMutableArray *playArea = [[NSMutableArray alloc] init];	
	NSMutableArray *hand = [[NSMutableArray alloc] init];
	
	for (Card * card in aPlayer.hand)
	{
		if ([card class] == [NSNull class])
		{
			[hand addObject:card];
		}
		else
		{
			Card * tmp=[[Card cardWithCard:card] retain];
			[hand addObject:tmp];
			[tmp release];	
		}
	}
	for (Card * card in aPlayer.deck)
	{
		if ([card class] == [NSNull class])
		{
			[deck addObject:card];
		}
		else
		{
			Card * tmp=[[Card cardWithCard:card] retain];
			[deck addObject:tmp];
			[tmp release];
		}
	}
	for (Card * card in aPlayer.cemetery)
	{
		if ([card class] == [NSNull class])
		{
			[cemetery addObject:card];
		}
		else
		{
			[cemetery addObject:[Card cardWithCard:card]];
		}
	}
	for (Card * card in aPlayer.playArea)
	{
		if ([card class] == [NSNull class])
		{
			[playArea addObject:card];
		}
		else
		{
			[playArea addObject:[Card cardWithCard:card]];
		}
	}
	
	clone.cemetery = cemetery;
	clone.deck = deck;
	clone.playArea = playArea;
	clone.hand = hand;
	
	[cemetery release];
	[deck release];
	[hand release];
	[playArea release];
	
	clone.health = aPlayer.health;
	
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

//
//  Game.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Game.h"


@implementation Game

-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;
{
	if (self = [super init])
	{
		player = [aPlayer retain];
		opponent = [aOpponent retain];
		isFirst = iAmFirst; 
		
	}
	return self;
}


-(void)setup;
{
	player.health = 100;
	//mix deck
	//take first 5 cards
}

#pragma mark -
#pragma mark gameplay internal methods

-(BOOL)willPlayInstance:(Card*)aInstace	onInstance:(Card*)otherInstace;
{
	if (aInstace.element == CardElementVoid)
	{
		return YES;
	}
	else if (aInstace.element == CardElementEarth)
	{
		if (otherInstace.element == CardElementWind)
			return YES;
		else
			return NO;
	}
	else if (aInstace.element == CardElementFire)
	{
		if (otherInstace.element == CardElementWater)
			return YES;
		else
			return NO;
	}
	else if (aInstace.element == CardElementWater)
	{
		if (otherInstace.element == CardElementFire)
			return YES;
		else
			return NO;
	}
	else if (aInstace.element == CardElementWind)
	{
		if (otherInstace.element == CardElementEarth)
			return YES;
		else
			return NO;
	}
	NSLog(@"unxpected case in willPlayInstance");
	return NO;
}

-(void)didPlayInstance:(Card*)aInstace	onInstance:(Card*)otherInstace;
{
	//calculate otherIstance damage
	otherInstace.health = otherInstace.health - aInstace.level;
	if (otherInstace.health < 1)
	{
		NSLog(@"card %@ is dead", otherInstace.name);
		//say to interface for bring the otherIstance to opponent's cimitery
	}
}

#pragma mark -
#pragma mark Interface to Gameplayer methods

-(BOOL)willPlayCard:(Card*)aCard onCard:(Card*)otherCard;
{
	if(aCard.type == CardTypeElement && otherCard == CardTypeElement)
	{
		BOOL result = [self willPlayInstance:aCard onInstance:otherCard];
		//pass state change to comunication layer
		return result;
	}
	else
		return NO;
}

-(void)didPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{
	if(aCard.type == CardTypeElement && otherCard == CardTypeElement)
	{
		//pass state change to comunication layer
		[self didPlayInstance:aCard onInstance:otherCard];
	}
}

-(BOOL)willPlayCard:(Card*)aCard atPlayer:(Player*)aPlayer;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(void)didPlayCard:(Card*)aCard atPlayer:(Player*)aPlayer;
{
	NOT_IMPLEMENTED();
}

-(BOOL)willPlayCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(void)didPlayCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
}

-(BOOL)willSelectCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(void)didSelectCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
}

-(BOOL)shouldPassNextPhase;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(void)didDiscardCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
}

-(void)didTimeout;
{
	NOT_IMPLEMENTED();
}


@end

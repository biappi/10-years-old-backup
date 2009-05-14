//
//  Game.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Game.h"

@interface Game (PrivateMethods)

-(void)setupState;

-(void)playerStateBegin;

-(void)playerPhaseCardAttainment;

-(void)playerPhaseMainphase;

-(void)playerPhaseAttack;

-(void)playerPhaseDamageResolution;

-(void)playerPhaseDiscard;

-(void)opponentStateBegin;

-(void)callNextState;

@end



@implementation Game

@synthesize interface;

-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;
{
	if (self = [super init])
	{
		player = [aPlayer retain];
		opponent = [aOpponent retain];
		//isFirst YES if user is first player, NO otherwise
		isFirst = iAmFirst; 
		interface = [[InterfaceController alloc] init];
		
	}
	return self;
}

-(void)dealloc;
{
	[interface release];
	[player release];
	[opponent release];
	[super dealloc];
}

-(void)callNextState;
{
	if (state == GameStatePlayer ||state == GameStateOpponent)
	{
		if (phase == GamePhaseCardAttainment)
			[self playerPhaseMainphase];
		else if (phase == GamePhaseMainphase)
			[self playerPhaseAttack];
		else if (phase == GamePhaseAttack)
			[self playerPhaseDamageResolution];
		else if (phase == GamePhaseDamageResolution)
		{
			if (state == GameStatePlayer)
				[self opponentStateBegin];
			else
				[self playerStateBegin];
		}
	}
	else if (state == GameStateSetup)
	{
		if (isFirst)
			[self playerStateBegin];
		else
			[self opponentStateBegin];
	}
	else if (state == GameStateEnd)
	{
		//do somethings
	}
}

#pragma mark -
#pragma mark GameState methods

-(void)setupState;
{		
	state = GameStateSetup;
	//[interface setState:state];
	phase = GamePhaseNone;
	player.health = 100;
	//mix deck
	[interface drawCard:[player.hand objectAtIndex:0]];
	[interface drawCard:[player.hand objectAtIndex:1]];
	[interface drawCard:[player.hand objectAtIndex:2]];
	[interface drawCard:[player.hand objectAtIndex:3]];
	[interface drawCard:[player.hand objectAtIndex:4]];
	
	[self callNextState];
}

-(void)playerStateBegin;
{	
	state = GameStatePlayer;
	[interface setState:state];
	//say to interface about state change
	//say to server about state change
	[self playerPhaseCardAttainment]; 

}
	
#pragma mark -
#pragma mark GamePhase player methods

-(void)playerPhaseCardAttainment;
{
	phase = GamePhaseCardAttainment;
	//[interface drawCard:[player.deck lastObject]];
	//[player.deck removeLastObject];
	[self callNextState];
}

-(void)playerPhaseMainphase;
{
	phase = GamePhaseMainphase;
}


#pragma mark -
#pragma mark GameState opponent methods

-(void)opponentStateBegin;
{
	
}

#pragma mark -
#pragma mark Gameplay interface events methods

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
	if (state == GameStatePlayer)
	{
		if (phase == GamePhaseAttack || phase==GamePhaseMainphase)
		{
			if(aCard.type == CardTypeElement && otherCard == CardTypeElement)
			{
				BOOL result = [self willPlayInstance:aCard onInstance:otherCard];
				//pass state change to comunication layer
				return result;
			}
		}
		else
			return NO;
	}
	else if (state == GameStateOpponent)
	{
		//something
	}
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

/************************************************************
 *    Card on player with gesture is missing and is to add  *
 ************************************************************/


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
	[self callNextState];
	return YES;
}

-(void)didDiscardCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
}

-(void)didTimeout;
{
	NOT_IMPLEMENTED();
}

#pragma mark -
#pragma mark Gameplay to Opponent methods

-(BOOL)willPlayOpponentCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

@end

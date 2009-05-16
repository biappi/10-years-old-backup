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

-(void)callNextPhase;

-(BOOL)canPlayInstance:(Card*)aInstace	onInstance:(Card*)otherInstace;

@end



@implementation Game

@synthesize interface;

-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;
{
	if (self = [super init])
	{
		player = [aPlayer retain];
		opponent = [aOpponent retain];
		table = [[Table alloc] init];
		//isFirst YES if user is first player, NO otherwise
		isFirst = iAmFirst; 
		interface = [[InterfaceController alloc] init];
		/**********TEST STUFF******/
		 
		table.cardOpponent1 = [[[Card alloc] initWithName:@"eatFire" image:@"cardTest2" element:CardElementFire type:CardTypeElement level:6] autorelease];
		table.cardOpponent2 = [[[Card alloc] initWithName:@"Mio" image:@"cardTest1" element:CardElementWater type:CardTypeElement level:6] autorelease];
		table.cardOpponent3 = [[[Card alloc] initWithName:@"Yougurt" image:@"cardTest2" element:CardElementFire type:CardTypeElement level:6] autorelease];
		table.cardOpponent4 = [[[Card alloc] initWithName:@"Pippo" image:@"cardTest1" element:CardElementEarth type:CardTypeElement level:6] autorelease];
				 
		 /**********END TEST STUFF******/
	}
	return self;
}

-(void)dealloc;
{
	[table release];
	[interface release];
	[player release];
	[opponent release];
	[super dealloc];
}

-(void)callNextPhase;
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
	[interface setState:state];
	phase = GamePhaseNone;
	player.health = 100;
	
	//<------mix deck
	
	//take first 5 cards
	[interface drawCard:[player.hand objectAtIndex:0]];
	[interface drawCard:[player.hand objectAtIndex:1]];
	[interface drawCard:[player.hand objectAtIndex:2]];
	[interface drawCard:[player.hand objectAtIndex:3]];
	[interface drawCard:[player.hand objectAtIndex:4]];
	
	[self callNextPhase];
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
	if ([player.hand count]<5)
	{
		[interface drawCard:[player.deck lastObject]];
		[player.deck removeLastObject];
	}
	[self callNextPhase];
}

-(void)playerPhaseMainphase;
{
	phase = GamePhaseMainphase;
	[interface setPhase:phase];
}

-(void)playerPhaseAttack;
{
	//check if one of players is dead
	phase = GamePhaseAttack;
	
	//setting attack phase flags
	waitingForOpponentAttack = YES;
	playerDidAttack = NO;
	
	[interface setPhase:phase];
}

-(void)playerPhaseDamageResolution;
{
	phase = GamePhaseDamageResolution;
	[interface setPhase:phase];
	
	//calculate opponent damage and restoring player's card with health >0
	for (Card * card in table.playerCards)
	{
		if (card.health>0)
		{
			//apply card damage to opponent
			opponent.health -= card.health;
			//restoring healt to card
			card.health = card.level;
		}
		else
		{
			[interface discardFromPlayArea:card];
		}
	}
	[interface setHP:opponent.health player:opponent];
	//restoring opponent's card with health >0
	for (Card * card in table.opponentCards)
	{
		if (card.health>0)
		{
			card.health = card.level;
		}
		else
		{
			[interface discardFromPlayArea:card];
		}
	}	
}

-(void)playerPhaseDiscard;
{
	phase = GamePhaseDiscard;
	playerDidDiscard = NO;
	[interface setPhase:phase];
}


#pragma mark -
#pragma mark GameState opponent methods

-(void)opponentStateBegin;
{
	
}

#pragma mark -
#pragma mark private methods

-(BOOL)canPlayInstance:(Card*)aInstace	onInstance:(Card*)otherInstace;
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
	NSLog(@"unxpected case in canPlayInstance");
	return NO;
}

-(void)didPlayInstance:(Card*)aInstace	onInstance:(Card*)otherInstace;
{
	//calculate otherIstance damage
	otherInstace.health = otherInstace.health - aInstace.level;
	if (otherInstace.health < 1)
	{
		NSLog(@"card %@ is dead", otherInstace.name);
		[interface discardFromPlayArea:otherInstace];
	}
}

#pragma mark -
#pragma mark Interface to Gameplayer methods

-(void)willPlayCard:(Card*)aCard onTarget:(id)aTarget;
{
	//ND DoBs: now it is useless, but we will need it.
	if ([aTarget isKindOfClass:[Card class]])
	{
		//pass state change to comunication layer
	}
	else if ([aTarget isKindOfClass:[TableTarget class]])
	{
		
	}
}

-(void)didPlayCard:(Card*)aCard onTarget:(id)aTarget withGesture:(BOOL)completed;
{
	//set the flag to remeber that the play have attack in AttackPhase
	if (state == GameStatePlayer && phase == GamePhaseAttack)
	{
		playerDidAttack = YES;
	}
	
	if ([aTarget isKindOfClass:[Card class]])
	{
		Card* otherCard = (Card*)aTarget;
		if(aCard.type == CardTypeElement && otherCard == CardTypeElement)
		{
			//pass state change to comunication layer
			[self didPlayInstance:aCard onInstance:otherCard];
		}
	}
	else if ([aTarget isKindOfClass:[TableTarget class]])
	{
		TableTarget* tableTarget = (TableTarget*)aTarget;
		[table.playerCards insertObject:aCard atIndex:tableTarget.position];
	}
}

/************************************************************
 *    Card on player with gesture is missing and is to add  *
 ************************************************************/


-(void)willSelectCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
}

-(void)didSelectCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
}

-(BOOL)shouldPassNextPhase;
{
	if (state == GameStatePlayer)
	{
		if (!(phase == GamePhaseDiscard) || ((phase == GamePhaseDiscard) && playerDidDiscard) 
			|| ((phase == GamePhaseAttack) && !playerDidAttack))
		{
			[self callNextPhase];
			return YES;
		}
	}
	else
	{
		
	}
	return NO;
}

-(NSArray*)targetsForCard:(Card*)aCard;
{	
	if (state == GameStatePlayer)
	{
		if ((phase == GamePhaseAttack && !waitingForOpponentAttack) || phase==GamePhaseMainphase)
		{
			NSMutableArray *targets = [[NSMutableArray alloc] init];
			TableTarget *tableTarget;
			if (aCard.type == CardTypeElement)
			{
				for (Card * opponentCard in table.opponentCards)
				{
					//check if i can play aCard vs opponentCard
					if ([self canPlayInstance:aCard onInstance:opponentCard])
					{
						tableTarget = [[[TableTarget alloc] init] autorelease];
						tableTarget.position = [table.opponentCards indexOfObject:opponentCard];				
						tableTarget.table = TableTargetTypeOpponent;				
						[targets addObject:tableTarget];
					}
				}
				for (Card * playerCard in table.playerCards)
				{
					
				}
			}
			NSArray *array = [NSArray arrayWithArray:targets];
			[targets release];
			return array;
		}
	}
	return nil;
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

/***************************************
* THIS METHOD MUST BE UPDATE TO TARGET *
****************************************/


-(BOOL)willPlayOpponentCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(BOOL)didPlayOpponentCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(BOOL)willPlayOpponentCard:(Card*)aCard onCard:(Card*)otherCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(BOOL)didPlayOpponentCard:(Card*)aCard onCard:(Card*)otherCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(BOOL)willPlayOpponentCard:(Card*)aCard atPlayer:(Player*)aPlayer;
{
	NOT_IMPLEMENTED();
	return NO;
}


-(BOOL)didPlayOpponentCard:(Card*)aCard atPlayer:(Player*)aPlayer;
{
	NOT_IMPLEMENTED();
	return NO;
}


-(BOOL)didPlayOpponentCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{
	NOT_IMPLEMENTED();
	return NO;
}

@end

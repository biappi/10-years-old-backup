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

-(void)opponentPhaseCardAttainment;

-(void)opponentPhaseMainphase;

-(void)opponentPhaseAttack;

-(void)opponentPhaseDamageResolution;

-(void)opponentPhaseDiscard;

-(void)callNextPhase;

-(BOOL)canPlayInstance:(Card*)aInstace	onInstance:(Card*)otherInstace;

@end



@implementation Game

@synthesize interface;
@synthesize comLayer;

-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;
{
	if (self = [super init])
	{
		player = [aPlayer retain];
		opponent = [aOpponent retain];
		table = [[Table alloc] init];
		//isFirst YES if user is first player, NO otherwise
		isFirst = iAmFirst; 
		/*
		 WILLY: moved out to appdelegate to better implement scrolling etc...
		interface = [[InterfaceController alloc] init];
		interface.gameplay = self;
		*/
		
		/**********TEST STUFF******/
		interface.gameplay=self;
		table.cardOpponent1 = [[[Card alloc] initWithName:@"eatFire" image:@"fire.jpg" element:CardElementFire type:CardTypeElement level:6] autorelease];
		[interface opponentPlaysCard:table.cardOpponent1 onTarget:[[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:1] autorelease]];
		table.cardOpponent2 = [[[Card alloc] initWithName:@"Mio" image:@"water.jpg" element:CardElementWater type:CardTypeElement level:6] autorelease];
		[interface opponentPlaysCard:table.cardOpponent2 onTarget:[[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:2] autorelease]];
		table.cardOpponent3 = [[[Card alloc] initWithName:@"Yougurt" image:@"fire.jpg" element:CardElementFire type:CardTypeElement level:6] autorelease];
		[interface opponentPlaysCard:table.cardOpponent3 onTarget:[[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:3] autorelease]];
		table.cardOpponent4 = [[[Card alloc] initWithName:@"Pippo" image:@"earth.jpg" element:CardElementEarth type:CardTypeElement level:6] autorelease];
		[interface opponentPlaysCard:table.cardOpponent4 onTarget:[[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:4] autorelease]];
				 
		 /**********END TEST STUFF******/
	}
	return self;
}

-(void)dealloc;
{
	[table release];
	/*
	 removed, interface to gameplay and vice-versa are weak pointers,
	 they're both retained by the AppDelegate
	 
	[interface release];
	 */
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
		{
			if (isFirstTurn)
			{
				isFirstTurn = NO;
				[self playerPhaseDamageResolution];				
			}
			else
				[self playerPhaseAttack];
		}
		else if (phase == GamePhaseAttack)
			[self playerPhaseDamageResolution];
		else if (phase == GamePhaseDamageResolution)
			[self playerPhaseDiscard];
		else if (phase == GamePhaseDiscard)
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
	NSLog(@"setup state");
	state = GameStateSetup;
	[interface setState:state];
	phase = GamePhaseNone;
	player.health = 100;
	isFirstTurn = YES;
	
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
	//say to interface about state change
	[interface setState:state];
	//say to server about state change
	//[comunication sendStateChange:state];
	[self playerPhaseCardAttainment]; 

}

-(void)opponentStateBegin;
{
	state = GameStateOpponent;
	[interface setState:state];
	[self opponentPhaseCardAttainment];
	
}
	
#pragma mark -
#pragma mark GamePhase player methods

-(void)playerPhaseCardAttainment;
{
	phase = GamePhaseCardAttainment;
	[interface setPhase:phase];
	//[comunication sendPhaseChange:phase];
	if ([player.hand count]<5)
	{
		[interface drawCard:[player.deck lastObject]];
		//[comunication sendDrawCard:[player.deck lastObject]];
		[player.hand addObject:[player.deck lastObject]];
		[player.deck removeLastObject];
	}
	[self callNextPhase];
}

-(void)playerPhaseMainphase;
{
	phase = GamePhaseMainphase;
	[interface setPhase:phase];
	//[comunication sendPhaseChange:phase];
}

-(void)playerPhaseAttack;
{
	//check if one of players is dead
	phase = GamePhaseAttack;
	
	//setting attack phase flags
	waitingForOpponentAttack = YES;
	playerDidAttack = NO;
	
	[interface setPhase:phase];
	//[comunication sendPhaseChange:phase];
}

-(void)playerPhaseDamageResolution;
{
	phase = GamePhaseDamageResolution;
	[interface setPhase:phase];
	//[comunication sendPhaseChange:phase];
	
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
	[self callNextPhase];
}

-(void)playerPhaseDiscard;
{
	phase = GamePhaseDiscard;
	//*******************************************************************************************/
	//IN THIS VERSION DISCARD PHASE DON'T WORK, SO SET THIS FLAG TO YES, OTHERWISE IT MUST BE YES
	//*******************************************************************************************/
	playerDidDiscard = YES;
	[interface setPhase:phase];
	[self callNextPhase];
}


#pragma mark -
#pragma mark GameState opponent methods

-(void)opponentPhaseCardAttainment;
{
	phase = GamePhaseCardAttainment;
	[interface setPhase:phase];
	
}

-(void)opponentPhaseMainphase;
{
	phase = GamePhaseMainphase;
	[interface setPhase:phase];
}

-(void)opponentPhaseAttack;
{
	phase = GamePhaseAttack;
	opponentDidAttack=YES;
	[interface setPhase:phase];
}

-(void)opponentPhaseDamageResolution;
{
	phase = GamePhaseDamageResolution;
	[interface setPhase:phase];
}

-(void)opponentPhaseDiscard;
{
	phase = GamePhaseDiscard;
	[interface setPhase:phase];
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
}

#pragma mark -
#pragma mark Interface to Gameplayer methods

-(void)willPlayCard:(Card*)aCard onTarget:(id)aTarget;
{
	//ND DoBs: now it is useless, but we will need it.
	//[comunication sendWillPlayCard:aCard onTarget:aTarget];
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
	
	//[comunication sendDidPlayCard:aCard onTarget:aTarget];
	
	if (state == GameStatePlayer && phase == GamePhaseAttack)
	{
		playerDidAttack = YES;
	}
	
	//remove card from user's hand
	[player removeCardFromHand:aCard];
	
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
		[table addCard:aCard toPosition:tableTarget];
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
			|| ((phase == GamePhaseAttack) && !playerDidAttack && !waitingForOpponentAttack))
		{
			[self callNextPhase];
			return YES;
		}
	}
	return NO;
}

-(NSArray*)targetsForCard:(Card*)aCard;
{
	if (state == GameStatePlayer)
	{
		if ([player isCardInHand:aCard]																		//if aCard is in hand
			&& ((phase == GamePhaseAttack && !waitingForOpponentAttack) || phase==GamePhaseMainphase))      //and is the right phase
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
						tableTarget.position = [table.opponentCards indexOfObject:opponentCard]+1;				
						tableTarget.table = TableTargetTypeOpponent;				
						[targets addObject:tableTarget];
					}
				}
			}
			if (phase == GamePhaseMainphase && !aCard.element == CardElementVoid)				
				[targets addObjectsFromArray:[table playerFreePositions]];
			
			NSArray *array = [NSArray arrayWithArray:targets];
			[targets release];
			return array;
		}
	}
	else
	{
		if ([player isCardInHand:aCard]
			&& (phase = GamePhaseAttack && opponentDidAttack))
		{
			
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


-(BOOL)willPlayOpponentCard:(Card*)aCard onTarget:(TableTarget*)aTarget;
{
	//ND DoBs: now it is useless, but we will need it.
	return YES;
}

-(BOOL)didPlayOpponentCard:(Card*)aCard onTarget:(TableTarget*)aTarget;
{
	if (state == GameStateOpponent && phase == GamePhaseAttack && waitingForOpponentAttack)
	{
		waitingForOpponentAttack = NO;
	}
	
	//remove card from user's hand
	[opponent removeCardFromHand:aCard];
	
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
		[table addCard:aCard toPosition:tableTarget];
	}
	
	return NO;
}

-(void)didOpponentPassPhase;
{
	[self callNextPhase];
}


@end

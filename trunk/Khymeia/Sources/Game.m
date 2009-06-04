//
//  Game.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Game.h"
#import "ComunicatioLayer.h"

@interface Game (PrivateMethods)

-(void)setupState;

-(void)playerStateBegin;

-(void)playerPhaseCardAttainment;

-(void)playerPhaseMainphase;

-(void)playerPhaseAttackOpponent;

-(void)playerPhaseAttackPlayer;

-(void)playerPhaseDamageResolution;

-(void)playerPhaseDiscard;

-(void)opponentStateBegin;

-(void)opponentPhaseCardAttainment;

-(void)opponentPhaseMainphase;

-(void)opponentPhaseAttackOpponent;

-(void)opponentPhaseAttackPlayer;

-(void)opponentPhaseDamageResolution;

-(void)opponentPhaseDiscard;

-(void)callNextPhase;

-(BOOL)canPlayInstance:(Card*)aInstace	onInstance:(Card*)otherInstace;

@end



@implementation Game

@synthesize interface;
@synthesize comunication;

-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;
{
	if (self = [super init])
	{
		player = [aPlayer retain];
		opponent = [aOpponent retain];
		table = [[Table alloc] init];
		//isFirst YES if user is first player, NO otherwise
		isFirst = iAmFirst; 
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
	if (state == GameStatePlayer || state == GameStateOpponent)
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
				[self playerPhaseAttackOpponent];
		}
		else if (phase == GamePhaseAttackOpponent)
			[self playerPhaseAttackPlayer];
		else if (phase == GamePhaseAttackPlayer)
		{		
			if (playerDidAttack)
				[self playerPhaseAttackOpponent];
			else
				[self playerPhaseDamageResolution];
		}
		else if (phase == GamePhaseDamageResolution)
			[self playerPhaseDiscard];
		else if (phase == GamePhaseDiscard)
		{
			if (state == GameStatePlayer)
			{
				//END TURN
				[comunication sendStateChange:GameStateOpponent];
			}
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
	KhymeiaLog([NSString stringWithFormat:@"player %@ setup state", player.name]);
	
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
}

-(void)start;
{
	if (isFirst)
		[self callNextPhase];
}

-(void)playerStateBegin;
{	
	KhymeiaLog([NSString stringWithFormat:@"player %@ Statebegin", player.name]);
	state = GameStatePlayer;	
	//say to interface about state change
	[interface setState:state];
	//say to server about state change
	[comunication sendStateChange:state];
	[self playerPhaseCardAttainment]; 

}

-(void)opponentStateBegin;
{
	KhymeiaLog([NSString stringWithFormat:@"player %@ Opponent Statebegin", player.name]);
	state = GameStateOpponent;
	[interface setState:state];	
}
	
#pragma mark -
#pragma mark GamePhase player methods

-(void)playerPhaseCardAttainment;
{
	KhymeiaLog([NSString stringWithFormat:@"player: %@ Card Attainment", player.name]);
	
	phase = GamePhaseCardAttainment;
	[interface setPhase:phase];
	[comunication sendPhaseChange:phase];
	
	if ([player.hand count]<5)
	{
		[interface drawCard:[player.deck lastObject]];
		[comunication sendDrawCard:[player.deck lastObject]];
		[player.hand addObject:[player.deck lastObject]];
		[player.deck removeLastObject];
	}
	[self callNextPhase];
}

-(void)playerPhaseMainphase;
{
	KhymeiaLog([NSString stringWithFormat:@"player: %@ Card Mainphase", player.name]);
	
	phase = GamePhaseMainphase;
	[interface setPhase:phase];
	[comunication sendPhaseChange:phase];
}

-(void)playerPhaseAttackOpponent;
{
	KhymeiaLog([NSString stringWithFormat:@"player: %@ Card Attack opponent", player.name]);
	
	//check if one of players is dead
	phase = GamePhaseAttackOpponent;
	playerDidAttack = NO;
	
	[interface setPhase:phase];
	[comunication sendPhaseChange:phase];
}

-(void)playerPhaseAttackPlayer;
{
	KhymeiaLog([NSString stringWithFormat:@"player: %@ Card Attack player", player.name]);
	
	//check if one of players is dead
	phase = GamePhaseAttackPlayer;
	
	[interface setPhase:phase];
	[comunication sendPhaseChange:phase];
}

-(void)playerPhaseDamageResolution;
{
	KhymeiaLog([NSString stringWithFormat:@"player: %@ Damage resolution", player.name]);
	
	phase = GamePhaseDamageResolution;
	[interface setPhase:phase];
	[comunication sendPhaseChange:phase];
	
	//calculate opponent damage and restoring player's card with health >0
	for (Card * card in table.playerPlayArea)
	{
		if ([card class] != [NSNull class])
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
	}
	[interface setHP:opponent.health player:PlayerKindOpponent];
	//restoring opponent's card with health >0
	for (Card * card in table.opponentPlayArea)
	{
		if ([card class] != [NSNull class])
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
	[self callNextPhase];
}

-(void)playerPhaseDiscard;
{
	KhymeiaLog([NSString stringWithFormat:@"player: %@ Discard", player.name]);
	
	phase = GamePhaseDiscard;
	//*******************************************************************************************/
	//IN THIS VERSION DISCARD PHASE DON'T WORK, SO SET THIS FLAG TO YES, OTHERWISE IT MUST BE NO
	//*******************************************************************************************/
	playerDidDiscard = YES;
	[interface setPhase:phase];
	[comunication sendPhaseChange:phase];
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

-(void)opponentPhaseAttackOpponent;
{
	phase = GamePhaseAttackOpponent;
	opponentDidAttack=YES;
	[interface setPhase:phase];
}

-(void)opponentPhaseAttackPlayer;
{
	phase = GamePhaseAttackPlayer;
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
	NSInteger backup = otherInstace.health;
	otherInstace.health = otherInstace.health - aInstace.level;
	KhymeiaLog([NSString stringWithFormat:@"card: %@ vs card:%@ ------- %d = %d - %d", aInstace.name, otherInstace.name,otherInstace.health, backup, aInstace.level]);
}

#pragma mark -
#pragma mark Interface to Gameplayer methods

-(void)willPlayCard:(Card*)aCard onTarget:(Target*)aTarget;
{
	//ND DoBs: now it is useless, but we will need it.
	[comunication sendWillPlayCard:aCard onTarget:aTarget];
}

-(void)didPlayCard:(Card*)aCard onTarget:(Target*)aTarget withGesture:(BOOL)completed;
{
	//set the flag to remeber that the play have attack in AttackPhase
	
	[comunication sendDidPlayCard:aCard onTarget:aTarget];
	
	if (state == GameStatePlayer && phase == GamePhaseAttackPlayer)
	{
		playerDidAttack = YES;
	}
	
	//remove card from user's hand
	[player removeCardFromHand:aCard];
	
	if (aTarget.type == TargetTypeOpponentPlayArea)
	{
		Card* otherCard = (Card*)[table.opponentPlayArea objectAtIndex:aTarget.position];
		if(aCard.type == CardTypeElement && otherCard.type == CardTypeElement)
		{
			//pass state change to comunication layer
			[self didPlayInstance:aCard onInstance:otherCard];
		}
	}
	else if (aTarget.type == TargetTypePlayerPlayArea)
	{
		[table addCard:aCard toPosition:aTarget];
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
			|| ((phase == GamePhaseAttackPlayer) && !playerDidAttack))
		{
			[self callNextPhase];
			return YES;
		}
	}
	else if (state == GameStateOpponent)
	{
		if (phase == GamePhaseAttackOpponent)
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
			&& ((phase == GamePhaseAttackPlayer && !waitingForOpponentAttack) || phase==GamePhaseMainphase))      //and is the right phase
		{
			NSMutableArray *targets = [[NSMutableArray alloc] init];
			Target *tableTarget;
			if (aCard.type == CardTypeElement)
			{
				for (Card * opponentCard in table.opponentPlayArea)
				{
					//check if i can play aCard vs opponentCard
					if (!([opponentCard class] == [NSNull class]) && [self canPlayInstance:aCard onInstance:opponentCard])
					{
						tableTarget = [Target targetWithType:TargetTypeOpponentPlayArea position:[table.opponentPlayArea indexOfObject:opponentCard]];	
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
			&& phase == GamePhaseAttackOpponent)
		{
			NSMutableArray *targets = [[NSMutableArray alloc] init];
			Target *tableTarget;
			if (aCard.type == CardTypeElement)
			{
				for (Card * opponentCard in table.opponentPlayArea)
				{
					//check if i can play aCard vs opponentCard
					if (!([opponentCard class] == [NSNull class])  && [self canPlayInstance:aCard onInstance:opponentCard])
					{
						tableTarget = [Target targetWithType: TargetTypeOpponentPlayArea position:[table.opponentPlayArea indexOfObject:opponentCard]];	
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


-(BOOL)willPlayOpponentCard:(Card*)aCard onTarget:(Target*)aTarget;
{
	//ND DoBs: now it is useless, but we will need it.
	
	return YES;
}

-(BOOL)didPlayOpponentCard:(Card*)aCard onTarget:(Target*)aTarget;
{		
	Target* tableTarget = [Target targetWithTarget:aTarget];
	//convertion from opponent to player
	if (tableTarget.type == TargetTypeOpponentPlayArea)
		tableTarget.type = TargetTypePlayerPlayArea;
	else
		tableTarget.type= TargetTypeOpponentPlayArea;
	
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
	else if ([aTarget isKindOfClass:[Target class]])
	{
		[table addCard:aCard toPosition:tableTarget];
		
	}
	[interface opponentPlaysCard:aCard onTarget:tableTarget];
	
	return NO;
}

-(NSInteger)didOpponentPassPhase:(NSInteger)aPhase;
{
	phase = aPhase;
	if (aPhase == GamePhaseCardAttainment)
	{
		[self opponentPhaseCardAttainment];
	}
	else if (aPhase == GamePhaseMainphase)	
	{
		[self opponentPhaseMainphase];
	}
	else if (aPhase == GamePhaseAttackOpponent)	
	{
		[self opponentPhaseAttackOpponent];
	}
	else if (aPhase == GamePhaseAttackPlayer)	
	{
		[self opponentPhaseAttackPlayer];
	}
	else if (aPhase == GamePhaseDamageResolution)	
	{
		[self opponentPhaseDamageResolution];
	}
	else if (aPhase == GamePhaseDiscard)	
	{
		[self opponentPhaseDiscard];
	}
	return phase;
}

-(NSInteger)didOpponentPassStatus:(NSInteger)stato;
{
	state = stato;
	if (state==GameStatePlayer)
	{
		[self opponentStateBegin];
	}
	else
	{
		[self playerStateBegin];
	}
	return 0;
}

-(Card*)didOpponentDrawCard:(Card*)card;
{
	return nil;
}

@end

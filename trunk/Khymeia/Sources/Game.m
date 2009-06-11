//
//  Game.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Game.h"
#import "ComunicatioLayer.h"
#import "State.h"

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

//-(BOOL)canPlayInstance:(Card*)aInstace	onInstance:(Card*)otherInstace;

- (Card *)cardForTarget:(Target *)t;

- (void)resetInGameCards;

@end



@implementation Game

@synthesize interface;
@synthesize comunication;

@synthesize state;
@synthesize phase;

-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;
{
	if (self = [super init])
	{
		player = [aPlayer retain];
		opponent = [aOpponent retain];
		//isFirst YES if user is first player, NO otherwise
		isFirst = iAmFirst;
		inGameCards = [[NSMutableSet alloc] initWithCapacity:10];
	}
	return self;
}

-(void)dealloc;
{
	[inGameCards release];
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
	
	[interface drawCard:[player.hand objectAtIndex:0] toTarget:[Target targetWithType:TargetTypePlayerHand position:0]];
	[interface drawCard:[player.hand objectAtIndex:1] toTarget:[Target targetWithType:TargetTypePlayerHand position:1]];
	[interface drawCard:[player.hand objectAtIndex:2] toTarget:[Target targetWithType:TargetTypePlayerHand position:2]];
	[interface drawCard:[player.hand objectAtIndex:3] toTarget:[Target targetWithType:TargetTypePlayerHand position:3]];
	[interface drawCard:[player.hand objectAtIndex:4] toTarget:[Target targetWithType:TargetTypePlayerHand position:4]];
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
	
	// reset the list of in game cards
	[inGameCards removeAllObjects];
}

-(void)opponentStateBegin;
{
	KhymeiaLog([NSString stringWithFormat:@"player %@ Opponent Statebegin", player.name]);
	state = GameStateOpponent;
	[interface setState:state];	

	// reset the list of in game cards
	[inGameCards removeAllObjects];
}
	
#pragma mark -
#pragma mark GamePhase player methods

-(void)playerPhaseCardAttainment;
{
	KhymeiaLog([NSString stringWithFormat:@"player: %@ Card Attainment", player.name]);
	
	phase = GamePhaseCardAttainment;
	[interface setPhase:phase];
	[comunication sendPhaseChange:phase];
		
	int firstNull = [player.hand indexOfObject:[NSNull null]];
	if (firstNull != NSNotFound)
	{
 		Card * drawnCard = [[player.deck lastObject] retain];
		
		if (drawnCard != nil)
		{
			NSInteger lastObjectIndex = [player.deck indexOfObject:drawnCard];
			NSLog(@"carte rimaste deck %d", [player.deck count]-1);
			[player.deck removeLastObject];
			
			[interface drawCard:drawnCard toTarget:[Target targetWithType:TargetTypePlayerHand position:firstNull]];
			
			Target *srcTarget = [Target targetWithType:TargetTypePlayerDeck position:lastObjectIndex];
			Target *dstTarget = [Target targetWithType:TargetTypePlayerHand position:firstNull];
			[comunication sendDrawCardAtTarget:srcTarget placedToTarget:dstTarget playerKind:PlayerKindPlayer];
			
			[player.hand replaceObjectAtIndex:firstNull withObject:drawnCard];
		}
		[drawnCard release];
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
	int i = 0;
	for (Card * card in player.playArea)
	{
		if ([card class] != [NSNull class])
		{
			if (card.health>0)
			{
				//apply card damage to opponent
				opponent.health -= card.health;
				//restoring healt to card
				card.health = card.level;
				[comunication sendDamageToOpponent:card.health];
			}
			else
			{
				[interface discardFromTarget:[Target targetWithType:TargetTypePlayerPlayArea position:i]];
			}
			
			i++;
		}
	}
	[interface setHP:opponent.health player:PlayerKindOpponent];
	
	//restoring opponent's card with health >0
	for (Card * card in opponent.playArea)
	{
		if ([card class] != [NSNull class])
		{
			if (card.health>0)
			{
				card.health = card.level;
			}
			else
			{
				[interface discardFromTarget:[Target targetWithType:TargetTypeOpponentPlayArea position:i]];
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



-(void)didPlayInstance:(Card*)aInstace	onInstance:(Card*)otherInstace;
{
	//calculate otherIstance damage
	NSInteger backup = otherInstace.health;
	otherInstace.health = otherInstace.health - aInstace.level;
	KhymeiaLog([NSString stringWithFormat:@"card: %@ vs card:%@ ------- %d = %d - %d", aInstace.name, otherInstace.name,otherInstace.health, backup, aInstace.level]);
}


- (Card *)cardForTarget:(Target *)t;
{
	switch (t.type)
	{
		case TargetTypePlayerHand:
			return [player.hand objectAtIndex:t.position];
		case TargetTypeOpponentHand:
			return [opponent.hand objectAtIndex:t.position];
		case TargetTypeOpponentPlayArea:
			return [opponent.playArea objectAtIndex:t.position];			
		case TargetTypePlayerPlayArea:
			return [player.playArea objectAtIndex:t.position];
		default:
			return nil;
	}
}

#pragma mark -
#pragma mark Interface to Gameplayer methods

- (void)willPlayCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget;
{
	//ND DoBs: now it is useless, but we will need it.
	[comunication sendWillPlayCardAtTarget:srcTarget onTarget:dstTarget];
	
}

- (void)didPlayCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget withGesture:(BOOL)completed;
{
	//set the flag to remeber that the play have attack in AttackPhase
	
	[comunication sendDidPlayCardAtTarget:srcTarget onTarget:dstTarget];
	Card* aCard;
	if (!(aCard = [self cardForTarget:srcTarget]))
		return;
	
	if (state == GameStatePlayer && phase == GamePhaseAttackPlayer)
	{
		playerDidAttack = YES;
	}
	
	//remove card from user's hand
	[player removeCardFromHand:aCard];
	
	if (dstTarget.type == TargetTypeOpponentPlayArea)
	{
		Card* otherCard = (Card*)[opponent.playArea objectAtIndex:dstTarget.position];
		if(aCard.type == CardTypeElement && otherCard.type == CardTypeElement)
		{
			//pass state change to comunication layer
			[self didPlayInstance:aCard onInstance:otherCard];
		}
		
		[interface discardFromTarget:srcTarget];
	}
	else if (dstTarget.type == TargetTypePlayerPlayArea && ([[player.playArea objectAtIndex:dstTarget.position] class] != [NSNull class]))
	{
		Card* otherCard = (Card*)[player.playArea objectAtIndex:dstTarget.position];
		if(aCard.type == CardTypeElement && otherCard.type == CardTypeElement && ![otherCard isEqual:aCard])
		{
			//pass state change to comunication layer
			[self didPlayInstance:aCard onInstance:otherCard];
		}
		
		[interface discardFromTarget:srcTarget];
	}
	else if (dstTarget.type == TargetTypePlayerPlayArea)
	{
		[player addCard:aCard toPosition:dstTarget];
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

- (NSArray *)targetsForCardAtTarget:(Target *)aTarget;
{
	if (aTarget.type == TargetTypePlayerHand &&																						//if card is in hand
		(state==GameStatePlayer && ((phase == GamePhaseAttackPlayer && !waitingForOpponentAttack) || phase==GamePhaseMainphase))    // if i am player
		|| ((phase == GamePhaseAttackOpponent && waitingForOpponentAttack) && state==GameStateOpponent))							// if i am opponent		
		{
			State *farlockState=[[State alloc] initWithPlayer:player andOpponent:opponent andPhase:state] ;
			Card *cardPlayed;
			if(!(cardPlayed = [self cardForTarget:aTarget]))
				return nil;
			return [cardPlayed targets:farlockState];
		}
	return nil;
}

- (void)didDiscardCardAtTarget:(Target *)aTarget;
{
	NOT_IMPLEMENTED();
}

-(void)didTimeout;
{
	NOT_IMPLEMENTED();
}

#pragma mark -
#pragma mark ComunicatioLayer to Opponent methods


-(BOOL)willPlayOpponentCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget;
{
	//ND DoBs: now it is useless, but we will need it.
	// i.e. fare partire animazioni prima della gesture, presenta a fullscreen.

	return YES;
}

-(BOOL)didPlayOpponentCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget;
{	
	Card *aCard;
	if (!(aCard = [self cardForTarget:srcTarget]))
		return NO;
	
	//remove card from user's hand
	[opponent removeCardFromHand:aCard];
	
	if (dstTarget.type == TargetTypeOpponentPlayArea)
	{
		Card* otherCard = (Card*)[opponent.playArea objectAtIndex:dstTarget.position];
		if(!([otherCard class] == [NSNull class]) && aCard.type == CardTypeElement && otherCard == CardTypeElement)
		{
			//pass state change to comunication layer
			[self didPlayInstance:aCard onInstance:otherCard];			
			[interface discardFromTarget:srcTarget];
		}
		else
		{
			[opponent addCard:aCard toPosition:dstTarget];
		}
	}
	else if (dstTarget.type == TargetTypePlayerPlayArea && ([[player.playArea objectAtIndex:dstTarget.position] class] != [NSNull class]))
	{
		Card* otherCard = (Card*)[player.playArea objectAtIndex:dstTarget.position];
		if(!([otherCard class] == [NSNull class]) && aCard.type == CardTypeElement && otherCard.type == CardTypeElement && ![otherCard isEqual:aCard])
		{
			//pass state change to comunication layer
			[self didPlayInstance:aCard onInstance:otherCard];			
			[interface discardFromTarget:srcTarget];
		}
	}
	
	[interface opponentPlaysCard:aCard onTarget:dstTarget];
	
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

-(void)notifyDamage:(NSInteger)damage
{
	//TO CHANGE WHEN SUBTRACT WILL WORK!!!!!!
	[interface setHP:player.health player:PlayerKindPlayer];
	//[interface substractHP:damage player:PlayerKindPlayer];
}

-(void)notifyDamage:(NSInteger)damage toCard:(Card*)card;
{
	((Card*)[player.playArea objectAtIndex:[player.playArea indexOfObject:card]]).health+=-damage;
	
	/**************************************************
	 link to the interface method who update the health
	 **************************************************/
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

- (void)willSelectCardAtTarget:(Target *)aTarget;
{
	NOT_IMPLEMENTED();
}

- (void)didSelectCardAtTarget:(Target *)aTarget;
{
	NOT_IMPLEMENTED();
}

#pragma mark ComunicationLayer & Card methods

-(void)drawCardAtTarget:(Target*)srcTarget placedToTarget:(Target*)dstTarget playerKind:(PlayerKind)aKind;
{
	if (aKind == PlayerKindOpponent)
	{
		if (srcTarget.type == TargetTypeOpponentDeck)
		{
			[opponent.hand replaceObjectAtIndex:dstTarget.position withObject:[opponent.deck objectAtIndex:srcTarget.position]];
			[opponent.deck removeObjectAtIndex:srcTarget.position];
		}
		else if (srcTarget.type == TargetTypePlayerDeck)
		{
			[player.hand replaceObjectAtIndex:dstTarget.position withObject:[player.deck objectAtIndex:srcTarget.position]];
			[player.deck removeObjectAtIndex:srcTarget.position];
		}
		else
		{
			NOT_IMPLEMENTED();
		}
			
	}
	else
	{
		NOT_IMPLEMENTED();
	}
}

-(void)applyDamage:(NSInteger)damage fromCard:(Target*)fTarget playerKind:(PlayerKind)aKind;
{
	//TO CHANGE WHEN SUBTRACT WILL WORK!!!!!!	
	//[interface substractHP:damage player:PlayerKindPlayer];
	//*******************************************************
	if (aKind == PlayerKindPlayer)
	{
		player.health-=damage;
		[interface setHP:player.health player:aKind];
	}
	else
	{
		opponent.health-=damage;
		[interface setHP:opponent.health player:aKind];
	}
	
}

-(void)applyDamage:(NSInteger)damage fromCard:(Target*)fTarget toCard:(Target*)tTarget;
{
    Card *card;
	Card *otherCard;
	if (!(card = [self cardForTarget:fTarget]) || !(otherCard = [self cardForTarget:tTarget]))
		return;
	card.health -= damage;	
}

- (void)discardCardAtTarget:(Target *)aTarget;
{
	Card *card;
	if (!(card = [self cardForTarget:aTarget]))
		return;
	
	if (aTarget.type == TargetTypePlayerPlayArea || aTarget.type == TargetTypePlayerDeck ||
		aTarget.type == TargetTypePlayerCemetery || aTarget.type == TargetTypePlayerHand)
	{
		[player discardCardFromTarget:aTarget];
	}
	else if (aTarget.type == TargetTypeOpponentPlayArea || aTarget.type == TargetTypeOpponentDeck ||
			 aTarget.type == TargetTypeOpponentCemetery || aTarget.type == TargetTypeOpponentHand)
	{
		[opponent discardCardFromTarget:aTarget];
	}
	
}


@end

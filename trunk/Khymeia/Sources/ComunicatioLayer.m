//
//  ComunicatioLayer.m
//  Khymeia
//
//  Created by Alessio Bonu on 14/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "ComunicatioLayer.h"


@implementation ComunicatioLayer

@synthesize comLayer;

@synthesize gameplay;

-(id)init
{
	if (self = [super init])
	{
	}
	return self;
}

#pragma mark -
#pragma mark send methods 

-(BOOL)sendWillPlayCardAtTarget:(Target*)srcTarget onTarget:(Target*)dstTarget;
{
	[comLayer receiveWillPlayCardAtTarget:srcTarget onTarget:dstTarget];
	return YES;
}

-(BOOL)sendDidPlayCardAtTarget:(Target*)srcTarget onTarget:(Target*)dstTarget;
{
	[comLayer receiveDidPlayCardAtTarget:srcTarget onTarget:dstTarget];
	return YES;
}

-(void)sendStateChange:(NSInteger)state;
{
	[comLayer receiveStateChange:state];
}

-(void)sendPhaseChange:(NSInteger)phase;
{
	[comLayer receivePhaseChange:phase];
}

-(void)sendDrawCard:(Card*)card;
{
	[comLayer receiveDrawCard:card];
}

-(void) sendDamageToOpponent:(NSInteger)damage;
{
	[comLayer receiveDamageFromOpponent:damage];
}

-(void)sendDamage:(NSInteger)damage toCard:(Card*)card;
{
	[comLayer receiveDamage:damage onCard:card];
}

#pragma mark -
#pragma mark receive methods


-(void)receiveWillPlayCardAtTarget:(Target*)srcTarget onTarget:(Target*)dstTarget;
{
	[gameplay willPlayOpponentCardAtTarget:srcTarget onTarget:dstTarget];
	
}

-(void)receiveDidPlayCardAtTarget:(Target*)srcTarget onTarget:(Target*)dstTarget;
{
	[gameplay didPlayOpponentCardAtTarget:srcTarget onTarget:dstTarget];
}

-(void)receiveStateChange:(NSInteger)stato;
{
	[gameplay didOpponentPassStatus:stato];
}

/**
 receive a message from player that the opponent has changed phase
 */
-(void)receivePhaseChange:(NSInteger)fase;
{
	[gameplay didOpponentPassPhase:fase];
}
/**
 receive a message from player that the opponent has discarded a card
 */
-(void)receiveDrawCard:(Card*)card;
{
	[gameplay didOpponentDrawCard:card];
}

-(void) receiveDamageFromOpponent:(NSInteger)damage;
{
	[gameplay notifyDamage:damage];
}

-(void)receiveDamage:(NSInteger)damage onCard:(Card*)card;
{
	[gameplay notifyDamage:damage toCard:card];
}

@end

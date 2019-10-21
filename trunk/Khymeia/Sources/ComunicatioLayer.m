//
//  ComunicatioLayer.m
//  Khymeia
//
//  Created by Alessio Bonu on 14/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "ComunicatioLayer.h"
#define SERVERNAME  @"marco83.kicks-ass.org"
#define SERVERPORT 8281

@implementation ComunicatioLayer

@synthesize comLayer;

@synthesize gameplay;

-(id)init
{
	if (self = [super init])
	{
		asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
	}
	return self;
}
#pragma mark -
#pragma mark connection management

-(BOOL) connect;
{
	NSError *err = nil;
	if(![asyncSocket connectToHost:SERVERNAME onPort:SERVERPORT error:&err])
	{
		NSLog(@"Error: %@", err);
		return NO;
	}
	return YES;
}

-(void) disconnect;
{
	[asyncSocket disconnect];
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

-(void)sendDrawCardAtTarget:(Target*)srcTarget placedToTarget:(Target*)dstTarget playerKind:(PlayerKind)aKind;
{
	[comLayer receiveDrawCardAtTarget:srcTarget placedToTarget:dstTarget playerKind:aKind];
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
	Target * aTarget=[Target targetWithTarget:srcTarget];
	Target * bTarget=[Target targetWithTarget:dstTarget];
	[aTarget convertPointOfView];
	[bTarget convertPointOfView];	
	[gameplay willPlayOpponentCardAtTarget:aTarget onTarget:bTarget];
	
}

-(void)receiveDidPlayCardAtTarget:(Target*)srcTarget onTarget:(Target*)dstTarget;
{
	Target * aTarget=[Target targetWithTarget:srcTarget];
	Target * bTarget=[Target targetWithTarget:dstTarget];
	[aTarget convertPointOfView];
	[bTarget convertPointOfView];
	[gameplay didPlayOpponentCardAtTarget:aTarget onTarget:bTarget];
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
-(void)receiveDrawCardAtTarget:(Target*)srcTarget placedToTarget:(Target*)dstTarget playerKind:(PlayerKind)aKind;
{
	Target * aTarget=[Target targetWithTarget:srcTarget];
	Target * bTarget=[Target targetWithTarget:dstTarget];
	[aTarget convertPointOfView];
	[bTarget convertPointOfView];
	
	if (aKind == PlayerKindPlayer)
	{
		aKind = PlayerKindOpponent;
	}
	else
	{
		aKind = PlayerKindPlayer;
	}
	
	[gameplay drawCardAtTarget:aTarget placedToTarget:bTarget playerKind:aKind];
}

-(void) receiveDamageFromOpponent:(NSInteger)damage;
{
	[gameplay notifyDamage:damage];
}

-(void)receiveDamage:(NSInteger)damage onCard:(Card*)card;
{
	[gameplay notifyDamage:damage toCard:card];
}

-(void)dealloc
{
	[super dealloc];
	[asyncSocket release];
}

@end

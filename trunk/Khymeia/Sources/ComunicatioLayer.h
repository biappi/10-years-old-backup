//
//  ComunicatioLayer.h
//  Khymeia
//
//  Created by Alessio Bonu on 14/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Game.h"
#import "Player.h"
#import "ComunicationToGameplayProtocol.h"
#import "ComunicatioLayer.h"
#import "AsyncSocket.h"


@interface ComunicatioLayer : NSObject 
{
	/**
	 pointer to my gameplay
	 */
	Game *gameplay;
	
	/**
	 pointer to opponent comunication Layer
	 */
	ComunicatioLayer *comLayer;
	
	/**
	 the socket manager
	 */
	AsyncSocket *asyncSocket;
}

@property (nonatomic, retain) ComunicatioLayer *comLayer;
@property (nonatomic, retain) Game *gameplay;

/**
 Open the connectio with the server
 return YES if connection is open
 NO otherwise
 */
-(BOOL) connect;

/**
 dsconnect from the server
 */

-(void) disconnect;

/**
 send a message to opponent that a card is played on a specific target
 \param aCard: the card that player will play
 \param aTarget: the target on which the card will played
 \return YES if message is sent. NO otherwise
 */

-(BOOL)sendWillPlayCardAtTarget:(Target*)srcTarget onTarget:(Target*)dstTarget;

/**
 send a message to opponent that a card is played on a specific target
 \param aCard: the played card
 \param aTarget: the target on which the card is played
 \return YES if message is sent. NO otherwise
 */
-(BOOL)sendDidPlayCardAtTarget:(Target*)srcTarget onTarget:(Target*)dstTarget;

/**
 send a message to opponent that player has changed status
 /param state: the new state
 */
-(void)sendStateChange:(NSInteger)state;

/**
 send a message to opponent that player has changed phase
 /param phase: the new phase
 */
-(void)sendPhaseChange:(NSInteger)phase;

/**
 send a message to opponent that player has discarded a card
 /param card: the discarded card
 */
-(void)sendDrawCardAtTarget:(Target*)srcTarget placedToTarget:(Target*)dstTarget playerKind:(PlayerKind)aKind;

/**
 send a message in wich player notify to the opponent that he receives a damage
 /param damage: the damage received from opponent
 */
-(void) sendDamageToOpponent:(NSInteger)damage;


/**
 send a message in wich player notify to the opponent that a card has been damaged 
 /param damage: the damage
 /param card: the card damaged
 */
-(void)sendDamage:(NSInteger)damage toCard:(Card*)card;

/**
 receive a message from player that a card is played on a target
 \param aCard: the card that player will play
 \param aTarget: the target on which the card will played
 */
-(void)receiveWillPlayCardAtTarget:(Target*)srcTarget onTarget:(Target*)dstTarget;

/**
 receive a message from player that a card is played on a specific target
 \param aCard: the played card
 \param aTarget: the target on which the card is played
 \return YES if message is sent. NO otherwise
 */
-(void)receiveDidPlayCardAtTarget:(Target*)srcTarget onTarget:(Target*)dstTarget;

/**
 receive a message from player that the opponent has changed status
 */
-(void)receiveStateChange:(NSInteger)state;

/**
 receive a message from player that the opponent has changed phase
 */
-(void)receivePhaseChange:(NSInteger)phase;

/**
 receive a message from player that the opponent has discarded a card
 */
-(void)receiveDrawCardAtTarget:(Target*)srcTarget placedToTarget:(Target*)dstTarget playerKind:(PlayerKind)aKind;

/**
 receive a message in wich opponent notify to the player that he receives a damage
 /param damage: the damage received from player
 */
-(void) receiveDamageFromOpponent:(NSInteger)damage;

/**
 receive a message in wich opponent notify a damage to a card
 /param damage: the damage
 /param card: the card attacked
 */
-(void)receiveDamage:(NSInteger)damage onCard:(Card*)card;

@end

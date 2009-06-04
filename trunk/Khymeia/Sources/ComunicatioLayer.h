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


@interface ComunicatioLayer : NSObject 
{
	/**
	 pointer to my gameplay
	 */
	id<ComunicationToGameplayProtocol> gameplay;
	
	/**
	 pointer to opponent comunication Layer
	 */
	ComunicatioLayer *comLayer;
}

@property (nonatomic, retain) ComunicatioLayer *comLayer;
@property (nonatomic, retain) id gameplay;

/**
 send a message to opponent that a card is played on a specific target
 \param aCard: the card that player will play
 \param aTarget: the target on which the card will played
 \return YES if message is sent. NO otherwise
 */

-(BOOL)sendWillPlayCard:(Card*)aCard onTarget:(id)aTarget;

/**
 send a message to opponent that a card is played on a specific target
 \param aCard: the played card
 \param aTarget: the target on which the card is played
 \return YES if message is sent. NO otherwise
 */
-(BOOL)sendDidPlayCard:(Card*)aCard onTarget:(id)aTarget;

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
-(void)sendDrawCard:(Card *)card;

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
-(void)receiveWillPlayCard:(Card*)aCard onTarget:(id)aTarget;

/**
 receive a message from player that a card is played on a specific target
 \param aCard: the played card
 \param aTarget: the target on which the card is played
 \return YES if message is sent. NO otherwise
 */
-(void)receiveDidPlayCard:(Card*)aCard onTarget:(id)aTarget;

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
-(void)receiveDrawCard:(Card*)card;

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

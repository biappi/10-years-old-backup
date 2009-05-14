//
//  ComunicatioLayer.h
//  Khymeia
//
//  Created by Alessio Bonu on 14/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
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
 send a message to opponent that a card is played 
 \param aCard: the played card
 \return YES if message is sent. NO otherwise
 */

-(BOOL)sendWillPlayCard:(Card*)aCard;

/**
 send a message to opponent that a card will played on a card
 \param aCard: the played card
 \return YES if message is sent. NO otherwise
 */

-(BOOL)sendDidPlayCard:(Card*)aCard;



/**
 send a message to opponent that a card is played on a card
 \param card: the played card
 \param onCard: the card on which card is played
 \return YES if message is sent. NO otherwise
 */
-(BOOL)sendDidPlayCard:(Card*)card onCard:(Card*)onCard;

/**
 send a message to opponent that a card is played on a player
 \param card: the played card
 \param onPlayer: the player on which card is played
 \return YES if message is sent. NO otherwise
 */
-(BOOL)sendDidPlayCard:(Card*)card onPlayer:(Player *)player;

/**
 send a message to opponent that a card is played on a card with gesture
 \param card: the played card
 \param onCard: the card on which card is played
 \param completed: is set to YES if gesture is completed by the player, NO otherwise
 \return YES if message is sent. NO otherwise
 */

-(BOOL)sendDidPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;

/**
 send a message to opponent that a card will played on a card
 \param card: the played card
 \param onCard: the card on which card is played
 \return YES if message is sent. NO otherwise
 */
-(BOOL)sendWillPlayCard:(Card*)card onCard:(Card*)onCard;

/**
 send a message to opponent that a card will played on a player
 \param card: the played card
 \param onPlayer: the player on which card is played
 \return YES if message is sent. NO otherwise 
 */
-(BOOL)sendWillPlayCard:(Card*)card onPlayer:(Player *)player;
/*NOT YET IMPLEMENTED
-(BOOL)sendWillPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
*/


/**
 receive a message to opponent that a card is played on a card
 \param aCard: the played card
 \param onCard: the card on which card is played
 */
-(void)receiveWillPlayCard:(Card*)aCard;

/**
 receive a message to opponent that a card will played on a card
 \param aCard: the played card
 \param onCard: the card on which card will be played
 */
-(void)receiveDidPlayCard:(Card*)aCard;



/**
 receive a message to opponent that a card is played on a card
 \param card: the played card
 \param onCard: the card on which card is played
 */
-(void)receiveDidPlayCard:(Card*)card onCard:(Card*)onCard;

/**
 receive a message to opponent that a card is played on a player
 \param card: the played card
 \param onPlayer: the player on which card is played
 */
-(void)receiveDidPlayCard:(Card*)card onPlayer:(Player *)player;

/**
 receive a message to opponent that a card is played on a card with gesture
 \param card: the played card
 \param onCard: the card on which card is played
 \param completed: is set to YES if gesture is completed by the player, NO otherwise
*/
-(void)receiveDidPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;

/**
 receive a message to opponent that a card will played on a card
 \param card: the played card
 \param onCard: the card on which card will be played
 */
-(void)receiveWillPlayCard:(Card*)card onCard:(Card*)onCard;

/**
 receive a message to opponent that a card will played on a card
 \param card: the played card
 \param onPlayer: the player on which card will be played
 */
-(void)receiveWillPlayCard:(Card*)card onPlayer:(Player *)player;
/*NOT YET IMPLEMENTED
-(void)receiveWillPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
*/
@end

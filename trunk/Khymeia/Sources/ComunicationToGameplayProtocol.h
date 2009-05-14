//
//  ComunicationToGameplayProtocol.h
//  Khymeia
//
//  Created by Luca Bartoletti on 14/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Player.h"

@protocol ComunicationToGameplayProtocol

/**
 Called by the comunication interface when user would play the card
 \param aCard: card that opponent has played
 \return YES if the could be played, NO otherwise
 */
-(BOOL)willPlayOpponentCard:(Card*)aCard;

/**
 Called by the comunication interface when user has played the card
 \param aCard: card that opponent has played
 \return YES if the could be played, NO otherwise
 */
-(BOOL)didPlayOpponentCard:(Card*)aCard;

/**
 Called by the comunication interface when user would play the card
 \param aCard: card that opponent has played
 \param otherCard: card on which is played aCard
 \return YES if the could be played, NO otherwise
 */
-(BOOL)willPlayOpponentCard:(Card*)aCard onCard:(Card*)otherCard;

/**
 Called by the comunication interface when user has played the card
 \param aCard: card that opponent has played
 \param otherCard: card on which is played aCard
 \return YES if the could be played, NO otherwise
 */
-(BOOL)didPlayOpponentCard:(Card*)aCard onCard:(Card*)otherCard;

/**
 Called by the comunication interface when user would play the card at position
 \param aCard: card that user would play
 \param aPlayer: the player on which aCard will played
 \return YES if the could be played, NO otherwise
 */
-(BOOL)willPlayOpponentCard:(Card*)aCard atPlayer:(Player*)aPlayer;

/**
 Called by the comunication interface when the user did play card at position
 \param aCard: card that user have played
 \param aPlayer: the player on which aCard is played
 */
-(BOOL)didPlayOpponentCard:(Card*)aCard atPlayer:(Player*)aPlayer;

/**
 Called by the comunication interface when the user did play card at position with a gesture
 \param aCard: card that user would play
 \param otherCard: the target card
 \param result: YES if gesture was complete, NO otherwise.
 */
-(BOOL)didPlayOpponentCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;

@end

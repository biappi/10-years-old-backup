//
//  ComunicationToGameplayProtocol.h
//  Khymeia
//
//  Created by Luca Bartoletti on 14/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "TableTarget.h"

@protocol ComunicationToGameplayProtocol

/**
 Called by the comunication interface when user would play the card
 \param aCard: card that opponent has played
 \return YES if the could be played, NO otherwise
 */
-(BOOL)willPlayOpponentCard:(Card*)aCard onTarget:(TableTarget*)aTarget;

/**
 Called by the comunication interface when user has played the card
 \param aCard: card that opponent has played
 \return YES if the could be played, NO otherwise
 */
-(BOOL)didPlayOpponentCard:(Card*)aCard onTarget:(TableTarget*)aTarget;

/**
 Opponent  passed phase
 */
-(NSInteger)didOpponentPassPhase:(NSInteger)phase;

/**
 opponent changed status
 */
-(NSInteger)didOpponentPassStatus:(NSInteger)state;

/**
 opponent draw a card
 */
-(Card*)didOpponentDrawCard:(Card*)card;

@end

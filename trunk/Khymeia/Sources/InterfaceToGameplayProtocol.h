//
//  InterfaceToGameplayProtocol.h
//  Khymeia
//
//  Created by Luca Bartoletti on 14/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableTarget.h"
#import "Card.h"



@protocol InterfaceToGameplayProtocol

/**
Called by the interface when user would play the card on a target (see target class)
\param aCard: card that user would play
\param aTarget: the target witch aCard will play
*/
-(void)willPlayCard:(Card*)aCard onTarget:(id)aTarget;

/**
Called by the interface when the user did play card
\param aCard: card that user have played
\param aTarget: the target witch aCard is played
*/
-(void)didPlayCard:(Card*)aCard onTarget:(id)aTarget withGesture:(BOOL)completed;

/**
Called by the interface when would to know where aCard is playable
\param aCard: the card 
\return an array of game elements where aCard is playable
*/
-(NSArray*)targetsForCard:(Card*)aCard;

/**
Called by the interface when user would select the card
\param aCard: card that user would select
*/
-(void)willSelectCard:(Card*)aCard;

/**
Called by the interface when the user did select card
\param aCard: card that user have selected
*/
-(void)didSelectCard:(Card*)aCard;

/**
Ask to next
\param idTurn: turn identifier 
\return YES if the user can pass to the next phase, NO otherwise
*/
-(BOOL)shouldPassNextPhase;

/**
 A card did discard
 */
-(void)didDiscardCard:(Card*)aCard;

/**
 timeout event
 */
-(void)didTimeout;

@end


//
//  InterfaceToGameplayProtocol.h
//  Khymeia
//
//  Created by Luca Bartoletti on 14/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Target.h"
#import "Card.h"

@protocol InterfaceToGameplayProtocol

/**
 Called by the interface when user would play the card (located in srcTarget) on a dstTarget
 \param srcTarget: target from where user would play
 \param dstTarget: the target witch element in srcTarget will play
 */
- (void)willPlayCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget;

/**
 Called by the interface when the user did play card from srcTarget
 \param srcTarget: target from where card that user have played
 \param dstTarget: the target witch element in srcTarget have played
 \param completed: YES if gesture is completed, NO otherwise
 \return an array of game elements where aCard is playable
 */
- (void)didPlayCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget withGesture:(BOOL)completed;

/**
 Called by the interface when would to know where aCard is playable
 \param aCard: the card 
 \return an array of game elements where aCard is playable
 */
- (NSArray *)targetsForCardAtTarget:(Target *)aTarget;

/**
 Called by interface when user did select aTarget
 \param aTarget: the target did select
 */
- (void)didSelectCardAtTarget:(Target *)aTarget;

/**
 Called by interface when user did discard the element on aTarget
 \param aTarget: the target did select for discard
 */
- (void)didDiscardCardAtTarget:(Target *)aTarget;

/**
Ask to next
\param idTurn: turn identifier 
\return YES if the user can pass to the next phase, NO otherwise
*/
-(BOOL)shouldPassNextPhase;


/**
 timeout event
 */
-(void)didTimeout;

@end


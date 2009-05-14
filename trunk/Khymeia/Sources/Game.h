//
//  Game.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Player.h"
#import "Table.h"

/**
 this enum represent all the state in which the game can be
 */
typedef enum
{
	GameStateSetup,
	GameStatePlayer,
	GameStateOpponent,
	GameStateEnd
}GameState;


/**
  this enum represent all the phase in which the game can be
 */
typedef enum
{
	GamePhaseCardAttainment,
	GamePhaseMainphase,
	GamePhaseAttack,
	GamePhaseDamageResolution,
	GamePhaseDiscard,
	GamePhaseNone
}GamePhase;

@interface Game : NSObject 
{
	Table		*table;
	Player		*player;
	Player		*opponent;
	bool		isFirst;
	
	NSInteger	state;
	NSInteger	phase;
}

/**
 Called by the interface when user would play the card at position. Interface should show aCard at fullscreen
 
 \param aPlayer: a player instance represent the user
 \param aOpponent: a player instance represent the opponent to the user
 \return a valid instance of Game, nil otherwise
 */
-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;

/**
 Called by the interface when user would play the card at position. Interface should show aCard at fullscreen
 
 \param aCard: card that user would play
 \param otherCard: the target card
 \return YES if the could be played, NO otherwise
 */
-(BOOL)willPlayCard:(Card*)aCard onCard:(Card*)otherCard;

/**
 Called by the interface when the user did play card at position.
 \param aCard: card that user would play
 \param otherCard: the target card
 \param result: YES if gesture was complete, NO otherwise.
 */
-(void)didPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;

/**
 Called by the interface when user would play the card at position
 \param aCard: card that user would play
 \param aPlayer: the player on which aCard will played
 \return YES if the could be played, NO otherwise
 */
-(BOOL)willPlayCard:(Card*)aCard atPlayer:(Player*)aPlayer;

/**
 Called by the interface when the user did play card at position
 \param aCard: card that user have played
 \param aPlayer: the player on which aCard is played
 */
-(void)didPlayCard:(Card*)aCard atPlayer:(Player*)aPlayer;

/**
 Called by the interface when user would play the card
 \param aCard: card that user would play
 \return YES if the could be played, NO otherwise
 */
-(BOOL)willPlayCard:(Card*)aCard;

/**
 Called by the interface when the user did play card
 \param aCard: card that user have played
 */
-(void)didPlayCard:(Card*)aCard;

/**
 Called by the interface when user would select the card
 \param aCard: card that user would select
 \return YES if the could be selected, NO otherwise
 */
-(BOOL)willSelectCard:(Card*)aCard;

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

/**
 Called by the comunication interface when user would play the card
 \param aCard: card that opponent has played
 */
-(void)willPlayOpponentCard:(Card*)aCard;

@end

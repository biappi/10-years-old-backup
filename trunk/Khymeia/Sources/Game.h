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
#import "InterfaceController.h"
#import "InterfaceToGameplayProtocol.h"
#import "ComunicationToGameplayProtocol.h"

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

@interface Game : NSObject <InterfaceToGameplayProtocol, ComunicationToGameplayProtocol>
{
	Table					*table;
	Player					*player;
	Player					*opponent;
	bool					isFirst;
	InterfaceController*	interface;
	
	
	NSInteger				state;
	NSInteger				phase;
}

@property (nonatomic, readonly) InterfaceController *interface;

-(void)setupState;

/**
 Called by the interface when user would play the card at position. Interface should show aCard at fullscreen
 
 \param aPlayer: a player instance represent the user
 \param aOpponent: a player instance represent the opponent to the user
 \return a valid instance of Game, nil otherwise
 */
-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;


@end

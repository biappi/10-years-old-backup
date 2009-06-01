//
//  GameState.h
//  Khymeia
//
//  Created by Luca Bartoletti on 14/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>

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
	GamePhaseAttackOpponent,
	GamePhaseAttackPlayer,
	GamePhaseDamageResolution,
	GamePhaseDiscard,
	GamePhaseNone
}GamePhase;

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
#import "GameState.h"
//#import "TableTarget.h"

@class ComunicatioLayer;

@interface Game : NSObject <InterfaceToGameplayProtocol, ComunicationToGameplayProtocol>
{
	Table					*table;
	Player					*player;
	Player					*opponent;
	BOOL					isFirst;
	InterfaceController*	interface;
	ComunicatioLayer *      comunication; //is the link to the comunication layer
	
	NSInteger				state;
	NSInteger				phase;
	
	//used for determinate if is first turn in attack phase
	BOOL					isFirstTurn;
	
	//discard phase flag
	BOOL					playerDidDiscard;
	
	//attack phase flags
	BOOL					waitingForOpponentAttack;
	BOOL					playerDidAttack;
	
	//opponent attack phase flag
	BOOL					opponentDidAttack;
	
}

@property (nonatomic, assign) InterfaceController * interface;
@property (nonatomic, retain)   ComunicatioLayer   *comunication;

-(void)setupState;

-(void)start;

/**
 Called by the interface when user would play the card at position. Interface should show aCard at fullscreen
 
 \param aPlayer: a player instance represent the user
 \param aOpponent: a player instance represent the opponent to the user
 \return a valid instance of Game, nil otherwise
 */
-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;


@end

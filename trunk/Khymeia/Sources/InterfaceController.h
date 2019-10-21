//
//  InterfaceController.h
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 12/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceToGameplayProtocol.h"
#import "Player.h"
#import "Card.h"
#import "GameState.h"
#import "CardLayer.h"
#import "TableLayer.h"
typedef enum 
{
	InterfaceModesOpponentCardHidden,
	InterfaceModesOpponentCardNotHidden,
	InterfaceModesOpponentPlayArea,
	InterfaceModesOpponentDeck,
	InterfaceModesOpponentCemetery,
	InterfaceModesPlayerCardHidden,
	InterfaceModesPlayerCardNotHidden,
	InterfaceModesPlayerPlayArea,
	InterfaceModesPlayerDeck,
	InterfaceModesPlayerCemetery,
} InterfaceModes;

@interface InterfaceController : UIViewController
{
	// TODO: maybe "HealthPoints" is too redundant
	//       we can rename it "playerHPLabel"?
	
	IBOutlet UILabel * playerHealthPointsLabel;
	IBOutlet UILabel * opponentHealthPointsLabel;

	NSArray          * playerPlayAreaSlots;
	NSArray          * opponentPlayAreaSlots;
	NSArray          * playerHandSlots;	
	
	TableLayer		 * tableLayer;
	CardLayer        * currentlyMovingCard;
	CGPoint            currentlyMovingCardOriginalPosition;
	Target           * currentlyMovingCardTarget;
	
	UIButton		 * turnEnded;
	NSMutableArray   * playerHand;
	NSMutableArray   * playerPlayArea;
	NSMutableArray   * opponentPlayArea;
	NSArray			 * currentTargets;
	GameState		   currentState;
	BOOL               interfaceIsBusy;
	BOOL			   selectionCardPhase;
	
	id<InterfaceToGameplayProtocol>	 gameplay;
}

@property (nonatomic, assign) BOOL interfaceIsBusy; // <- return YES to prevent the scroller to kick in
@property (nonatomic, retain) id<InterfaceToGameplayProtocol> gameplay;

#pragma mark Gameplay To Interface

- (void) setState:(GameState) turn;
- (void) setPhase:(GamePhase) phase;
- (void) gameDidEnd:(BOOL)youWin;

- (void) beginPhaseTimer:(NSTimeInterval)timeout;

- (void) setHP:(int)newHP player:(PlayerKind)thePlayer;
- (void) substractHP:(int)newHP player:(PlayerKind)thePlayer;
- (void) addHP:(int)newHP player:(PlayerKind)thePlayer;

- (void) drawCard:(Card *)card toTarget:(Target *)target;

- (void) discardFromTarget:(Target *)target;

/*
- (void) playCard:(Card *)card;
- (void) playCard:(Card *)card overCard:(Card *)card;
- (void) playCard:(Card *)card overPlayer:(Player *)player;
*/

- (void) opponentPlaysCard:(Card *)card onTarget:(Target *) target;

// not sure if this is really needed in with new target types

- (void) takeCard:(Card *)card from:(InterfaceModes)interfaceMode;
- (void) setInterfaceMode:(InterfaceModes)mode;

- (void) serverTimeout;
- (void) serverError;

@end

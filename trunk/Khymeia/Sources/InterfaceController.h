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
	IBOutlet UILabel * playerHealthPointsLabel;
	IBOutlet UILabel * opponentHealthPointsLabel;

	CALayer          * currentlyMovingCard;
	CGPoint            currentlyMovingCardOriginalPosition;
	UIButton		 * turnEnded;
	NSMutableArray   * playerHand;
	NSMutableArray   * playerPlayArea;
	NSMutableArray   * opponentPlayArea;
	NSArray			 * currentTargets;
	
	BOOL               interfaceIsBusy;
	
	id<InterfaceToGameplayProtocol>	 gameplay;
}

@property (nonatomic, assign) BOOL interfaceIsBusy; // <- return YES to prevent the scroller to kick in
@property (nonatomic, retain) id<InterfaceToGameplayProtocol> gameplay;

#pragma mark Gameplay To Interface

- (void) setState:(GameState) turn;
- (void) setPhase:(GamePhase) phase;
- (void) gameDidEnd:(BOOL)youWin;

- (void) beginPhaseTimer:(NSTimeInterval)timeout;

- (void) setHP:(int)newHP player:(Player *)thePlayer;
- (void) substractHP:(int)newHP player:(Player *)thePlayer;
- (void) addHP:(int)newHP player:(Player *)thePlayer;

- (void) drawCard:(Card *)card;
- (void) discardFromHand:(Card *)card;
- (void) discardFromPlayArea:(Card *)card;
/*
- (void) playCard:(Card *)card;
- (void) playCard:(Card *)card overCard:(Card *)card;
- (void) playCard:(Card *)card overPlayer:(Player *)player;
*/
- (void) opponentPlaysCard:(Card *)card onTarget:(TableTarget *) target;

- (void) takeCard:(Card *)card from:(InterfaceModes)interfaceMode;
- (void) setInterfaceMode:(InterfaceModes)mode;

- (void) serverTimeout;
- (void) serverError;

@end

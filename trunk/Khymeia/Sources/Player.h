//
//  Player.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Target.h"

typedef enum {
	PlayerKindPlayer,
	PlayerKindOpponent,
	PlayerKindBoth,
} PlayerKind;

@interface Player : NSObject
{
	NSString            *name;
	/**
	 the password is the MD5 code of the password
	 */
	NSString		    *psw;
	NSInteger           health;
	NSMutableArray      *deck;
	NSMutableArray      *hand;
	NSMutableArray      *cemetery;
	NSMutableArray		*playArea;
}


@property(nonatomic, retain)   NSString	    	*name;
@property(nonatomic, retain)   NSString	        *psw;
@property(nonatomic, assign)   NSInteger		health;
@property(nonatomic, retain) NSMutableArray     *deck;
@property(nonatomic, retain) NSMutableArray     *hand;
@property(nonatomic, retain) NSMutableArray     *cemetery;
@property(nonatomic, retain) NSMutableArray     *playArea;

+(id)playerWithPlayer:(Player*)aPlayer;

-(id) initWithHand:(NSMutableArray*)aHand;

-(id) initWithHand:(NSMutableArray*)aHand playArea:(NSMutableArray*)aPlayArea;

/**
 Ask to player if aCard is in hand
 /return YES if aCard belong to is hand, NO otherwise
 */
-(BOOL)isCardInHand:(Card*)aCard;

/**
Remove a card form player's hand
 /return YES if aCard was removed, NO otherwise
 */
-(BOOL)removeCardFromHand:(Card*)aCard;

// ---- For GamePlay
-(NSArray *)playAreaFreePositions;

// ---- For Interface

- (void)addCard:(Card *)aCard toPosition:(Target *)aTarget;

- (void)discardCardFromTarget:(Target *)aTarget;

@end


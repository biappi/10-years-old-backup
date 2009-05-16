//
//  Player.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Player : NSObject
{
	NSString            *name;
	NSInteger           health;
	NSMutableArray      *deck;
	NSMutableArray      *hand;
	NSMutableArray      *cemetery;
}

@property(nonatomic, retain) NSString			*name;
@property(nonatomic, assign) NSInteger			health;
@property(nonatomic, retain) NSMutableArray     *deck;
@property(nonatomic, retain) NSMutableArray     *hand;
@property(nonatomic, retain) NSMutableArray     *cemetery;

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

@end


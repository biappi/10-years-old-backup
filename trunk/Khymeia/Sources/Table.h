//
//  Table.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "TableTarget.h"

@interface Table : NSObject
{
	NSMutableArray * playerPlayArea;
	NSMutableArray * opponentPlayArea;
}

@property(nonatomic, readonly) NSMutableArray * playerPlayArea;
@property(nonatomic, readonly) NSMutableArray * opponentPlayArea;

// ---- For GamePlay

- (NSArray *)opponentFreePositions;
- (NSArray *)playerFreePositions;

// ---- For Interface

- (void)addCard:(Card *)aCard toPosition:(Target *)aTarget;
- (void)discardCardFromPosition:(Target *)aTarget;

@end

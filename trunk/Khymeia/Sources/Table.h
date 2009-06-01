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
	NSArray * playerPlayArea;
	NSArray * opponentPlayArea;
}

@property (nonatomic, retain) Card* card1;
@property (nonatomic, retain) Card* card2;
@property (nonatomic, retain) Card* card3;
@property (nonatomic, retain) Card* card4;

@property (nonatomic, retain) Card* cardOpponent1;
@property (nonatomic, retain) Card* cardOpponent2;
@property (nonatomic, retain) Card* cardOpponent3;
@property (nonatomic, retain) Card* cardOpponent4;

@property (nonatomic, readonly) NSArray *playerCards;
@property (nonatomic, readonly) NSArray *opponentCards;

-(NSArray*)opponentFreePositions;
-(NSArray*)playerFreePositions;

-(void)discardCardFromPosition:(TableTarget*)aTarget;
-(void)addCard:(Card*)aCard toPosition:(TableTarget*)aTarget;

@end

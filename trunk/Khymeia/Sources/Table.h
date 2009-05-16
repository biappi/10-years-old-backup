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
	Card* card1;
	Card* card2;
	Card* card3;
	Card* card4;
	Card* cardOpponent1;
	Card* cardOpponent2;
	Card* cardOpponent3;
	Card* cardOpponent4;
	
	NSArray *playerCards;
	NSArray *opponentCards;
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

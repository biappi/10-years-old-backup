//
//  Table.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Table.h"


@implementation Table

@synthesize card1;
@synthesize card2;
@synthesize card3;
@synthesize card4;
@synthesize cardOpponent1;
@synthesize cardOpponent2;
@synthesize cardOpponent3;
@synthesize cardOpponent4;


-(NSArray*)opponentFreePositions;
{
	NSMutableArray *positions = [[NSMutableArray alloc] init];
	if (self.cardOpponent1)
		[positions addObject:[[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:1] autorelease]];
	if (self.cardOpponent2)
		[positions addObject:[[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:2] autorelease]];
	if (self.cardOpponent3)
	    [positions addObject:[[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:3] autorelease]];
	if (self.cardOpponent4)
		[positions addObject:[[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:4] autorelease]];
    return [positions autorelease];	
}

-(NSArray*)playerFreePositions;
{
	NSMutableArray *positions = [[NSMutableArray alloc] init];
	if (!self.card1)
		[positions addObject:[[[TableTarget alloc] initwithTable:TableTargetTypePlayer andPosition:1] autorelease]];
	if (!self.card2)
		[positions addObject:[[[TableTarget alloc] initwithTable:TableTargetTypePlayer andPosition:2] autorelease]];
    if (!self.card3)
		[positions addObject:[[[TableTarget alloc] initwithTable:TableTargetTypePlayer andPosition:3] autorelease]];
	if (!self.card4)
		[positions addObject:[[[TableTarget alloc] initwithTable:TableTargetTypePlayer andPosition:4] autorelease]];
    return [positions autorelease];
}

-(NSArray*)playerCards;
{
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	if (self.card1)
		[cards addObject:self.card1];
	if (self.card2)
		[cards addObject:self.card2];
    if (self.card3)
		[cards addObject:self.card3];
	if (self.card4)
		[cards addObject:self.card4];
    return [cards autorelease];
}

-(NSArray*)opponentCards;
{
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	if (self.cardOpponent1)
		[cards addObject:self.cardOpponent1];
	if (self.cardOpponent2)
		[cards addObject:self.cardOpponent2];
	if (self.cardOpponent3)
	    [cards addObject:self.cardOpponent3];
	if (self.cardOpponent4)
		[cards addObject:self.cardOpponent4];
    return [cards autorelease];	
}

-(void)discardCardFromPosition:(TableTarget*)aTarget;
{
	if (aTarget.table == TableTargetTypePlayer)
	{
		switch(aTarget.position)
		{
			case 1:
				self.card1 = nil;
				break;
			case 2:
				self.card2 = nil;
				break;
			case 3:
				self.card3 = nil;
				break;
			case 4:
				self.card4 = nil;
				break;
			default:
				NSLog(@"Unexpected case in -(void)discardCardFromTableTarget:(TableTarget*)aTarget;");
				break;
		}
	}
	else if (aTarget.table == TableTargetTypeOpponent)
	{
		switch(aTarget.position)
		{
			case 1:
				self.cardOpponent1 = nil;
				break;
			case 2:
				self.cardOpponent2 = nil;
				break;
			case 3:
				self.cardOpponent3 = nil;
				break;
			case 4:
				self.cardOpponent4 = nil;
				break;
			default:
				NSLog(@"Unexpected case in -(void)discardCardFromTableTarget:(TableTarget*)aTarget;");
				break;
		}
	}
	else
	{
		NSLog(@"Unexpected case in -(void)discardCardFromTableTarget:(TableTarget*)aTarget;");
	}
}

-(void)addCard:(Card*)aCard toPosition:(TableTarget*)aTarget;
{
	if (aTarget.table == TableTargetTypePlayer)
	{
		switch(aTarget.position)
		{
			case 1:
				self.card1 = aCard;
				break;
			case 2:
				self.card2 = aCard;
				break;
			case 3:
				self.card3 = aCard;
				break;
			case 4:
				self.card4 = aCard;
				break;
			default:
				NSLog(@"Unexpected case in -(void)addCard:(Card*)aCard toPosition:(TableTarget*)aTarget;");
				break;
		}
	}
	else if (aTarget.table == TableTargetTypeOpponent)
	{
		switch(aTarget.position)
		{
			case 1:
				self.cardOpponent1 = aCard;
				break;
			case 2:
				self.cardOpponent2 = aCard;
				break;
			case 3:
				self.cardOpponent3 = aCard;
				break;
			case 4:
				self.cardOpponent4 = aCard;
				break;
			default:
				NSLog(@"Unexpected case in -(void)addCard:(Card*)aCard toPosition:(TableTarget*)aTarget");
				break;
		}
	}
	else
	{
		NSLog(@"Unexpected case in -(void)addCard:(Card*)aCard toPosition:(TableTarget*)aTarget;");
	}
	
}


-(void)dealloc;
{
	[card1 release];
	[card2 release];
	[card3 release];
	[card4 release];
	[cardOpponent1 release];
	[cardOpponent2 release];
	[cardOpponent3 release];
	[cardOpponent4   release];
	[super dealloc];
}

@end

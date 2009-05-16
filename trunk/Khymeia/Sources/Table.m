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


-(NSArray*)opponentFreePosisitions;
{
	NSMutableArray *positions = [[NSMutableArray alloc] init];
	if (self.cardOpponent1)
		[positions addObject:[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:1]];
	if (self.cardOpponent2)
		[positions addObject:[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:2]];
	if (self.cardOpponent3)
	    [positions addObject:[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:3]];
	if (self.cardOpponent4)
		[positions addObject:[[TableTarget alloc] initwithTable:TableTargetTypeOpponent andPosition:3]];
    return [positions autorelease];	
}

-(NSArray*)playerFreePosisitions;
{
	NSMutableArray *positions = [[NSMutableArray alloc] init];
	if (self.card1)
		[positions addObject:[[TableTarget alloc] initwithTable:TableTargetTypePlayer andPosition:1]];
	if (self.card2)
		[positions addObject:[[TableTarget alloc] initwithTable:TableTargetTypePlayer andPosition:2]];
    if (self.card3)
		[positions addObject:[[TableTarget alloc] initwithTable:TableTargetTypePlayer andPosition:3]];
	if (self.card4)
		[positions addObject:[[TableTarget alloc] initwithTable:TableTargetTypePlayer andPosition:4]];
    return [positions autorelease];
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

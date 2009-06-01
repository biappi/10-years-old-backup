//
//  Table.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Table.h"

@implementation Table

@synthesize playerPlayArea;
@synthesize opponentPlayArea;

- (id)init;
{
	if ((self = [super init]) == nil)
		return nil;
	
	playerPlayArea   = [[NSMutableArray alloc] initWithCapacity:4];
	opponentPlayArea = [[NSMutableArray alloc] initWithCapacity:4];
	
	for (int i = 0; i < 4; i++)
	{
		[playerPlayArea   addObject:[NSNull null]];
		[opponentPlayArea addObject:[NSNull null]];
	}
	
	return self;
}

- (void)dealloc;
{
	[playerPlayArea release];
	[opponentPlayArea release];
	[super dealloc];
}

- (NSArray *)opponentFreePositions;
{
	NSMutableArray * ret = [NSMutableArray arrayWithCapacity:4];
	
	for (int i = 0; i < 4; i++)
		if ([opponentPlayArea objectAtIndex:i] == [NSNull null])
			[ret addObject:[Target targetWithType:TargetTypeOpponentPlayArea position:i]];

	return [NSArray arrayWithArray:ret];
}

- (NSArray *)playerFreePositions;
{
	NSMutableArray * ret = [NSMutableArray arrayWithCapacity:4];
	
	for (int i = 0; i < 4; i++)
		if ([playerPlayArea objectAtIndex:i] == [NSNull null])
			[ret addObject:[Target targetWithType:TargetTypePlayerPlayArea position:i]];
	
	return [NSArray arrayWithArray:ret];
}

- (void)addCard:(Card *)aCard toPosition:(Target *)aTarget;
{
	switch (aTarget.type)
	{
		case TargetTypePlayerPlayArea:
			[playerPlayArea replaceObjectAtIndex:aTarget.position withObject:aCard];
			break;

		case TargetTypeOpponentPlayArea:
			[opponentPlayArea replaceObjectAtIndex:aTarget.position withObject:aCard];
			break;
	}
}

- (void)discardCardFromPosition:(Target *)aTarget;
{
	switch (aTarget.type)
	{
		case TargetTypePlayerPlayArea:
			[playerPlayArea replaceObjectAtIndex:aTarget.position withObject:[NSNull null]];
			break;
			
		case TargetTypeOpponentPlayArea:
			[opponentPlayArea replaceObjectAtIndex:aTarget.position withObject:[NSNull null]];
			break;
	}
}

@end

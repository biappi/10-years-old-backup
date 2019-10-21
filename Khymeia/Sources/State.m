//
//  State.m
//  Khymeia
//
//  Created by Luca Bartoletti on 05/06/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "State.h"


@implementation State

@synthesize player;
@synthesize opponent;
@synthesize phase;
@synthesize isPlayerTargetable;
@synthesize isOpponentTargetable;

-(id) initWithPlayer:(Player*)aPlayer andOpponent:(Player*)aOpponent andPhase:(NSInteger)fase;
{
    if (self = [super init]) 
	{
		player = [[Player playerWithPlayer:aPlayer] retain];
		opponent = [[Player playerWithPlayer:aOpponent] retain];
		phase=fase;
		isPlayerTargetable = YES;
		isOpponentTargetable = YES;
	}
    return self;
}

- (void)dealloc 
{
	[player release];
	[opponent release];
    [super dealloc];
}


@end


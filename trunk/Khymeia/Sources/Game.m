//
//  Game.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Game.h"


@implementation Game

-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)aOpponent andImFirst:(bool)iAmFirst;
{
	if (self = [super init])
	{
		player = [aPlayer retain];
		opponent = [aOpponent retain];
		isFirst = iAmFirst; 
		
	}
	return self;
}


-(void)setup;
{
	player.health = 100;
	//mischia carta
	//prendi le prime 5 carte
}


@end

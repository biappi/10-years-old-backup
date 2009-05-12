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

#pragma mark -
#pragma mark Interface to Gameplayer methods

-(BOOL)willPlayCard:(Card*)aCard onCard:(Card*)otherCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(void)didPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{
	NOT_IMPLEMENTED();
}

-(BOOL)willPlayCard:(Card*)aCard atPlayer:(Player*)aPlayer;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(void)didPlayCard:(Card*)aCard atPlayer:(Player*)aPlayer;
{
	NOT_IMPLEMENTED();
}

-(BOOL)willPlayCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(void)didPlayCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
}

-(BOOL)willSelectCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(void)didSelectCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
}

-(BOOL)shouldPassNextPhase;
{
	NOT_IMPLEMENTED();
	return NO;
}

-(void)didDiscardCard:(Card*)aCard;
{
	NOT_IMPLEMENTED();
}

-(void)didTimeout;
{
	NOT_IMPLEMENTED();
}

@end

//
//  ComunicatioLayer.m
//  Khymeia
//
//  Created by Alessio Bonu on 14/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "ComunicatioLayer.h"


@implementation ComunicatioLayer

@synthesize comLayer;

@synthesize gameplay;

#pragma mark -
#pragma mark send methods

-(BOOL)sendDidPlayCard:(Card*)card onCard:(Card*)onCard
{
	[comLayer receiveDidPlayCard:card onCard:onCard];
	return YES;
}

-(BOOL)sendDidPlayCard:(Card*)card onPlayer:(Player *)player
{
	[comLayer receiveDidPlayCard:card onPlayer:player];
	return YES;
}

-(BOOL)sendDidPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{
	[comLayer receiveDidPlayCard:aCard onCard:otherCard withGesture:completed];
	return YES;
}

-(BOOL)sendWillPlayCard:(Card*)card onCard:(Card*)onCard;
{
	[comLayer receiveWillPlayCard:card onCard:onCard];
	return YES;
}

-(BOOL)sendWillPlayCard:(Card*)card onPlayer:(Player *)player;
{
	[comLayer receiveWillPlayCard:card onPlayer:player];
	return YES;
}
/*NOT YET IMPLEMENTED
-(BOOL)sendWillPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{
	[comLayer receiveWillPlayCard:aCard onCard:otherCard withGesture:completed];
	return YES;
}*/

#pragma mark -
#pragma mark receive methods

-(void)receiveDidPlayCard:(Card*)card onCard:(Card*)onCard
{
	[gameplay didPlayOpponentCard:card onCard:onCard];
}

-(void)receiveDidPlayCard:(Card*)card onPlayer:(Player *)player
{
	[gameplay didPlayOpponentCard:card atPlayer:player];
}

-(void)receiveDidPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{	
	[gameplay didPlayOpponentCard:aCard onCard:otherCard withGesture:completed];
}

-(void)receiveWillPlayCard:(Card*)card onCard:(Card*)onCard;
{	
	[gameplay willPlayOpponentCard:card onCard:onCard];
}

-(void)receiveWillPlayCard:(Card*)card onPlayer:(Player *)player;
{	
	[gameplay willPlayOpponentCard:card atPlayer:player];
}

/*NOT YET IMPLEMENTED
 -(void)receiveWillPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{	
	[gameplay willPlayOpponentCard:aCard onCard:otherCard withGesture:completed];
}
*/

@end

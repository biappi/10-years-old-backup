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

-(id)init
{
	if (self = [super init])
	{
	}
	return self;
}

#pragma mark -
#pragma mark send methods 


/*NOT YET IMPLEMENTED
-(BOOL)sendWillPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{
	[comLayer receiveWillPlayCard:aCard onCard:otherCard withGesture:completed];
	return YES;
}*/

#pragma mark -
#pragma mark receive methods

-(BOOL)sendWillPlayCard:(Card*)aCard onTarget:(id)aTarget;
{
	[comLayer receiveWillPlayCard:aCard onTarget:aTarget];
	return YES;
}
-(BOOL)sendDidPlayCard:(Card*)aCard onTarget:(id)aTarget;
{
	[comLayer receiveDidPlayCard:aCard onTarget:aTarget];
	return YES;
}

-(void)receiveWillPlayCard:(Card*)aCard onTarget:(id)aTarget;
{
	[gameplay willPlayOpponentCard:aCard onTarget:aTarget];
	
}

-(void)receiveDidPlayCard:(Card*)aCard onTarget:(id)aTarget;
{
	[gameplay didPlayOpponentCard:aCard onTarget:aTarget];
}

@end

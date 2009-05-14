//
//  ComunicatioLayer.m
//  Khymeia
//
//  Created by Alessio Bonu on 14/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "ComunicatioLayer.h"


@implementation ComunicatioLayer

@synthesize gameplay;
-(BOOL)sendDidPlayCard:(Card*)card onCard:(Card*)oncard
{
	return NO;
}

-(BOOL)sendDidPlayCard:(Card*)card onPlayer:(Player *)player
{
	return NO;
}

-(BOOL)sendDidPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{
	return NO;
}

-(BOOL)sendWillPlayCard:(Card*)card onCard:(Card*)oncard;
{
	return NO;
}

-(BOOL)sendWillPlayCard:(Card*)card onPlayer:(Player *)player;
{
	return NO;
}

-(BOOL)sendWillPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{
	return NO;
}

@end

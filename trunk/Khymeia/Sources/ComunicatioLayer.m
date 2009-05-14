//
//  ComunicatioLayer.m
//  Khymeia
//
//  Created by Alessio Bonu on 14/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "ComunicatioLayer.h"


@implementation ComunicatioLayer

-(BOOL)willSendDidPlayCard:(Card*)card onCard:(Card*)oncard
{
	return NO;
}

-(BOOL)willSendDidPlayCard:(Card*)card onPlayer:(Player *)player
{
	return NO;
}

-(BOOL)willSendDidPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;
{
	return NO;
}

@end

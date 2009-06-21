//
//  B30.m
//  Khymeia
//
//  Created by Alessio Bonu on 11/06/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "B30.h"
#import "AvailableTargets.h"
#import "util.h"
#import "Card.h"
/**
 * B30
 * Sacrifice an element I; pesca una carta	
 */

@implementation B30

/**
 return an array of AvailableTarget
 */

/************************************TODO*****************************************
 **CONVERTIRE DA AVAILABLE TARGETS MULTIPLI A SINGOLE RICHIESTE ALL'INTERFACCIA **
 *********************************************************************************/

-(NSArray*)targets:(State*)aState;
{
	AvailableTargets* avT=[Util findTargetElementsForState:aState andType:CardElementAny andMinPower:1 andMaxPower:1 ofPlayerKind:PlayerKindPlayer];
	if(avT)
		return [NSMutableArray arrayWithObject:avT];
	else
		return nil;
}
/*
public void play(bersagli[], gesture) 
{
	sacrifica(bersagli[0]);
	
	this.proprietario.drawCard(1);
}
*/
@end

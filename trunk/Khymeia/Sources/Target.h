//
//  Target.h
//  Khymeia
//
//  Created by Pasquale Anatriello on 15/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: aggiungere table come target per le magie

typedef enum 
{
	TargetTypePlayer,
	TargetTypeOpponent,
	TargetTypePlayerHand,
	TargetTypeOpponentHand,
	TargetTypePlayerDeck,
	TargetTypeOpponentDeck,
	TargetTypePlayerCemetery,
	TargetTypeOpponentCemetery,
	TargetTypePlayerPlayArea,
	TargetTypeOpponentPlayArea,
	TargetTypeTable,
	TargetTypeNumberOfTargetTypes,
} TargetTypes;

@interface Target : NSObject
{
	TargetTypes type;
	int         position; //< are zero-based
}

@property(nonatomic, assign) TargetTypes type;
@property(nonatomic, assign) int         position;

+ (Target *) targetWithType:(TargetTypes)type position:(int)position;
+ (Target *) targetWithTarget:(Target*)theTarget;

/**
 Convert target point of you. If target type are OpponentSomething, after calling it, target will be PlayerSomething
 */
-(void)convertPointOfView;

@end

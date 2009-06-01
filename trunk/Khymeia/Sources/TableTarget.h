//
//  Target.h
//  Khymeia
//
//  Created by Pasquale Anatriello on 15/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
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
} TargetTypes;

@interface Target : NSObject
{
	TargetTypes type;
	int         position; //< are zero-based
}

@property(nonatomic, assign) TargetTypes type;
@property(nonatomic, assign) int         position;

+ (Target *) targetWithType:(TargetTypes)type position:(int)position;

@end

//
//  AvailableTargets.h
//  Khymeia
//
//  Created by Alessio Bonu on 11/06/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Card.h"


typedef enum 
	{
		AvailableTargetTypePlayer,
		AvailableTargetTypeCard,
		AvailableTargetTypeNOne,
	} AvailableTargetTypes;

@interface AvailableTargets : NSObject {
	AvailableTargetTypes type;
	int numberOfTargets;
	NSMutableArray *cardList;
	PlayerKind playerKind;
}

@property (nonatomic,assign) AvailableTargetTypes type;
@property (nonatomic,assign) int numberOfTargets;
@property (nonatomic,retain) NSMutableArray *cardList;
@property (nonatomic,assign) PlayerKind playerKind;

-(id)initWithPlayer:(PlayerKind)player andNumber:(NSInteger)number; 
-(id)initWithCard:(NSMutableArray*)cards andNumber:(NSInteger)number; 
@end

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

/**
 this class represent the possible targets that the player can choose between
 The gamePlay use this data structure to tell the interface wich are the possible choice for plaing
 */

@interface AvailableTargets : NSObject {
	AvailableTargetTypes type;
	int numberOfTargets;
	NSMutableArray *cardList;
	PlayerKind playerKind;
	NSString *description;//example the interface must show "choose an element to sacrify"
	
}

@property (nonatomic,assign) AvailableTargetTypes type;
@property (nonatomic,assign) int numberOfTargets;
@property (nonatomic,retain) NSMutableArray *cardList;
@property (nonatomic,assign) PlayerKind playerKind;
@property (nonatomic, retain) NSString *description;

-(id)initWithPlayer:(PlayerKind)player andNumber:(NSInteger)number; 
-(id)initWithCard:(NSMutableArray*)cards andNumber:(NSInteger)number andDescription:(NSString*) desc; 
@end

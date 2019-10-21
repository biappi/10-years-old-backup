//
//  AvailableTargets.m
//  Khymeia
//
//  Created by Alessio Bonu on 11/06/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "AvailableTargets.h"
#import "Player.h"
#import "Card.h"



@implementation AvailableTargets

@synthesize type;
@synthesize numberOfTargets;
@synthesize cardList;
@synthesize playerKind;
@synthesize description;

-(id)initWithPlayer:(PlayerKind)player andNumber:(NSInteger)number; 
{
	if (self = [super init])
	{
		type=AvailableTargetTypePlayer;
		numberOfTargets=number;
		playerKind=player;
		
	}
	return self;
}

-(id)initWithCard:(NSMutableArray*)cards andNumber:(NSInteger)number andDescription:(NSString*)desc; 
{
	if (self = [super init])
	{
		type=AvailableTargetTypeCard;
		numberOfTargets=number;
		cardList=cards;	
		description=desc;
	}
	return self;
}



@end

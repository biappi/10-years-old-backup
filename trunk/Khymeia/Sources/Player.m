//
//  Player.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize name;
@synthesize health;
@synthesize deck;
@synthesize hand;
@synthesize cemetery;

-(id) init
{
	if (self = [super init])
	{
		
	}
	return self;
}

@end

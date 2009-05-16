//
//  Table.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Table.h"


@implementation Table

@synthesize playerCards;
@synthesize opponentCards;

-(void)dealloc;
{
	[opponentCards release];
	[playerCards   release];
	[super dealloc];
}

@end

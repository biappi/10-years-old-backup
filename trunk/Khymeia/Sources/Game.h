//
//  Game.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Player.h"
#import "Table.h"

@interface Game : NSObject 
{
	Table	*table;
	Player	*player;
	Player  *opponent;
	bool	isFirst;
}

-(id)initWithPlayer:(Player*)aPlayer opponent:(Player*)opponent andImFirst:(bool)isFirst;

@end

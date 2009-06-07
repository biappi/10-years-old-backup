//
//  State.h
//  Khymeia
//
//  Created by Luca Bartoletti on 05/06/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"


@interface State : NSObject 
{
	Player					*player;
	Player					*opponent;
	NSInteger				phase;
	BOOL					isPlayerTargetable;
	BOOL					isOpponentTargetable;
}

@property (nonatomic,readonly) Player *player;
@property (nonatomic,readonly) Player *opponent;
@property (nonatomic,assign)NSInteger phase;
@property (nonatomic,assign)   BOOL isPlayerTargetable;
@property (nonatomic,assign)   BOOL isOpponentTargetable;

-(id)initWithPlayer:(Player*)aPlayer andOpponent:(Player*)aOpponent andPhase:(NSInteger)phase;

@end

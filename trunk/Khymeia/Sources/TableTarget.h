//
//  Target.h
//  Khymeia
//
//  Created by Pasquale Anatriello on 15/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
	TableTargetTypePlayer,
	TableTargetTypeOpponent
} TableTargetType;


@interface TableTarget : NSObject 
{
	TableTargetType table;
	int position;
}

@property(nonatomic,assign) TableTargetType table;
@property(nonatomic,assign) int position;

/**
 /param table: type of table
 /return an instance of TableTarget
 */
-(id) initwithTable:(TableTargetType)table andPosition:(int) position;

@end

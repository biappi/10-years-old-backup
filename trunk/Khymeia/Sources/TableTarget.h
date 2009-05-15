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
	PlayerTable,
	OpponentTable
} TableTargeted;


@interface TableTarget : NSObject 
{
	TableTargeted table;
	int position;
}
-(id) initwithTable:(TableTargeted) table andPosition:(int) position;


@property(nonatomic,assign) TableTargeted table;
@property(nonatomic,assign) int position;
@end

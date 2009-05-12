//
//  Table.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Table : NSObject
{
	NSMutableArray    *playerCards;
	NSMutableArray    *opponentCards;
}

@property (nonatomic, retain) NSMutableArray *playerCards;
@property (nonatomic, retain) NSMutableArray *opponentCards;

@end

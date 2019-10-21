//
//  CardLayer.h
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 14/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>
#import "Card.h"

@interface CardLayer : CALayer
{
	Card * card;
	NSMutableArray * level;

	BOOL pleaseDoNotMove;
}

@property (nonatomic, retain) Card * card;
@property (nonatomic, assign) BOOL pleaseDoNotMove;

+ (CardLayer *)cardWithCard:(Card *)theCard;

- (id) initWithCard:(Card *)card;

@end

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
}

- (id) initWithCard:(Card *)card;

@property (nonatomic, retain) Card * card;
@end

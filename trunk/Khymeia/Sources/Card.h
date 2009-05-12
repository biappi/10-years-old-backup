//
//  Card.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	CardTypeElement,
	CardTypeMagic
} CardType;

typedef enum {
	CardElementVoid,
	CardElementWater,
	CardElementFire,
	CardElementEarth,
	CardElementWind
} CardElement;

@interface Card : NSObject
{
	CardType        type;
	CardElement     element;
	NSInteger       level;
	NSString        *name;
	NSString        *image;
}

@property(nonatomic, assign) CardType		type;
@property(nonatomic, assign) CardElement	element;
@property(nonatomic, assign) NSInteger		level;
@property(nonatomic, retain) NSString		*name;
@property(nonatomic, retain) NSString		*image;

@end
//
//  Card.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class State;

typedef enum {
	CardTypeElement,
	CardTypeMagic
} CardType;

typedef enum {
	CardElementVoid,
	CardElementWater,
	CardElementFire,
	CardElementEarth,
	CardElementWind,
	CardElementAny,
} CardElement;

@interface Card : NSObject
{
	CardType        type;
	CardElement     element;
	NSInteger       level;
	
	//on init health=level
	NSInteger		health;
	NSString        *name;
	NSString        *image;
}

@property(nonatomic, assign) CardType		type;
@property(nonatomic, assign) CardElement	element;
@property(nonatomic, assign) NSInteger		level;
@property(nonatomic, assign) NSInteger		health;
@property(nonatomic, retain) NSString		*name;
@property(nonatomic, retain) NSString		*image;

+(id)cardWithCard:(Card*)aCard;

/**
 Create an instance of Card
 /param aName:
 */
-(id)initWithName:(NSString*)aName image:(NSString*)aImage;

-(id)initWithName:(NSString*)aName image:(NSString*)aImage element:(CardElement)elementType type:(CardType)aType;

-(id)initWithName:(NSString*)aName image:(NSString*)aImage element:(CardElement)elementType type:(CardType)aType level:(NSInteger)aLevel;

-(NSMutableArray*) targetForElementWithState:(State*)aState;

/**
 Return an array of targets for card
 /return an array of targets 
 */
-(NSArray*)targets:(State*)aState;

-(void)onPlayCard:(Card*)aCard onAvailableTargets:(NSMutableArray*)anotherCard;		//of AvailableTargets used from interface to gameplay

@end
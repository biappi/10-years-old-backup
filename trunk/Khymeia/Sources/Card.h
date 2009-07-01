//
//  Card.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Target.h"

@class State;

typedef enum 
{
	CardTypeElement,
	CardTypeMagic
} CardType;

typedef enum 
{
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
	NSString		*identifier;
}

@property(nonatomic, assign) CardType		type;
@property(nonatomic, assign) CardElement	element;
@property(nonatomic, assign) NSInteger		level;
@property(nonatomic, assign) NSInteger		health;
@property(nonatomic, retain) NSString		*name;
@property(nonatomic, retain) NSString		*image;
@property(nonatomic, readonly) NSString		*identifier;


+(id)cardWithCard:(Card*)aCard;

/**
 Create an instance of Card
 /param aName:
 */
-(id)initWithName:(NSString*)aName image:(NSString*)aImage identifier:(NSString*)aId;

-(id)initWithName:(NSString*)aName image:(NSString*)aImage identifier:(NSString*)aId element:(CardElement)elementType type:(CardType)aType;

-(id)initWithName:(NSString*)aName image:(NSString*)aImage identifier:(NSString*)aId element:(CardElement)elementType type:(CardType)aType level:(NSInteger)aLevel;

/**
 Called by the gameplay when user would play the card (located in srcTarget) on a dstTarget
 \param srcTarget: target from where user would play
 \param dstTarget: the target witch element in srcTarget will play
 */
- (void)willPlayCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget;

/**
 Called by the gameplay when the user did play card from srcTarget
 \param srcTarget: target from where card that user have played
 \param dstTarget: the target witch element in srcTarget have played
 \param completed: YES if gesture is completed, NO otherwise
 \return an array of game elements where aCard is playable
 */
- (void)didPlayCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget withGesture:(BOOL)completed;

/**
 Return an array of targets for card
 /return an array of targets 
 */
-(NSArray*)targets:(State*)aState;

-(void)onPlayCard:(Card*)aCard onAvailableTargets:(NSMutableArray*)anotherCard;		//of AvailableTargets used from interface to gameplay



@end
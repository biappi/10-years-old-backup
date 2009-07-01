//
//  Card.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Card.h"
#import "Player.h"
#import "Target.h"
#import "State.h"
#import "GameState.h"

@interface Card(PrivateMethods)

-(BOOL)canPlayOnInstance:(Card*)aInstace;

-(NSMutableArray*) targetForElementWithState:(State*)aState;

@end


@implementation Card

@synthesize type;
@synthesize element;
@synthesize level;
@synthesize name;
@synthesize image;
@synthesize health;
@synthesize identifier;

+(id)cardWithCard:(Card*)aCard;
{
	Card *cloneCard = [[Card alloc] initWithName:aCard.name image:aCard.image identifier:aCard.identifier];
	cloneCard.type = aCard.type;
	cloneCard.level = aCard.level;
	cloneCard.element= aCard.element;
	cloneCard.health = aCard.health;
	return [cloneCard autorelease];
}

-(id)initWithName:(NSString*)aName image:(NSString*)aImage identifier:(NSString*)aId;
{
	if (self = [super init])
	{
		self.name = aName;
		self.image = aImage;
		identifier = [aId retain];
	}
	return self;
}

-(id)initWithName:(NSString*)aName image:(NSString*)aImage identifier:(NSString*)aId element:(CardElement)aElement type:(CardType)aType;
{
	if (self = [super init])
	{
		self.name = aName;
		self.image = aImage;
		self.element = aElement;
		self.type = aType;
		identifier = [aId retain];
	}
	return self;
}

-(id)initWithName:(NSString*)aName image:(NSString*)aImage identifier:(NSString*)aId element:(CardElement)aElement type:(CardType)aType level:(NSInteger)aLevel;
{
	if (self = [super init])
	{
		self.name = aName;
		self.image = aImage;
		self.element = aElement;
		self.type = aType;
		self.health = aLevel;
		self.level = aLevel;
		identifier = [aId retain];
	}
	return self;
}

-(void)dealloc;
{
	[name release];
	[image release];
	[identifier release];
	[super dealloc];
}

#pragma mark -
#pragma mark Gameplay methods

-(NSArray*)targets:(State*)aState;
{	
	NSMutableArray *targets = [[NSMutableArray alloc] init];
	if (self.type == CardTypeElement)
	{
		targets=[self targetForElementWithState:aState];	
	}
	if (aState.phase == GamePhaseMainphase && !self.element == CardElementVoid)				
		[targets addObjectsFromArray:[aState.player playAreaFreePositions]];
	
	NSArray *array = [NSArray arrayWithArray:targets];
	[targets release];
	return array;
}

-(BOOL)canPlayOnInstance:(Card*)aInstace;
{
	if (self.element == CardElementVoid)
	{
		return YES;
	}
	else if (aInstace.element == CardElementEarth)
	{
		if (self.element == CardElementWind)
			return YES;
		else
			return NO;
	}
	else if (aInstace.element == CardElementFire)
	{
		if (self.element == CardElementWater)
			return YES;
		else
			return NO;
	}
	else if (aInstace.element == CardElementWater)
	{
		if (self.element == CardElementFire)
			return YES;
		else
			return NO;
	}
	else if (aInstace.element == CardElementWind)
	{
		if (self.element == CardElementEarth)
			return YES;
		else
			return NO;
	}
	NSLog(@"unxpected case in canPlayInstance");
	return NO;
}

- (NSArray*)willPlayCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget;
{
	return nil;
}

- (void)didPlayCardAtTarget:(Target *)srcTarget onTarget:(Target *)dstTarget withGesture:(BOOL)completed;
{
	
}

#pragma mark Private methods

-(NSMutableArray*) targetForElementWithState:(State*)aState;
{
	NSMutableArray *targets = [[NSMutableArray alloc] init];
	
	int i = 0;
	for (Card * opponentCard in aState.opponent.playArea)
	{
		//check if i can play aCard vs opponentCard
		
		if (opponentCard &&(!([opponentCard class] == [NSNull class]) && [self canPlayOnInstance:opponentCard]))
		{
			[targets addObject:[Target targetWithType:TargetTypeOpponentPlayArea position:i]];
		}
		
		i++;
	}
	
	i = 0;
	for (Card * card in aState.player.playArea)
	{
		//check if i can play aCard vs opponentCard
		if (card &&!([card class] == [NSNull class])  && [self canPlayOnInstance:card])
		{
			[targets addObject:[Target targetWithType:TargetTypePlayerPlayArea position:i]];
		}
		
		i++;
	}
	return targets;
}

@end

//
//  Card.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright 2009 Università di Pisa. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize type;
@synthesize element;
@synthesize level;
@synthesize name;
@synthesize image;
@synthesize health;

-(id)initWithCard:(Card*)card;
{
	if(self=[super init])
	{
		
	}
	return card;
}

-(id)initWithName:(NSString*)aName image:(NSString*)aImage;
{
	if (self = [super init])
	{
		self.name = aName;
		self.image = aImage;
	}
	return self;
}

-(id)initWithName:(NSString*)aName image:(NSString*)aImage element:(CardElement)aElement type:(CardType)aType;
{
	if (self = [super init])
	{
		self.name = aName;
		self.image = aImage;
		self.element = aElement;
		self.type = aType;
	}
	return self;
}

-(id)initWithName:(NSString*)aName image:(NSString*)aImage element:(CardElement)aElement type:(CardType)aType level:(NSInteger)aLevel;
{
	if (self = [super init])
	{
		self.name = aName;
		self.image = aImage;
		self.element = aElement;
		self.type = aType;
		self.health = aLevel;
		self.level = aLevel;
	}
	return self;
}

-(void)dealloc;
{
	[name release];
	[image release];
	[super dealloc];
}

#pragma mark -
#pragma mark Gameplay methods
/*
-(NSArray*)targetsWithState:(State*)aState;
{
	
		NSMutableArray *targets = [[NSMutableArray alloc] init];
		Target *tableTarget;
		if (aCard.type == CardTypeElement)
		{
			for (Card * opponentCard in table.opponentPlayArea)
			{
				//check if i can play aCard vs opponentCard
				if (!([opponentCard class] == [NSNull class]) && [self canPlayInstance:aCard onInstance:opponentCard])
				{
					tableTarget = [Target targetWithType:TargetTypeOpponentPlayArea position:[table.opponentPlayArea indexOfObject:opponentCard]];	
					[targets addObject:tableTarget];
				}
			}				
			
			for (Card * card in table.playerPlayArea)
			{
				//check if i can play aCard vs opponentCard
				if (!([card class] == [NSNull class])  && [self canPlayInstance:aCard onInstance:card])
				{
					tableTarget = [Target targetWithType: TargetTypePlayerPlayArea position:[table.playerPlayArea indexOfObject:card]];	
					[targets addObject:tableTarget];
				}
			}
		}
		if (phase == GamePhaseMainphase && !aCard.element == CardElementVoid)				
			[targets addObjectsFromArray:[table playerFreePositions]];
		
		NSArray *array = [NSArray arrayWithArray:targets];
		[targets release];
		return array;
	}
	return nil;
}*/

@end

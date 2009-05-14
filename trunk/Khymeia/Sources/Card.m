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

@end

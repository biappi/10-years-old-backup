//
//  Target.m
//  Khymeia
//
//  Created by Pasquale Anatriello on 15/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "Target.h"

static char * typeStrings[] =
{
	"TargetTypePlayer",
	"TargetTypeOpponent",
	"TargetTypePlayerHand",
	"TargetTypeOpponentHand",
	"TargetTypePlayerDeck",
	"TargetTypeOpponentDeck",
	"TargetTypePlayerCemetery",
	"TargetTypeOpponentCemetery",
	"TargetTypePlayerPlayArea",
	"TargetTypeOpponentPlayArea",
	"TargetTypeNumberOfTargetTypes"
};

@implementation Target

@synthesize type;
@synthesize position;

+ (Target *) targetWithType:(TargetTypes)theType position:(int)thePosition;
{
	Target * p = [[Target alloc] init];
	p.type = theType;
	p.position = thePosition;
	
	return [p autorelease];
}

+ (Target *) targetWithTarget:(Target*)theTarget;
{
	Target * p = [[Target alloc] init];
	p.type = theTarget.type;
	p.position = theTarget.position;
	
	return [p autorelease];
}

- (BOOL)isEqual:(id)two;
{
	if ([two isKindOfClass :[Target class]] == NO)
		return NO;
	
	Target * x = (Target *)two;
	
	return (self.type == x.type) && (self.position == x.position);
}

- (NSString *)description;
{
	return [NSString stringWithFormat:@"<Target: 0x%08x - type: %s position: %d>", self, typeStrings[self.type], self.position];
}

#pragma mark -
#pragma mark Convertion methods

-(void)convertPointOfView;
{
	switch (self.type)
	{
		case TargetTypePlayerHand:
			self.type = TargetTypeOpponentHand;
			break;
		case TargetTypeOpponentHand:
			self.type = TargetTypePlayerHand;
			break;
		case TargetTypePlayerDeck:
			self.type = TargetTypeOpponentDeck;
			break;
		case TargetTypeOpponentDeck:
			self.type = TargetTypePlayerDeck;
			break;
		case TargetTypePlayerCemetery:
			self.type = TargetTypeOpponentCemetery;
			break;
		case TargetTypeOpponentCemetery:
			self.type = TargetTypePlayerCemetery;
			break;
		case TargetTypePlayerPlayArea:
			self.type = TargetTypeOpponentPlayArea;
			break;
		case TargetTypeOpponentPlayArea:
			self.type = TargetTypePlayerPlayArea;
			break;
	}
}


@end

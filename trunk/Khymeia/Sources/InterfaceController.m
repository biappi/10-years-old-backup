//
//  InterfaceController.m
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 12/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InterfaceController.h"
#import "CardLayer.h"
#import "SlotLayer.h"

CGRect cardSlotsRects[] =
{
	// Opponent Play Area
	{ 44,  17, 72, 90},
	{124,  17, 72, 90},
	{204,  17, 72, 90},
	{284,  17, 72, 90},

	// Player Play Area
	{124, 115, 72, 90},
	{204, 115, 72, 90},
	{284, 115, 72, 90},
	{364, 115, 72, 90},

	// Player Hand
	{ 44, 213, 72, 90},
	{124, 213, 72, 90},
	{204, 213, 72, 90},
	{284, 213, 72, 90},
	{364, 213, 72, 90}
};

@interface InterfaceController (PrivateMethods)

@property(readonly) CALayer * mainLayer;

- (CGRect) frameRectForNextPlayerHandCard;

@end

@implementation InterfaceController

#pragma mark House Keeping

@synthesize gameplay;

- (id)init;
{
	return [self initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(id)nib bundle:(id)bundle;
{
	if ((self = [super initWithNibName:@"TableView" bundle:nil]) == nil)
		return nil;
	
	playerHand       = [[NSMutableArray alloc] initWithCapacity:5];
	playerPlayArea   = [[NSMutableArray alloc] initWithCapacity:4];
	opponentPlayArea = [[NSMutableArray alloc] initWithCapacity:4];
	turnEnded= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[turnEnded setTitle:@"Done" forState:[turnEnded state]];
	[turnEnded addTarget:self action:@selector(endTurn) forControlEvents:UIControlEventTouchDown];
	
	return self;
}
-(void) endTurn
{

}
- (void)dealloc;
{
	[playerHand release];
	[playerPlayArea release];
	[opponentPlayArea release];
	[playerHealthPointsLabel release];
	[opponentHealthPointsLabel release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad;
{
	for (int i = 0; i <= (sizeof(cardSlotsRects) / sizeof(CGRect)); i++)
	{
		SlotLayer * l = [[SlotLayer alloc] init];
		l.frame = cardSlotsRects[i];
		[self.view.layer addSublayer:l];
		[l release];
	}
}

#pragma mark Gameplay To Interface

- (void) beginTurn:(GameState) turn;
{
		if(turn==GameStatePlayer)
		{
			[UIAlertView presentInfoAlertViewWithTitle:@"GameState: PLAY"
										   description:@"ok now you can start playing"];
			[self.view addSubview:turnEnded];
			[turnEnded setCenter:CGPointMake(20,20)];
		}
}

- (void) gameDidEnd:(BOOL)youWin;
{
	NOT_IMPLEMENTED();
}

- (void) beginPhaseTimer:(NSTimeInterval)timeout;
{
	NOT_IMPLEMENTED();
}

- (void) setHP:(int)newHP player:(Player *)thePlayer;
{
	NOT_IMPLEMENTED();
}

- (void) substractHP:(int)newHP player:(Player *)thePlayer;
{
	NOT_IMPLEMENTED();
}

- (void) addHP:(int)newHP player:(Player *)thePlayer;
{
	NOT_IMPLEMENTED();
}

- (void) drawCard:(Card *)card;
{
	if ([playerHand count] == 5)
	{
		[UIAlertView presentInfoAlertViewWithTitle:@"AIEE"
									   description:@"Stupid proof of concept code does not support more than 5 cards in hand"];
		return;
	}
	
	CardLayer * newCard = [[CardLayer alloc] initWithCard:card];
	newCard.frame = [self frameRectForNextPlayerHandCard];
	[self.view.layer addSublayer:newCard];
	[playerHand addObject:newCard];	
}

- (void) discardFromHand:(Card *)card;
{
	NOT_IMPLEMENTED();
}

- (void) discardFromPlayArea:(Card *)card;
{
	NOT_IMPLEMENTED();
}

- (void) playCard:(Card *)card;
{
	NOT_IMPLEMENTED();
}

- (void) playCard:(Card *)cardOne overCard:(Card *)cardTwo;
{
	NOT_IMPLEMENTED();
}

- (void) playCard:(Card *)card overPlayer:(Player *)player;
{
	NOT_IMPLEMENTED();
}

- (void) opponentPlaysCard:(Card *)card;
{
	NOT_IMPLEMENTED();
}

- (void) takeCard:(Card *)card from:(InterfaceModes)interfaceMode;
{
	NOT_IMPLEMENTED();
}

- (void) setInterfaceMode:(InterfaceModes)mode;
{
	NOT_IMPLEMENTED();
}

- (void) serverTimeout;
{
	NOT_IMPLEMENTED();
}

- (void) serverError;
{
	NOT_IMPLEMENTED();
}

#pragma mark Touches Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
	CGPoint   p = [[touches anyObject] locationInView:self.view];
	CALayer * l = [self.mainLayer hitTest:[self.mainLayer convertPoint:p
										   toLayer:self.mainLayer.superlayer]];
	if ([l isKindOfClass:[CardLayer class]])
	{
		currentlyMovingCard = l;
		currentlyMovingCardOriginalPosition = l.position;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
	if (currentlyMovingCard == nil)
		return;
	
	UITouch * t = [touches anyObject];

	CGPoint prev  = [t previousLocationInView:self.view];
	CGPoint this  = [t locationInView:self.view];
	
	CGPoint delta = CGPointDifference(this, prev);
	
	currentlyMovingCard.position = CGPointSum(currentlyMovingCard.position, delta);
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	if (currentlyMovingCard == nil)
		return;
		
	BOOL found = NO;
	
	CGPoint p = [[touches anyObject] locationInView:self.view];
	
	for (CALayer * l in self.mainLayer.sublayers)
	{
		if ([l isKindOfClass:[SlotLayer class]] && [l containsPoint:[l convertPoint:p fromLayer:self.mainLayer]])
		{
			currentlyMovingCard.position = l.position;
			found = YES;
		}
	}
	
	if (found == NO)
		currentlyMovingCard.position = currentlyMovingCardOriginalPosition;
	
	currentlyMovingCard = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
	if (currentlyMovingCard == nil)
		return;

	currentlyMovingCard.position = currentlyMovingCardOriginalPosition;
	currentlyMovingCard = nil;
}

#pragma mark Private Methods

- (CGRect) frameRectForNextPlayerHandCard;
{
	return cardSlotsRects[8 + [playerHand count]];
}

- (CALayer *) mainLayer;
{
	return self.view.layer;
}

@end

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

CGRect opponentPlayAreaTargetRects[] =
{
	{ 44,  17, 72, 90},
	{124,  17, 72, 90},
	{204,  17, 72, 90},
	{284,  17, 72, 90}
};

CGRect playerPlayAreaTargetRects[] =
{
	{124, 115, 72, 90},
	{204, 115, 72, 90},
	{284, 115, 72, 90},
	{364, 115, 72, 90}
};

CGRect playerHandTargetRects[] =
{
	{ 44, 213, 72, 90},
	{124, 213, 72, 90},
	{204, 213, 72, 90},
	{284, 213, 72, 90},
	{364, 213, 72, 90}
};

CGRect CGRectForTarget(Target * target)
{
	switch (target.type)
	{
		case TargetTypeOpponentPlayArea:
			return opponentPlayAreaTargetRects[target.position];

		case TargetTypePlayerPlayArea:
			return playerPlayAreaTargetRects[target.position];
			
		case TargetTypePlayerHand:
			return playerHandTargetRects[target.position];
	}
	
	return CGRectZero;
}

Target * TargetHitTest(CGPoint point)
{
	Target * result = [[Target new] autorelease];
	
	result.type = TargetTypeOpponentPlayArea;
	for (int i = 0; i < 4; i++)
	{
		if (CGRectContainsPoint(opponentPlayAreaTargetRects[i], point))
		{
			result.position = i;
			return result;
		}
	}
	
	result.type = TargetTypePlayerPlayArea;
	for (int i = 0; i < 4; i++)
	{
		if (CGRectContainsPoint(playerPlayAreaTargetRects[i], point))
		{
			result.position = i;
			return result;
		}
	}

	result.type = TargetTypePlayerHand;
	for (int i = 0; i < 5; i++)
	{
		if (CGRectContainsPoint(playerHandTargetRects[i], point))
		{
			result.position = i;
			return result;
		}
	}
	
	return nil;
}

@interface InterfaceController (PrivateMethods)

@property(readonly) CALayer * mainLayer;

- (Target *) findSelectedTargetforCard:(CardLayer *) card;
- (CGRect) frameRectForNextPlayerHandCard;

- (CardLayer *)cardAtTarget:(Target *)target;
- (void) setHighlightCurrentTargetSlots:(BOOL)x; //<< not the best api in the world, but i'm quite dead now

@end

@implementation InterfaceController

#pragma mark House Keeping

@synthesize gameplay;
@synthesize interfaceIsBusy;

- (id)init;
{
	return [self initWithNibName:nil bundle:nil];
}

#define NSNULL [NSNull null]

- (id)initWithNibName:(id)nib bundle:(id)bundle;
{
	if ((self = [super initWithNibName:@"TableView" bundle:nil]) == nil)
		return nil;
	
	playerHand       = [[NSMutableArray alloc] initWithObjects:NSNULL, NSNULL, NSNULL, NSNULL, NSNULL, nil];
	playerPlayArea   = [[NSMutableArray alloc] initWithObjects:NSNULL, NSNULL, NSNULL, NSNULL, nil];
	opponentPlayArea = [[NSMutableArray alloc] initWithObjects:NSNULL, NSNULL, NSNULL, NSNULL, nil];
	
	turnEnded = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[turnEnded setFrame:CGRectMake(0, 0, 40, 40)];
	[turnEnded retain];
	[turnEnded setTitle:@"Done" forState:[turnEnded state]];
	[turnEnded addTarget:self action:@selector(endTurn) forControlEvents:UIControlEventTouchDown];
	
	interfaceIsBusy = NO;
	
	return self;
}

-(void) endTurn
{
	if(![gameplay shouldPassNextPhase])
		KhymeiaLog(@"You cannot yet pass to the next phase");
	else
		[turnEnded removeFromSuperview];
}

- (void)dealloc;
{
	[playerHand release];
	[playerPlayArea release];
	[opponentPlayArea release];
	[turnEnded release];
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
	NSMutableArray * temp = [NSMutableArray arrayWithCapacity:5];
	
	for (int i = 0; i <= (sizeof(opponentPlayAreaTargetRects) / sizeof(CGRect)); i++)
	{
		SlotLayer * l = [[SlotLayer alloc] init];
		l.frame = opponentPlayAreaTargetRects[i];
		[self.view.layer addSublayer:l];
		[temp addObject:l];
		[l release];
	}

	opponentPlayAreaSlots = [[NSArray arrayWithArray:temp] retain];
	temp = [NSMutableArray arrayWithCapacity:5];
	
	for (int i = 0; i <= (sizeof(playerPlayAreaTargetRects) / sizeof(CGRect)); i++)
	{
		SlotLayer * l = [[SlotLayer alloc] init];
		l.frame = playerPlayAreaTargetRects[i];
		[self.view.layer addSublayer:l];
		[temp addObject:l];
		[l release];
	}

	playerPlayAreaSlots = [[NSArray arrayWithArray:temp] retain];
	temp = [NSMutableArray arrayWithCapacity:5];
	
	for (int i = 0; i <= (sizeof(playerHandTargetRects) / sizeof(CGRect)); i++)
	{
		SlotLayer * l = [[SlotLayer alloc] init];
		l.frame = playerHandTargetRects[i];
		[self.view.layer addSublayer:l];
		[temp addObject:l];
		[l release];
	}
	
	playerHandSlots = [[NSArray arrayWithArray:temp] retain];
}

#pragma mark Gameplay To Interface

- (void) setState:(GameState) turn;
{
	currentState=turn;
}

-(void) setPhase:(GamePhase) phase;
{
	switch (phase) {
		case GamePhaseMainphase:
			if(currentState==GameStatePlayer)
			{
				[self.view addSubview:turnEnded];
				[turnEnded setCenter:CGPointMake(20,20)];
				[turnEnded setNeedsDisplay];
			}
			break;
		case GamePhaseAttackOpponent:
			if(currentState==GameStateOpponent)
			{
				[self.view addSubview:turnEnded];
				[turnEnded setCenter:CGPointMake(20,20)];
				[turnEnded setNeedsDisplay];
			}
			break;
		case GamePhaseAttackPlayer:
			if(currentState==GameStatePlayer)
			{
				[self.view addSubview:turnEnded];
				[turnEnded setCenter:CGPointMake(20,20)];
				[turnEnded setNeedsDisplay];
			}		
			break;
		case GamePhaseCardAttainment:
			break;
		case GamePhaseDiscard:
			if(currentState==GameStatePlayer)
			{
				[self.view addSubview:turnEnded];
				[turnEnded setCenter:CGPointMake(20,20)];
				[turnEnded setNeedsDisplay];
			}
			break;
		case GamePhaseDamageResolution:
			break;
		case GamePhaseNone:
			break;
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

- (void) setHP:(int)newHP player:(PlayerKind)thePlayer;
{
	UILabel * l;
	
	l = (thePlayer == PlayerKindPlayer)   ? playerHealthPointsLabel   : nil;
	l = (thePlayer == PlayerKindOpponent) ? opponentHealthPointsLabel : l;
	
	l.text = [NSString stringWithFormat:@"%d", newHP];
}

- (void) substractHP:(int)newHP player:(PlayerKind)thePlayer;
{
	// TODO: trigger some animation
	[self setHP:newHP player:thePlayer];
}

- (void) addHP:(int)newHP player:(PlayerKind)thePlayer;
{
	// TODO: trigger some animation
	[self setHP:newHP player:thePlayer];
}

#pragma mark New Targets Handling

- (void) drawCard:(Card *)card toTarget:(Target *)dstTarget;
{
	NSAssert(dstTarget.position < 5, @"Not Enough Position In Player Hand!!");
	
	id existingCard = [playerHand objectAtIndex:dstTarget.position];
	
	if (existingCard != [NSNull null])
		[(CALayer *)existingCard removeFromSuperlayer];
	
	CardLayer * cardLayer = [CardLayer cardWithCard:card];
	cardLayer.frame = playerHandTargetRects[dstTarget.position];
	[self.mainLayer addSublayer:cardLayer];
	
	[playerHand replaceObjectAtIndex:dstTarget.position withObject:cardLayer];
}

- (void) discardFromTarget:(Target *)target;
{
	// TODO: Code is the same for both branches
	//       Will be different for different animations, etc...
	
	if (target.type == TargetTypePlayerHand)
	{
		CardLayer * toRemove = [self cardAtTarget:target];
		[toRemove removeFromSuperlayer];
		
		[playerHand replaceObjectAtIndex:target.position withObject:[NSNull null]];
	}
	
	if (target.type == TargetTypePlayerPlayArea)
	{
		CardLayer * toRemove = [self cardAtTarget:target];
		[toRemove removeFromSuperlayer];
		
		[playerPlayArea replaceObjectAtIndex:target.position withObject:[NSNull null]];
	}
	
	if (target.type == TargetTypeOpponentPlayArea)
	{
		CardLayer * toRemove = [self cardAtTarget:target];
		[toRemove removeFromSuperlayer];
		
		[opponentPlayArea replaceObjectAtIndex:target.position withObject:[NSNull null]];
	}
}

- (void) opponentPlaysCard:(Card *)card onTarget:(Target *)target;
{
	CardLayer * theCard = [CardLayer cardWithCard:card];	

	if(target.type == TargetTypePlayerPlayArea)
	{
		NSAssert(target.position < 4, @"Not Enough Position In Player Playarea!!");
		theCard.frame = playerPlayAreaTargetRects[target.position];
	}

	else if(target.type == TargetTypeOpponentPlayArea)
	{
		NSAssert(target.position < 4, @"Not Enough Position In Opponent Playarea!!");
		theCard.frame = opponentPlayAreaTargetRects[target.position];
	}
	
	[self.view.layer addSublayer:theCard];
	[opponentPlayArea replaceObjectAtIndex:target.position withObject:theCard];
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
	
	Target    * target  = TargetHitTest(p);
	CardLayer * cardHit = [self cardAtTarget:target]; 
	
	if (cardHit != nil)
	{		
		currentTargets = [[gameplay targetsForCardAtTarget:target] retain];

		[self setHighlightCurrentTargetSlots:YES];
		
		//if([currentTargets count]>0) (if commented so that you can pick every card, but you just can't put anywhere
		{
			currentlyMovingCard = cardHit;
			currentlyMovingCardOriginalPosition = cardHit.position;
			currentlyMovingCardTarget = [target retain];
			
			[currentlyMovingCard setZPosition:[currentlyMovingCard zPosition]+1];
			
			interfaceIsBusy = YES;
		}
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
		
	CGPoint p = [[touches anyObject] locationInView:self.view];

	Target * target = TargetHitTest(p);
	if ([currentTargets indexOfObject:target] != NSNotFound)
	{
		[gameplay willPlayCardAtTarget:currentlyMovingCardTarget onTarget:target];
		currentlyMovingCard.frame = CGRectForTarget(target);
		[gameplay didPlayCardAtTarget:currentlyMovingCardTarget onTarget:target withGesture:NO];
	} else {
		currentlyMovingCard.pleaseDoNotMove = NO;
		currentlyMovingCard.position = currentlyMovingCardOriginalPosition;
		currentlyMovingCard.pleaseDoNotMove = YES;
	}
		
	/*
	 * Let's control if you're playing a card on a slot on the play area
	 */
	[currentlyMovingCard setZPosition:[currentlyMovingCard zPosition]-1];

	[self setHighlightCurrentTargetSlots:NO];
	
	currentlyMovingCard = nil;
	interfaceIsBusy = NO;
	
	[currentTargets release];
	currentTargets = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
	if (currentlyMovingCard == nil)
		return;

	currentlyMovingCard.position = currentlyMovingCardOriginalPosition;
	currentlyMovingCard = nil;
	interfaceIsBusy = NO;
	[self setHighlightCurrentTargetSlots:NO];
	[currentTargets release];
	currentTargets = nil;

}

#pragma mark Private Methods

- (CALayer *) mainLayer;
{
	return self.view.layer;
}

- (void) showText:(NSString *) text withTitle:(NSString *) title
{
	KhymeiaLog(text);
}

- (CardLayer *)cardAtTarget:(Target *)target;
{
	NSArray * type;
	
	if (target == nil)
		return nil;
	
	switch (target.type)
	{
		case TargetTypePlayerHand:
			type = playerHand;
			break;
		
		case TargetTypeOpponentPlayArea:
			type = opponentPlayArea;
			break;
			
		case TargetTypePlayerPlayArea:
			type = playerPlayArea;
			break;
	}
	
	id object = [type objectAtIndex:target.position];
	
	if (object == [NSNull null])
		return nil;
	
	return object;
}

- (void) setHighlightCurrentTargetSlots:(BOOL)x;
{
	for (Target * t in currentTargets)
	{
		NSArray * type;
		
		switch (t.type)
		{
			case TargetTypePlayerHand:
				type = playerHandSlots;
				break;
				
			case TargetTypeOpponentPlayArea:
				type = opponentPlayAreaSlots;
				break;
				
			case TargetTypePlayerPlayArea:
				type = playerPlayAreaSlots;
				break;
		}
		
		[[type objectAtIndex:t.position] setSlotHighlight:x];
	}
}

@end

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

- (Target *) findSelectedTargetforCard:(CardLayer *) card;
- (CGRect) frameRectForNextPlayerHandCard;

@end

@implementation InterfaceController

#pragma mark House Keeping

@synthesize gameplay;
@synthesize interfaceIsBusy;

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
	for (int i = 0; i <= (sizeof(cardSlotsRects) / sizeof(CGRect)); i++)
	{
		SlotLayer * l = [[SlotLayer alloc] init];
		l.frame = cardSlotsRects[i];
		[self.view.layer addSublayer:l];
		[l release];
	}
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

- (void) discardFromHand:(Card *)acard;
{
	CardLayer * toRemove;
	
	for(CardLayer * card in self.view.layer.sublayers)
	{
		if([card isKindOfClass:[CardLayer class]] && [card.card isEqual:acard])
		{
			toRemove=card;
			//;
		}
	}
	
	[toRemove removeFromSuperlayer];
	[toRemove release];
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

- (void) opponentPlaysCard:(Card *)card onTarget:(Target *) target;
{
	CardLayer * theCard=[[CardLayer alloc] initWithCard:card];
	
	if(target.type ==TargetTypePlayerPlayArea)
	{
		theCard.frame=cardSlotsRects[3+target.position];
	}
	else if(target.type==TargetTypeOpponentPlayArea)
	{
		
		theCard.frame=cardSlotsRects[target.position];
	}
	
	[self.view.layer addSublayer:theCard];
	[opponentPlayArea addObject:card];
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
	if ([l isKindOfClass:[CardLayer class]] )
	{
		
		if(currentTargets)
			[currentTargets release];
		currentTargets=[[gameplay targetsForCard:[(CardLayer*) l card]] retain];
		if([currentTargets count]>0)
		{	
			currentlyMovingCard = l;
			currentlyMovingCardOriginalPosition = l.position;
			[currentlyMovingCard setZPosition:[currentlyMovingCard zPosition]+1];
		}
		else
		{
			currentlyMovingCard=nil;
		}
	}
	
	interfaceIsBusy = YES;
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
		if(([l isKindOfClass:[CardLayer class]] || [l isKindOfClass:[SlotLayer class]])&& [l containsPoint:[l convertPoint:p fromLayer:self.mainLayer]])
		{
			Target * target=[self findSelectedTargetforCard:(CardLayer*)l];
			if(target)
			{
				for(Target * allowedTarget in currentTargets)
				{
					if(target.position==allowedTarget.position && target.type==allowedTarget.type)
					{
						[gameplay willPlayCard: ((CardLayer *) currentlyMovingCard).card onTarget:allowedTarget];
							currentlyMovingCard.position = l.position;
							
							[gameplay didPlayCard:((CardLayer *) currentlyMovingCard).card onTarget:allowedTarget withGesture:NO];
						[playerHand removeObject:currentlyMovingCard];
						found=YES;
					}
				}
			}
		}		
	}
 
 
	
	/*
	 * Let's control if you're playing a card on a slot on the play area
	 */
	if (found == NO)
		currentlyMovingCard.position = currentlyMovingCardOriginalPosition;
	
	[currentlyMovingCard setZPosition:[currentlyMovingCard zPosition]-1];

	currentlyMovingCard = nil;
	interfaceIsBusy = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
	if (currentlyMovingCard == nil)
		return;

	currentlyMovingCard.position = currentlyMovingCardOriginalPosition;
	currentlyMovingCard = nil;
	interfaceIsBusy = NO;
}

#pragma mark Private Methods

-(Target *)findSelectedTargetforCard:(CardLayer*) card;
{
	int i;
	for(i=0;i<4; i++)
	{
		if(CGRectContainsPoint(cardSlotsRects[i],card.position))
		{
			
			return [Target targetWithType:TargetTypeOpponentPlayArea position:i];
		}
	}
	for(i=0;i<4;i++)
	{
		if(CGRectContainsPoint(cardSlotsRects[i+4],card.position))
		{
			
			return [Target  targetWithType:TargetTypePlayerPlayArea position:i];
		}
	
	}
	return nil;
}

- (CGRect) frameRectForNextPlayerHandCard;
{
	return cardSlotsRects[8 + [playerHand count]];
}

- (CALayer *) mainLayer;
{
	return self.view.layer;
}

@end

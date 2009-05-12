//
//  InterfaceController.m
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 12/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InterfaceController.h"

@implementation InterfaceController

- (void) beginTurn;
{
}

- (void) endTurn;
{
}

- (void) gameDidEnd:(BOOL)youWin;
{
}

- (void) beginPhaseTimer:(NSTimeInterval)timeout;
{
}

- (void) setHP:(int)newHP player:(Player *)thePlayer;
{
}

- (void) substractHP:(int)newHP player:(Player *)thePlayer;
{
}

- (void) addHP:(int)newHP player:(Player *)thePlayer;
{
}

- (void) drawCard:(Card *)card;
{
}

- (void) discardFromHand:(Card *)card;
{
}

- (void) discardFromPlayArea:(Card *)card;
{
}

- (void) playCard:(Card *)card;
{
}

- (void) playCard:(Card *)cardOne overCard:(Card *)cardTwo;
{
}

- (void) playCard:(Card *)card overPlayer:(Player *)player;
{
}

- (void) opponentPlaysCard:(Card *)card;
{
}

- (void) takeCard:(Card *)card from:(InterfaceModes)interfaceMode;
{
}

- (void) setInterfaceMode:(InterfaceModes)mode;
{
}

- (void) serverTimeout;
{
}

- (void) serverError;
{
}

@end

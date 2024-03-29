//
//  KhymeiaAppDelegate.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright Università di Pisa 2009. All rights reserved.
//

#import "KhymeiaAppDelegate.h"
#import "InterfaceController.h"
#import "Player.h"
#import "Card.h"
#import "ComunicatioLayer.h"

@implementation KhymeiaAppDelegate

@synthesize window;
@synthesize theScroller;

- (void)applicationDidFinishLaunching:(UIApplication *)application;
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window makeKeyAndVisible];
	
	/*
	 *Card creation
	 */
	Card *fireElemental=[[Card alloc] initWithName:@"fire1" image:@"fire.jpg" identifier:@"B01" element:CardElementFire type:CardTypeElement level:1];
	Card *windElemental=[[Card alloc] initWithName:@"wind1" image:@"air.jpg" identifier:@"B02"  element:CardElementWind type:CardTypeElement level:3];
	Card *waterElemental=[[Card alloc] initWithName:@"water1" image:@"water.jpg" identifier:@"B03"  element:CardElementWater type:CardTypeElement level:3];
	Card *earthElemental=[[Card alloc] initWithName:@"earth1" image:@"earth.jpg" identifier:@"B04"  element:CardElementEarth type:CardTypeElement level:4];
	Card *voidElemental=[[Card alloc] initWithName:@"void1" image:@"vacuum.jpg" identifier:@"B05"  element:CardElementVoid type:CardTypeElement level:3];
	Card *fireElemental2=[[Card alloc] initWithName:@"fire2" image:@"elementale1.png" identifier:@"B06"  element:CardElementFire type:CardTypeElement level:4];
	Card *windElemental2=[[Card alloc] initWithName:@"wind2" image:@"air.jpg" identifier:@"B07"  element:CardElementWind type:CardTypeElement level:1];
	Card *waterElemental2=[[Card alloc] initWithName:@"water2" image:@"water.jpg" identifier:@"B08"  element:CardElementWater type:CardTypeElement level:1];
	Card *earthElemental2=[[Card alloc] initWithName:@"earth2" image:@"earth.jpg" identifier:@"B09"  element:CardElementEarth type:CardTypeElement level:2];
	Card *voidElemental2=[[Card alloc] initWithName:@"void2" image:@"vacuum.jpg" identifier:@"B10"  element:CardElementVoid type:CardTypeElement level:3];
	
	Card *fireElementalOp=[[Card alloc] initWithName:@"OpFire1" image:@"fire.jpg" identifier:@"B11"  element:CardElementFire type:CardTypeElement level:3];
	Card *windElementalOp=[[Card alloc] initWithName:@"OpWind1" image:@"air.jpg"  identifier:@"B12" element:CardElementWind type:CardTypeElement level:1];
	Card *waterElementalOp=[[Card alloc] initWithName:@"OpWater1" image:@"water.jpg" identifier:@"B13"  element:CardElementWater type:CardTypeElement level:1];
	Card *earthElementalOp=[[Card alloc] initWithName:@"OpEarth1" image:@"earth.jpg" identifier:@"B14"  element:CardElementEarth type:CardTypeElement level:2];
	Card *voidElementalOp=[[Card alloc] initWithName:@"OpVoid1" image:@"vacuum.jpg" identifier:@"B15"  element:CardElementVoid type:CardTypeElement level:2];
	Card *fireElementalOp2=[[Card alloc] initWithName:@"OpFire2" image:@"fire.jpg" identifier:@"B16"  element:CardElementFire type:CardTypeElement level:4];
	Card *windElementalOp2=[[Card alloc] initWithName:@"OpWind2" image:@"air.jpg" identifier:@"B17"  element:CardElementWind type:CardTypeElement level:3];
	Card *waterElementalOp2=[[Card alloc] initWithName:@"OpBeerDrinker2" image:@"water.jpg" identifier:@"B18"  element:CardElementWater type:CardTypeElement level:1];
	Card *earthElementalOp2=[[Card alloc] initWithName:@"OpEarth2" image:@"earth.jpg"  identifier:@"B19" element:CardElementEarth type:CardTypeElement level:2];
	Card *voidElementalOp2=[[Card alloc] initWithName:@"OpVoid2" image:@"vacuum.jpg" identifier:@"B20"  element:CardElementVoid type:CardTypeElement level:1];
	
	/*
	 *	create deck
	 */
	NSMutableArray *deck=[[NSMutableArray alloc] initWithObjects:fireElemental,windElemental,waterElemental,earthElemental,voidElemental,nil];
	[fireElemental release];
	[windElemental release];
	[waterElemental release];
	[earthElemental release];
	[voidElemental release];
	NSMutableArray *deckOp=[[NSMutableArray alloc] initWithObjects:fireElementalOp,windElementalOp,waterElementalOp,earthElementalOp,voidElementalOp,nil];
	[fireElementalOp release];
	[windElementalOp release];
	[waterElementalOp release];
	[earthElementalOp release];
	[voidElementalOp release];
	NSMutableArray *hand=[[NSMutableArray alloc] initWithObjects:fireElemental2,windElemental2,waterElemental2,earthElemental2,voidElemental2,nil];
	[fireElemental2 release];
	[windElemental2 release];
	[waterElemental2 release];
	[earthElemental2 release];
	[voidElemental2 release];
    NSMutableArray *handOp=[[NSMutableArray alloc] initWithObjects:fireElementalOp2,windElementalOp2,waterElementalOp2,earthElementalOp2,voidElementalOp2,nil];
	[fireElementalOp2 release];
	[windElementalOp2 release];
	[waterElementalOp2 release];
	[earthElementalOp2 release];
	[voidElementalOp2 release];
	
	/*
	 * initialize Player 
	 */
	Player *player=[[Player alloc] initWithHand:hand];
	player.name=[NSString stringWithFormat:@"player1"];
	player.health=100;
	player.deck=deck;
	[deck release];
	player.cemetery=[[[NSMutableArray alloc] init]autorelease];
	[hand release];
	
	
	/*
	 * initialize Opponent 
	
	Player *opponent=[[Player alloc] initWithHand:handOp];
	opponent.name=[NSString stringWithFormat:@"player2"];
	opponent.health=100;
	opponent.deck=deckOp;
	[deckOp release];
	opponent.cemetery=[[[NSMutableArray alloc] init] autorelease];
	[handOp release];
	 */
	
	ComunicatioLayer *comPlayer=[[[ComunicatioLayer alloc] init]autorelease];
	[comPlayer connect];
	//[];
	/*
	 * initialize game
	 */
	//gameplayPlayer =[[Game alloc] initWithPlayer:player opponent:[Player playerWithPlayer:opponent] andImFirst:YES];
	//gameplayOpponent =[[Game alloc] initWithPlayer:opponent opponent:[Player playerWithPlayer:player] andImFirst:NO];
	
	/*
	 *	release all
	 */
	[player release];
	//[opponent release];	
	
	
	//ComunicatioLayer *comOpponent=[[[ComunicatioLayer alloc] init]autorelease];
	
	/*
	 * link game play to communication
	 */
	comPlayer.gameplay=gameplayPlayer;
	comPlayer.comLayer=comPlayer;
	
	//comOpponent.gameplay=gameplayOpponent;
	//comOpponent.comLayer=comPlayer;

	gameplayPlayer.comunication=comPlayer;
	//gameplayOpponent.comunication=comOpponent;
	
	theScroller = [[ScrollerViewController scrollerController] retain];
	[window addSubview:theScroller.view];
	
	theScroller.playerOneInterface.gameplay = gameplayPlayer;
	gameplayPlayer.interface = theScroller.playerOneInterface;
	
	theScroller.playerTwoInterface.gameplay = gameplayOpponent;
	gameplayOpponent.interface = theScroller.playerTwoInterface;
	
	[gameplayPlayer setupState];
	//[gameplayOpponent setupState];	
	
	[gameplayPlayer start];
	//[gameplayOpponent start];
}

- (void)dealloc;
{
	[gameplayPlayer release];
	//[gameplayOpponent release];
	[theScroller release];
    [window release];
    [super dealloc];
}

@end

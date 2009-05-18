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

- (void)applicationDidFinishLaunching:(UIApplication *)application;
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window makeKeyAndVisible];
	
	/*
	 *Card creation
	 */
	Card *fireElemental=[[Card alloc] initWithName:@"eatFire" image:@"cardTest1" element:CardElementFire type:CardTypeElement level:1];
	Card *windElemental=[[Card alloc] initWithName:@"etchù" image:@"cardTest1" element:CardElementWind type:CardTypeElement level:1];
	Card *waterElemental=[[Card alloc] initWithName:@"beerDrinker" image:@"cardTest1" element:CardElementWater type:CardTypeElement level:1];
	Card *earthElemental=[[Card alloc] initWithName:@"googleEarth" image:@"cardTest1" element:CardElementEarth type:CardTypeElement level:1];
	Card *voidElemental=[[Card alloc] initWithName:@"ciSonoStorieCheNonEsistono" image:@"cardTest1" element:CardElementVoid type:CardTypeElement level:1];
	Card *fireElemental2=[[Card alloc] initWithName:@"eatFire" image:@"cardTest1" element:CardElementFire type:CardTypeElement level:1];
	Card *windElemental2=[[Card alloc] initWithName:@"etchù" image:@"cardTest1" element:CardElementWind type:CardTypeElement level:1];
	Card *waterElemental2=[[Card alloc] initWithName:@"beerDrinker" image:@"cardTest1" element:CardElementWater type:CardTypeElement level:1];
	Card *earthElemental2=[[Card alloc] initWithName:@"googleEarth" image:@"cardTest1" element:CardElementEarth type:CardTypeElement level:1];
	Card *voidElemental2=[[Card alloc] initWithName:@"ciSonoStorieCheNonEsistono" image:@"cardTest1" element:CardElementVoid type:CardTypeElement level:1];
	
	Card *fireElementalOp=[[Card alloc] initWithName:@"eatFire" image:@"cardTest2" element:CardElementFire type:CardTypeElement level:1];
	Card *windElementalOp=[[Card alloc] initWithName:@"etchù" image:@"cardTest2" element:CardElementWind type:CardTypeElement level:1];
	Card *waterElementalOp=[[Card alloc] initWithName:@"beerDrinker" image:@"cardTest2" element:CardElementWater type:CardTypeElement level:1];
	Card *earthElementalOp=[[Card alloc] initWithName:@"googleEarth" image:@"cardTest2" element:CardElementEarth type:CardTypeElement level:1];
	Card *voidElementalOp=[[Card alloc] initWithName:@"ciSonoStorieCheNonEsistono" image:@"cardTest2" element:CardElementVoid type:CardTypeElement level:1];
	Card *fireElementalOp2=[[Card alloc] initWithName:@"eatFire" image:@"cardTest2" element:CardElementFire type:CardTypeElement level:1];
	Card *windElementalOp2=[[Card alloc] initWithName:@"etchù" image:@"cardTest2" element:CardElementWind type:CardTypeElement level:1];
	Card *waterElementalOp2=[[Card alloc] initWithName:@"beerDrinker" image:@"cardTest2" element:CardElementWater type:CardTypeElement level:1];
	Card *earthElementalOp2=[[Card alloc] initWithName:@"googleEarth" image:@"cardTest2" element:CardElementEarth type:CardTypeElement level:1];
	Card *voidElementalOp2=[[Card alloc] initWithName:@"ciSonoStorieCheNonEsistono" image:@"cardTest2" element:CardElementVoid type:CardTypeElement level:1];
	
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
	Player *player=[[Player alloc] init];
	player.name=[NSString stringWithFormat:@"player ruttincul"];
	player.health=100;
	player.deck=deck;
	[deck release];
	player.cemetery=[[[NSMutableArray alloc] init]autorelease];
	player.hand=hand;
	[hand release];
	
	
	/*
	 * initialize Opponent 
	 */
	Player *opponent=[[Player alloc] init];
	opponent.name=[NSString stringWithFormat:@"opponent sisi"];
	opponent.health=100;
	opponent.deck=deckOp;
	[deckOp release];
	opponent.cemetery=[[[NSMutableArray alloc] init] autorelease];
	opponent.hand=handOp;
	[handOp release];
	
	/*
	 * initialize game
	 */
	gameplayPlayer =[[Game alloc] initWithPlayer:player opponent:opponent andImFirst:YES];
	gameplayOpponent =[[Game alloc] initWithPlayer:opponent opponent:player andImFirst:NO];
	ComunicatioLayer *comPlayer=[[[ComunicatioLayer alloc] init]autorelease];
	ComunicatioLayer *comOpponent=[[[ComunicatioLayer alloc] init]autorelease];
	/*
	 * link game play to comLayer
	 */
	comPlayer.gameplay=gameplayPlayer;
	comPlayer.comLayer=comOpponent;
	
	comOpponent.gameplay=gameplayOpponent;
	comOpponent.comLayer=comPlayer;

	gameplayPlayer.comLayer=comPlayer;
	gameplayOpponent.comLayer=comOpponent;
	
	/*
	 *	release all
	 */
	[player release];
	[opponent release];
	
	//we need a scroller view on which add the two inteface
	[window addSubview:gameplayPlayer.interface.view];
	//[window addSubview:gameplayOpponent.interface.view];
	
	[gameplayPlayer setupState];
	[gameplayOpponent setupState];
	
}

- (void)dealloc;
{
	[gameplayPlayer release];
	[gameplayOpponent release];
    [window release];
    [super dealloc];
}

@end

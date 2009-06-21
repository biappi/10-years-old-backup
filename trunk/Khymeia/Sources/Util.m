//
//  Util.m
//  Khymeia
//
//  Created by Alessio Bonu on 11/06/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "Util.h"


@implementation Util

/**
 * Funzioni base
 */

/**
 * Sceglie un elemento bersglio in base ai parametri
 * @param Stato stato lo stato attuale
 * @param Tipo tipo il tipo di elemento (Air, Water, ...). Se null, non importa quale sia il tipo
 * @param int potere_min il potere minimo che deve avere l'elemento
 * @param int potere_max il potere massimo che deve avere l'elemento
 * @param Player giocatore il giocatore a cui deve appartenere l'elemento. Se null, non importa quale sia il giocatore
 * @return Bersaglio i bersagli possibili, o null se non ce ne sono
 */
+(AvailableTargets*) findTargetElementsForState:(State*)aState andType:(CardElement) type andMinPower:(NSInteger)min_power andMaxPower:(NSInteger)max_power ofPlayerKind:(PlayerKind)player;

{
	//create a string with type, min_power, max_power and player
	NSString* p;
	switch (player) 
	{
		case PlayerKindPlayer:
			p= [NSString stringWithFormat:@" you own"];
			break;
		case PlayerKindOpponent:
			p= [NSString stringWithFormat:@" your opponent own"];
			break;
		case PlayerKindBoth:
			p= @"";
			break;
	}		
	
	
	NSString *stype;
	switch (type) 
	{
		case CardElementAny:
			stype= [NSString stringWithFormat:@"any"];
			break;
		case CardElementFire:
			stype= [NSString stringWithFormat:@"a Fire"];
			break;
		case CardElementWind:
			stype= [NSString stringWithFormat:@"a Wind"];
			break;
		case CardElementWater:
			stype= [NSString stringWithFormat:@"a Water"];
			break;
		case CardElementEarth:
			stype= [NSString stringWithFormat:@"an Earth"];
			break;
	}
	NSString *sMinP;
	if(min_power>0)
		sMinP=[NSString stringWithFormat:@"greater than %d",min_power];
	else
		sMinP=@"";
	NSString *sMaxP;
	if(max_power>0)
		sMaxP=[NSString stringWithFormat:@"lower than %d",max_power];
	else
		sMaxP=@"";
	NSString *message;
	if(max_power>0 && min_power >0)
		message=[NSString stringWithFormat:@"Choose %@ element%@ with level %@ and %@.",stype,p,sMinP,sMaxP];
	else if(max_power + min_power > 0)
		message=[NSString stringWithFormat:@"Choose %@ element%@ with level %@%@.",stype,p,sMinP,sMaxP];
	else 
		message=[NSString stringWithFormat:@"Choose %@ element%@.",stype,p];
	NSMutableArray *arrayOfAvaibleTargets =[[NSMutableArray alloc] init];
	if(player ==PlayerKindPlayer || player==PlayerKindBoth)
		for(Card* c in [[aState player] playArea] )
		{
			if((type==CardElementAny || c.element== type) &&
					(min_power == 0 || c.level >=min_power) &&
					(max_power ==0 || c.level <=max_power))
				[arrayOfAvaibleTargets addObject:c];
		}
	if(player ==PlayerKindOpponent || player==PlayerKindBoth)
		for(Card* c in [[aState opponent] playArea] )
		{
			if((type==CardElementAny || c.element== type) &&
			   (min_power == 0 || c.level >=min_power) &&
			   (max_power ==0 || c.level <=max_power))
				[arrayOfAvaibleTargets addObject:c];
		}
	if([arrayOfAvaibleTargets count]>0)
	{
		AvailableTargets* targets=[[AvailableTargets alloc] initWithCard:arrayOfAvaibleTargets andNumber:1 andDescription:message];
		return targets;
	}
	else
		return nil;
	
}


+(AvailableTargets*) findCardsInHandOfPlayer:(PlayerKind) player andState:(State*)aState andMessage:(NSString*)message;
{

	NSMutableArray *arrayOfAvaibleTargets=[[NSMutableArray alloc] init];
	if(player ==PlayerKindPlayer || player==PlayerKindBoth)
		for(Card* c in [[aState player] hand] )
		{
				[arrayOfAvaibleTargets addObject:c];
		}
	if(player ==PlayerKindOpponent || player==PlayerKindBoth)
		for(Card* c in [[aState opponent] hand] )
		{
				[arrayOfAvaibleTargets addObject:c];
		}
	
	if([arrayOfAvaibleTargets count]>0)
	{
		AvailableTargets* targets=[[AvailableTargets alloc] initWithCard:arrayOfAvaibleTargets andNumber:1 andDescription:message];
		return targets;
	}
	else
		return nil;
}

/**
 * Distrugge tutti gli elementi indicati come bersaglio
 * @param Bersaglio bersagli i bersagli da distruggere
 */

/*public static void sacrifica(bersaglio)
{
	foreach(bersaglio.CardList[] as c) 
	{
		c.destroy();
	}
}
*/



@end

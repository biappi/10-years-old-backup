//
//  Util.h
//  Khymeia
//
//  Created by Alessio Bonu on 11/06/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "State.h"
#import "Player.h"
#import "AvailableTargets.h"




@interface Util : NSObject {

}


+(AvailableTargets*)findTargetElementsForState:(State*)aState andType:(CardElement) type andMinPower:(NSInteger)min_power andMaxPower:(NSInteger)max_power ofPlayerKind:(PlayerKind)player;

+(AvailableTargets*) findCardsInHandOfPlayer:(PlayerKind) player andState:(State*)state andMessage:(NSString *)message;



@end

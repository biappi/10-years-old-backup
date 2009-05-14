//
//  ComunicatioLayer.h
//  Khymeia
//
//  Created by Alessio Bonu on 14/05/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Player.h"


@interface ComunicatioLayer : NSObject 
{

}

-(BOOL)willSendDidPlayCard:(Card*)card onCard:(Card*)oncard;

-(BOOL)willSendDidPlayCard:(Card*)card onPlayer:(Player *)player;

-(BOOL)willSendDidPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;

@end

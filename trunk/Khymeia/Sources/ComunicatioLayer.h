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
#import "ComunicationToGameplayProtocol.h"


@interface ComunicatioLayer : NSObject 
{
	id<ComunicationToGameplayProtocol> gameplay;
}

@property (nonatomic, retain) id gameplay;
-(BOOL)sendDidPlayCard:(Card*)card onCard:(Card*)oncard;

-(BOOL)sendDidPlayCard:(Card*)card onPlayer:(Player *)player;

-(BOOL)sendDidPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;

-(BOOL)sendWillPlayCard:(Card*)card onCard:(Card*)oncard;

-(BOOL)sendWillPlayCard:(Card*)card onPlayer:(Player *)player;

-(BOOL)sendWillPlayCard:(Card*)aCard onCard:(Card*)otherCard withGesture:(BOOL)completed;


@end

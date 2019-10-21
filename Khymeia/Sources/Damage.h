//
//  Damage.h
//  Khymeia
//
//  Created by Alessio Bonu on 11/06/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Damage : NSObject 
{
	Card *source;
	CardElement type;
	NSInteger amount;
}

@property (nonatomic,retain) Card*source;
@property (nonatomic,assign) CardElement type;
@property (nonatomic,assign)NSInteger amount;

-(id)initWithSourceCard:(Card*)card andType:(CardElement)type andAmmount:(NSInteger)amm;

@end

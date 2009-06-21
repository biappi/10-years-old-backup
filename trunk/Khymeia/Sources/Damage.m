//
//  Damage.m
//  Khymeia
//
//  Created by Alessio Bonu on 11/06/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "Damage.h"


@implementation Damage

@synthesize source;
@synthesize type;
@synthesize amount;

-(id)initWithSourceCard:(Card*)card andType:(CardElement)t andAmmount:(NSInteger)am;
{
	if(self=[super init])
	{
		self.source=card;
		self.type=t;
		self.amount=am;
	}
	return self;
}

@end

//
//  SlotLayer.h
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 14/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>

@interface SlotLayer : CALayer
{
	BOOL slotHighlight;
}

@property(nonatomic, assign) BOOL slotHighlight;

@end

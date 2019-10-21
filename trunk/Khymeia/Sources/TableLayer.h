//
//  TableLayer.h
//  Khymeia
//
//  Created by Pasquale Anatriello on 02/07/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>


@interface TableLayer : CALayer
{
	BOOL slotHighlight;
}

@property(nonatomic, assign) BOOL slotHighlight;

@end

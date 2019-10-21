//
//  CGPointAdditions.h
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 14/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#include <UIKit/UIKit.h>

static inline CGPoint CGPointSum(CGPoint a, CGPoint b)
{
	CGPoint res;
	res.x = a.x + b.x;
	res.y = a.y + b.y;
	return res;
}

static inline CGPoint CGPointDifference(CGPoint a, CGPoint b)
{
	CGPoint res;
	res.x = a.x - b.x;
	res.y = a.y - b.y;
	return res;
}
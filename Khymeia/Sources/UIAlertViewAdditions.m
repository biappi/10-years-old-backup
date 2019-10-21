//
//  UIAlertViewAdditions.m
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 14/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIAlertViewAdditions.h"

@implementation UIAlertView (KhymeiaAdditions)

+ (void) presentInfoAlertViewWithTitle:(NSString *)title description:(NSString *)description;
{
	UIAlertView * alert;
	alert = [[UIAlertView alloc] initWithTitle:title
									   message:description
									  delegate:nil
							 cancelButtonTitle:@"Dismiss"
							 otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end

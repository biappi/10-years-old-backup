//
//  LoggerView.m
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 01/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoggerView.h"

@implementation LoggerView

@synthesize statusButton;

- (id)initWithFrame:(CGRect)frame;
{
    if ((self = [super initWithFrame:frame]) == nil)
		return nil;
			
	statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
	statusButton.frame = CGRectMake(0, 0, frame.size.width, 20);
	statusButton.backgroundColor = [UIColor colorWithWhite:0.60 alpha:1];
	
	textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height - 20)];
	textView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
	textView.font = [UIFont fontWithName:@"Helvetica" size:15];
	textView.editable = NO;
	
	[self addSubview:statusButton];
	[self addSubview:textView];
	
    return self;
}

- (void)dealloc;
{
	[textView release];
	[statusButton release];
	[super dealloc];
}

- (void)setStatus:(NSString *)statusString;
{
	//statusButton.titleLabel.text = statusString;
	[statusButton setTitle:statusString forState:UIControlStateNormal];
}

- (void)log:(NSString *)logLine; 
{
	textView.text = [NSString stringWithFormat:@"%@\n%@", textView.text, logLine];
	textView.contentOffset = CGPointMake(0, textView.contentSize.height - textView.bounds.size.height);
}

- (void)setHighlight:(BOOL)x;
{
	[UIView beginAnimations:nil context:nil];
	statusButton.backgroundColor = (x)? [UIColor colorWithRed:0xCC / 255.0 green:0 blue:0 alpha:1] : [UIColor colorWithWhite:0.60 alpha:0.7];
	[UIView commitAnimations];
	highlighted = x;
}

- (BOOL)highlight;
{
	return highlighted;
}

@end
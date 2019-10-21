//
//  ScrollerViewController.m
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 01/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScrollerViewController.h"

#pragma mark KhymeiaScrollView

@interface KhymeiaScrollView : UIScrollView
{
	ScrollerViewController * controller;
}

@property(nonatomic, assign) ScrollerViewController * controller;

@end

@implementation KhymeiaScrollView

@synthesize controller;

- (BOOL)touchesShouldCancelInContentView:(UIView *)view;
{
	return (controller.playerOneInterface.interfaceIsBusy == NO) && (controller.playerTwoInterface.interfaceIsBusy == NO);
}

@end

#pragma mark -
#pragma mark ScrollerViewController Implementation

@implementation ScrollerViewController

@synthesize playerOneInterface;
@synthesize playerTwoInterface;
@synthesize loggerView;

+ (ScrollerViewController *) scrollerController;
{
	return [[[ScrollerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
}

- (id)initWithNibName:(id)name bundle:(id)bundle;
{
	if ((self = [super initWithNibName:nil bundle:nil]) == nil)
		return nil;
	
	playerOneInterface = [[InterfaceController alloc] init];
	playerTwoInterface = [[InterfaceController alloc] init];
	
	return self;
}

- (void)dealloc;
{
    [super dealloc];
}

- (void)loadView;
{	
	UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
	
	KhymeiaScrollView * scrollView;
	scrollView = [[KhymeiaScrollView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
	scrollView.contentSize = CGSizeMake(480, 320 * 2);
	scrollView.contentOffset = CGPointMake(0, 320);
	scrollView.pagingEnabled = YES;
	scrollView.controller = self;
	
	playerOneInterface.view.frame = CGRectMake(0, 320, 480, 320);
	playerTwoInterface.view.frame = CGRectMake(0,   0, 480, 320);
	
	playerTwoInterface.view.backgroundColor = [UIColor colorWithWhite:0.50 alpha:1];
	
	[scrollView addSubview:playerOneInterface.view];
	[scrollView addSubview:playerTwoInterface.view];

	[view addSubview:scrollView];
	
	loggerView = [[LoggerView alloc] initWithFrame:CGRectMake(0, 320 - 20, 480, 320 / 2 + 20)];
	logCollapsed = YES;
	[view addSubview:loggerView];
	[loggerView.statusButton addTarget:self action:@selector(showHideLog) forControlEvents:UIControlEventTouchUpInside];
	
	self.view = view;
	
	[scrollView release];
}

- (void)viewDidUnload;
{
	[playerOneInterface release];
	[playerTwoInterface release];
	[loggerView release];
	
	playerOneInterface = nil;
	playerTwoInterface = nil;
	loggerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)showHideLog;
{
	CGRect logFrame = loggerView.frame;
	
	logFrame.origin.y = (logCollapsed)? 320 / 2 - 20 : 320 - 20;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	loggerView.frame = logFrame;
	[UIView commitAnimations];

	if (logCollapsed == NO)
		loggerView.highlight = NO;
	
	logCollapsed = !logCollapsed;
}

@end
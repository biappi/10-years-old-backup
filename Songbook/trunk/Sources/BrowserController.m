//
//  BrowserController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 29/7/09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

// Thanks Colloquy Guys!

#import "BrowserController.h"
#import "PRODownloader.h"

@interface NSString (Additions)

- (BOOL) isCaseInsensitiveEqualToString:(NSString *) string;

@end


@implementation NSString (Additions)

- (BOOL) isCaseInsensitiveEqualToString:(NSString *) string;
{
	return [self compare:string options:NSCaseInsensitiveSearch range:NSMakeRange( 0, [self length] )] == NSOrderedSame;
}

@end

@implementation BrowserController

- (id)init;
{
	if (!(self = [super initWithNibName:@"Browser" bundle:nil]))
		return nil;
	
	self.hidesBottomBarWhenPushed = YES;
	
	return self;
}

- (void)dealloc;
{
	webView.delegate = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[backButton release];
	[stopReloadButton release];
	[locationField release];
	[webView release];
	[toolbar release];
	[_urlToLoad release];

	[super dealloc];
}

#pragma mark -

- (void)viewDidLoad;
{
	[super viewDidLoad];

	locationField.font = [UIFont systemFontOfSize:15.];
	locationField.clearsOnBeginEditing = NO;
	locationField.clearButtonMode = UITextFieldViewModeWhileEditing;

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Force Import"
																			  style:UIBarButtonItemStyleBordered
																			 target:self
																			 action:@selector(importChordPro)] autorelease];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

	if (_urlToLoad.absoluteString.length)
	{
		[self loadURL:_urlToLoad];
		[_urlToLoad release];
		_urlToLoad = nil;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
	return (UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)loadURL:(NSURL *) url;
{
	if (!webView)
	{
		id old = _urlToLoad;
		_urlToLoad = [url retain];
		[old release];
		return;
	}

	if (!url)
		return;

	locationField.text = url.absoluteString;		
	[webView loadRequest:[NSMutableURLRequest requestWithURL:url]];
}

- (void)goBack:(id) sender;
{
	[webView goBack];

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
	[self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];
}

- (void)reloadOrStop:(id) sender;
{
	if (webView.loading)
		[webView stopLoading];
	else
		[webView reload];
}

- (void)openInSafari:(id)sender;
{
	[[UIApplication sharedApplication] openURL:self.url];
}

- (NSURL *)url;
{
	NSURL * url = [NSURL URLWithString:locationField.text];
	
	if (!url.scheme.length && locationField.text.length)
		url = [NSURL URLWithString:[@"http://" stringByAppendingString:locationField.text]];
	
	return url;
}

#pragma mark -

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	NSURL *url = [NSURL URLWithString:locationField.text];
	if (!url.scheme.length) url = [NSURL URLWithString:[@"http://" stringByAppendingString:locationField.text]];

	[self loadURL:url];

	[locationField resignFirstResponder];

	return YES;
}

#pragma mark -

- (void) updateLocationField;
{
	NSString *location = webView.request.URL.absoluteString;
	
	if ([location isCaseInsensitiveEqualToString:@"about:blank"])
		locationField.text = @"";
	else if (location.length)
		locationField.text = webView.request.URL.absoluteString;
}

- (void) updateLoadingStatus;
{
	UIImage *image = nil;
	
	if (webView.loading)
	{
		image = [UIImage imageNamed:@"browserStop.png"];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	} else {
		image = [UIImage imageNamed:@"browserReload.png"];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}

	[stopReloadButton setImage:image forState:UIControlStateNormal];
}

#pragma mark -

- (void) webViewDidStartLoad:(UIWebView *) sender;
{
	[self updateLoadingStatus];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkLodedPage) object:nil];
	[self performSelector:@selector(checkLodedPage) withObject:nil afterDelay:0.5];
}

- (void) webViewDidFinishLoad:(UIWebView *) sender;
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
	[self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLoadingStatus) object:nil];
	[self performSelector:@selector(updateLoadingStatus) withObject:nil afterDelay:1.];
	
	[self performSelector:@selector(checkLodedPage) withObject:nil afterDelay:0];
}

- (void) webView:(UIWebView *) sender didFailLoadWithError:(NSError *) error;
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
	[self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLoadingStatus) object:nil];
	[self performSelector:@selector(updateLoadingStatus) withObject:nil afterDelay:1.];
	
	[self performSelector:@selector(checkLodedPage) withObject:nil afterDelay:0];
}

#pragma mark -

- (void) checkLodedPage;
{
	if (stringMayBePRO([webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]))
	{
		isChordPro = YES;
		[chordProInfoButton setTitle:@"This page contain a Chord Pro file! Click to import" forState:UIControlStateNormal];
		chordProInfoButton.backgroundColor = [UIColor colorWithRed:102/255.0 green:255/255.0 blue:102/255.0 alpha:1];
		self.navigationItem.rightBarButtonItem.title = @"Import";		
	} else {
		isChordPro = NO;
		[chordProInfoButton setTitle:@"This page does not contain a chord pro file, click here for help" forState:UIControlStateNormal];
		chordProInfoButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1];
		self.navigationItem.rightBarButtonItem.title = @"Force Import";
	}	
}

- (void) importChordPro;
{
	
}

#pragma mark -

- (void)keyboardWillShow:(NSNotification *)noti;
{
	CGRect keyBounds = [[[noti userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect viewFrame = self.view.frame;
	CGRect webFrame  = webView.frame;
	
	viewFrame.size.height -= keyBounds.size.height;
	webFrame.size.height  += chordProInfoButton.frame.size.height;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	
#if defined(TARGET_IPHONE_SIMULATOR) && TARGET_IPHONE_SIMULATOR
	[UIView setAnimationDelay:0.06];
#else
	[UIView setAnimationDelay:0.175];
#endif

	webView.frame   = webFrame;	
	self.view.frame = viewFrame;
	chordProInfoButton.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)noti;
{
	CGRect keyBounds = [[[noti userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect viewFrame = self.view.frame;
	CGRect webFrame  = webView.frame;
	
	viewFrame.size.height += keyBounds.size.height;
	webFrame.size.height  -= chordProInfoButton.frame.size.height;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	
#if defined(TARGET_IPHONE_SIMULATOR) && TARGET_IPHONE_SIMULATOR
	[UIView setAnimationDelay:0.06];
#else
	[UIView setAnimationDelay:0.175];
#endif

	webView.frame   = webFrame;	
	self.view.frame = viewFrame;
	chordProInfoButton.alpha = 1;
	
	[UIView commitAnimations];
}

@end

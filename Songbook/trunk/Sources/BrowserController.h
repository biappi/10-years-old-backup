//
//  BrowserController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 29/7/09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

// Thanks Colloquy Guys!

@interface BrowserController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{
	IBOutlet UIButton    * backButton;
	IBOutlet UIButton    * chordProInfoButton;
	IBOutlet UIButton    * stopReloadButton;
	IBOutlet UITextField * locationField;
	IBOutlet UIWebView   * webView;
	IBOutlet UIToolbar   * toolbar;

	NSURL * _urlToLoad;
	BOOL    isChordPro;
}

@property (nonatomic, retain, setter=loadURL:) NSURL *url;

- (void) loadURL:(NSURL *) url;

- (IBAction) goBack:(id) sender;
- (IBAction) reloadOrStop:(id) sender;
- (IBAction) openInSafari:(id) sender;

@end

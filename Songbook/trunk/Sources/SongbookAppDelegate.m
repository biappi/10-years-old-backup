//
//  SongbookAppDelegate.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 21/12/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "SongbookAppDelegate.h"
#import "PRODownloader.h"
#import "AddSongController.h"

@implementation SongbookAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application;
{
	mainController = [[MainTabController alloc] init];

	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window addSubview:mainController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc;
{
	[mainController release];
    [window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
{
	NSString * urlString = [[url absoluteString] stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"http"];
	
	[mainController presentAddSongWithURL:urlString];
	return YES;
}

@end

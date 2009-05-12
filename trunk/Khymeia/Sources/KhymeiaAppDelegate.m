//
//  KhymeiaAppDelegate.m
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright Università di Pisa 2009. All rights reserved.
//

#import "KhymeiaAppDelegate.h"

@implementation KhymeiaAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application;
{
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (void)dealloc;
{
    [window release];
    [super dealloc];
}

@end

//
//  KhymeiaAppDelegate.h
//  Khymeia
//
//  Created by Luca Bartoletti on 12/05/09.
//  Copyright Università di Pisa 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "ScrollerViewController.h"

@interface KhymeiaAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow         * window;
	Game			 * gameplayPlayer;
	Game			 * gameplayOpponent;
	ScrollerViewController * theScroller;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;

@end


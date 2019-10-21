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
@property (nonatomic, readonly) ScrollerViewController * theScroller; //< exposed only for the logger

// todo: we should make a parent UIViewController that will contains all menus etc
//       INCLUDING this viewcontroller and that will be the right place for the logger
//       (see also KhymeiaAppDelegate)


@end


//
//  ScrollerViewController.h
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 01/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceController.h"

@interface ScrollerViewController : UIViewController
{
	InterfaceController * playerOneInterface;
	InterfaceController * playerTwoInterface;
}

@property(nonatomic, readonly) InterfaceController * playerOneInterface;
@property(nonatomic, readonly) InterfaceController * playerTwoInterface;

+ (ScrollerViewController *) scrollerController;

@end

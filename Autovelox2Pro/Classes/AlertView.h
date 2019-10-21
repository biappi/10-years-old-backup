//
//  AlertView.h
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 24/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlertView : UIView {
	int distance;
	UILabel *dist;
	UILabel *uniN;
	UILabel *distN;
	UILabel *type;
	NSString *tipo;
	NSString *descr;
	UILabel *description;
}

@property (nonatomic,assign) int distance;
@property (nonatomic,retain) NSString * tipo;
@property (nonatomic,retain) NSString * descr;

@end

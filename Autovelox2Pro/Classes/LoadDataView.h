//
//  LoadDataView.h
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 28/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadDataView : UIImageView {

	int line;
	int lines;
	double animDur;
	int partial;
	UIImageView *car;
}

	-(void)animat;

@property (nonatomic,assign) double animDur;
@property (nonatomic,assign) int line;
@property (nonatomic,assign) int lines;

@end

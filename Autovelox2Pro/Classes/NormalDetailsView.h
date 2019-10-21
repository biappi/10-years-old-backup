//
//  NormalDetailsView.h
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 23/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NormalDetailsView : UIView {
	int numberOfAutovelox;
	UILabel *noa;
}
- (void) update; 
@property (nonatomic,assign) int numberOfAutovelox;

@end

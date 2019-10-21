//
//  LoggerView.h
//  Khymeia
//
//  Created by Antonio "Willy" Malara on 01/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoggerView : UIView
{
	UIButton   * statusButton;
	UITextView * textView;
	BOOL         highlighted;
}

@property(nonatomic, readonly) UIButton * statusButton;
@property(nonatomic) BOOL highlight;

- (void)setStatus:(NSString *)statusString;
- (void)log:(NSString *)logLine; 

@end

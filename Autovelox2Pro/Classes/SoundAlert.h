//
//  SoundAlert.h
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 31/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundAlert : NSObject <AVAudioPlayerDelegate>
{
	AVAudioPlayer* _player;	
	UILabel* _fileName;
}

@property (nonatomic, assign) AVAudioPlayer*	_player;
@property (nonatomic, retain) UILabel*			_fileName;


- (void)playButtonPressed;

@end

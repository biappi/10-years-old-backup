//
//  SoundAlert.m
//  Autovelox2Pro
//
//  Created by Alessio Bonu on 31/08/09.
//  Copyright 2009 Navionics. All rights reserved.
//

#import "SoundAlert.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundAlert(PrivateMethods)

- (void)updateViewForPlayerInfo;

- (void)updateViewForPlayerState;

- (void)pausePlayback;

- (void)startPlayback;


@end


@implementation SoundAlert

@synthesize _player, _fileName;


-(id)init;
{
	if (self = [super init]) {
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"alarm_1" ofType:@"mp3"]];
		self._player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];	
		if (self._player)
		{
			_fileName.text = [NSString stringWithFormat: @"%@ (%d ch.)", [[self._player.url relativePath] lastPathComponent], self._player.numberOfChannels, nil];
			//[self updateViewForPlayerInfo];
			//[self updateViewForPlayerState];
		}
		
		[fileURL release];
    }
    return self;
}

- (void)pausePlayback;
{
	[self._player pause];
	//[self updateViewForPlayerState];
}
- (void)startPlayback;
{
	if ([self._player play])
	{
		//[self updateViewForPlayerState];
		self._player.delegate = self;
	}
	else
		NSLog(@"Could not play %@\n", self._player.url);
}

- (void)playButtonPressed;
{
	if (self._player.playing == YES)
		[self pausePlayback];
	else
		[self startPlayback];
}

#pragma mark AVAudioPlayer delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
	
	//[player setCurrentTime:0.];
	//[self updateViewForPlayerState];
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	NSLog(@"ERROR IN DECODE: %@\n", error); 
}

// we will only get these notifications if playback was interrupted
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	// the object has already been paused,	we just need to update UI
	//[self updateViewForPlayerState];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	[self startPlayback];
}




@end

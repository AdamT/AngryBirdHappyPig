//
//  ViewController.h
//  AngryBirdHappyPig
//
//  Created by Adam Tal on 7/27/13.
//  Copyright (c) 2013 Adam Tal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController {
    
    AVAudioPlayer *backgroundPlayer;
    AVAudioPlayer *flySoundPlayer;
    
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *restartButton;
    
    NSTimer *birdTimer;
    NSTimer *angerTimer;
    
    CGPoint redrawMovement;
    
    IBOutlet UIImageView *angryBird;
    IBOutlet UIImageView *happyPig;
    
    double updateTimeInterval;
    int seconds;
    
    int changeDirectionCount;
}

- (IBAction)start;
- (IBAction)restart:(id)sender;

@end

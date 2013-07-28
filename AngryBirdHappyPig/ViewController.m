//
//  ViewController.m
//  AngryBirdHappyPig
//
//  Created by Adam Tal on 7/27/13.
//  Copyright (c) 2013 Adam Tal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    redrawMovement = CGPointMake(5.0, 4.0);
    changeDirectionCount = 0;
    
    NSString *angryBirdsBackGroundFile = [[NSBundle mainBundle]pathForResource:@"AngryBirdsTheme" ofType:@"mp3"];
    backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:angryBirdsBackGroundFile] error:NULL];
    [backgroundPlayer play];
    
    NSString *angryBirdsFlySoundFile = [[NSBundle mainBundle]pathForResource:@"angry-birds-bird-fly-sound-effect" ofType:@"mp3"];
    flySoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:angryBirdsFlySoundFile] error:NULL];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// clicking on start button
-(IBAction)start
{
    [startButton setHidden:YES];
    [self startAngryGame];
    updateTimeInterval = 0.05;
    birdTimer = [NSTimer scheduledTimerWithTimeInterval:updateTimeInterval
                                                  target:self
                                                selector:@selector(moveBird)
                                                userInfo:nil
                                                 repeats:YES];
    [backgroundPlayer stop];

}

// clicking on restart button
- (IBAction)restart:(id)sender {
    
    [self resetTimers];

    [self resetButton];

    [self resetViewObjects];

    [self resetVariables];

    [backgroundPlayer stop];

    [backgroundPlayer play];

}

- (void)resetViewObjects {
    CGRect pigCGRect = [happyPig frame];
    pigCGRect.origin.x = 134.0f;
    pigCGRect.origin.y = 470.0f;
    [happyPig setFrame:pigCGRect];
    
    CGRect birdCGRect = [angryBird frame];
    birdCGRect.origin.x = 135.0f;
    birdCGRect.origin.y = 20.0f;
    [angryBird setFrame:birdCGRect];
}

- (void)resetButton {
    [startButton setHidden:NO];
}

- (void)resetTimers {
    [birdTimer invalidate];
    [angerTimer invalidate];
}

- (void)resetVariables {
    seconds = 0;
    redrawMovement = CGPointMake(5.0, 4.0);
    changeDirectionCount = 0;
    angryBird.transform = CGAffineTransformMakeScale(1, 1);
    backgroundPlayer.currentTime = 0;
}

-(void)startAngryGame
{
    angerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(increaseTimerCount)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:angerTimer forMode:NSRunLoopCommonModes];
    
}

- (void)increaseTimerCount
{
    
    seconds = seconds + 1;
    if (seconds % 3 == 0){
        
        updateTimeInterval = updateTimeInterval * 0.75;
        [birdTimer invalidate];
        birdTimer = [NSTimer scheduledTimerWithTimeInterval:updateTimeInterval
                                                      target:self
                                                    selector:@selector(moveBird)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    if (seconds > 25) {
        
        [self resetTimers];
        
        [self resetButton];
        
        [self resetViewObjects];
        
        [self resetVariables];
        
        [self endGameMessage:@"Hurray, you've saved the pig for 25 seconds. Totally worth it." title:@"#winning" buttonTitle:@"I guess I'll play again"];
        
        [backgroundPlayer play];
    }
}

-(void)moveBird
{
    [self checkCollision];
    
    angryBird.center = CGPointMake(angryBird.center.x + redrawMovement.x, angryBird.center.y + redrawMovement.y);

    if (angryBird.center.x > 320 || angryBird.center.x < 0) {
        redrawMovement.x = -redrawMovement.x;
        changeDirectionCount = changeDirectionCount + 1;
        [self changeBirdDirection];

        [flySoundPlayer play];
    }
    
    if (angryBird.center.y > 480 || angryBird.center.y < 0) {
        redrawMovement.y = -redrawMovement.y;
    }
}

- (void)changeBirdDirection {
    
    if (changeDirectionCount % 2 == 0) {
        angryBird.transform = CGAffineTransformMakeScale(1, 1);
    } else {
        angryBird.transform = CGAffineTransformMakeScale(-1, 1);
    }

}

-(void)checkCollision
{
    if (CGRectIntersectsRect(happyPig.frame, angryBird.frame)) {
        [self resetTimers];
        
        [self resetButton];
        
        [self resetViewObjects];
        
        [self resetVariables];

        [self endGameMessage:@"What a catastrophe! That poor poor piggie." title:@"Nooooooooo!" buttonTitle:@"I'll get over it"];
        
        backgroundPlayer.currentTime = 0;
        [backgroundPlayer play];
        
    }
}

- (void)endGameMessage:(NSString *)message title:(NSString *)title buttonTitle:(NSString *)buttonTitle
{    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:buttonTitle
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *userTouch = [[event allTouches] anyObject];
    happyPig.center = [userTouch locationInView:self.view];
}
@end

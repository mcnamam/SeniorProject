//
//  MyScene.h
//  KidologyApp
//

//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>


@interface MainMenuScene : SKScene
@property (nonatomic) SKSpriteNode *babyGameButton;
@property (nonatomic) SKSpriteNode *babyGameButtonPressed;
@property (nonatomic) SKSpriteNode *targetGameButton;
@property (nonatomic) SKSpriteNode *targetGameButtonPressed;
@property (nonatomic) SKSpriteNode *fetchGameButton;
@property (nonatomic) SKSpriteNode *fetchGameButtonPressed;
@property (nonatomic) SKSpriteNode *therapistMenuButton;
@property (nonatomic) SKSpriteNode *therapistMenuButtonPressed;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *therapistEmail;
@property (nonatomic) NSMutableArray *logFiles;
@property (nonatomic) NSMutableArray *zipFilesArray;
@property (nonatomic) UITableView *tbv;
@property (nonatomic) BOOL enableSound;
@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;



@end

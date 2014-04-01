//
//  TargetPracticeScene.h
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    CENTER,
    RANDOM,
    OTHER_ACTION
} Mode;


typedef enum {
    TOUCHING,
    NOT_TOUCHING
} AnchorStatus;



@interface TargetPracticeScene : SKScene <UIGestureRecognizerDelegate>
    {
        UIRotationGestureRecognizer* rotationGR;
        UISwipeGestureRecognizer* swipeRightGesture;
        UISwipeGestureRecognizer* swipeLeftGesture;
        UISwipeGestureRecognizer* swipeUpGesture;
        UISwipeGestureRecognizer* swipeDownGesture;
    }

    @property (nonatomic) SKSpriteNode * anchorPanel;
    @property (nonatomic) SKSpriteNode * target;
    @property (nonatomic) SKLabelNode *targetsLabel;
    @property (nonatomic) int totalTouches;
    @property (nonatomic) int correctTouches;
    @property (nonatomic) int totalTargets;
    @property (nonatomic) float time;
    @property (nonatomic) float time_not_anchored;
    @property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
    @property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
    @property (nonatomic) Mode gameMode;
    @property (nonatomic) AnchorStatus anchored;
    @property (nonatomic) SKSpriteNode *anchor;
    @property (nonatomic) SKSpriteNode *pressedAnchor;
    @property (nonatomic) int numOfRotations;

-(id)initWithSize:(CGSize)size game_mode:(int)game_mode;
@end

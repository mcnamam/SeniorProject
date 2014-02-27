//
//  MyScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameMenuScene.h"


@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        // Hacky arrangement to get menu to look *kind of* how it will eventually look
        // In final project, will be single photoshop image with empty label or sprite node's
        // in same position as photoshop elements
        
        SKSpriteNode *blueSky = [[SKSpriteNode alloc] initWithColor:[SKColor colorWithRed:(0) green:195 blue:255 alpha:1] size:CGSizeMake(2000, 2000)];
        [self addChild:blueSky];
        
        SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"background"];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:CGSizeMake(self.frame.size.width, self.frame.size.height - 50)];
        background.position = CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMidY(self.frame));
        [self addChild:background];

        //add game menu button
        [self addMenuButton];
        //add therapist button
        [self addTherapistButton];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // Check which button was pressed
    if ([node.name isEqualToString:@"gameMenuButton"] ||
        [node.name isEqualToString:@"gameMenuLabel"])
    {
        // Create and configure the "target practice" scene.
        SKScene * gameMenu = [[GameMenuScene alloc] initWithSize:self.size];
        gameMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:gameMenu];
        
    }

}

-(void)addMenuButton
{
    // gameMenu game button
    SKSpriteNode *gameMenuButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    gameMenuButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                           CGRectGetMidY(self.frame) - 150);
    gameMenuButton.name = @"gameMenuButton";
    NSString * gameMenuLabelText = [NSString stringWithFormat:@"Game Menu"];
    SKLabelNode *gameMenuLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameMenuLabel.name = @"gameMenuLabel";
    gameMenuLabel.text = gameMenuLabelText;
    gameMenuLabel.fontSize = 24;
    gameMenuLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame)-158);
    [self addChild:gameMenuButton];
    [self addChild:gameMenuLabel];
}

-(void)addTherapistButton
{
    // therapist button
    SKSpriteNode *therapistButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    therapistButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                           CGRectGetMidY(self.frame) - 200);
    therapistButton.name = @"therapistButton";
    NSString * therapistLabelText = [NSString stringWithFormat:@"Therapist"];
    SKLabelNode *therapistLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    therapistLabel.name = @"therapistLabel";
    therapistLabel.text = therapistLabelText;
    therapistLabel.fontSize = 24;
    therapistLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame)-210);
    [self addChild:therapistButton];
    [self addChild:therapistLabel];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

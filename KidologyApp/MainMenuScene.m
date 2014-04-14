//
//  MyScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MainMenuScene.h"
#import "BabyMenuScene.h"
#import "TargetPracticeMenuScene.h"
#import "FetchScene.h"
#import "TherapistMenuScene.h"
#import "UtilityClass.h"

#import "ZipArchive.h"
#import <MessageUI/MFMailComposeViewController.h>


@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // add game and menu buttons to screen
        [self addBackground];
        [self addBabyGameButton];
        [self addTargetGameButton];
        [self addFetchGameButton];
        [self addTherapistMenuButton];
        // load user settings for therapist upload
        [self loadSettingsInfo];
        // check user name and add user name label to corner
        [self addUserInfo];
        [self addToNotificationCenter];

    }
    return self;
}

// check user name and therapist email before allowing to play a game
- (void)didMoveToView:(SKView *)view
{
    NSLog(@"moved to main menu view");
    [self loadSettingsInfo];
    [UtilityClass checkSettings];
}

-(void)willMoveFromView:(SKView *)view
{
    [self removeFromNotificationCenter];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if one of the buttons is pressed, change its color
    if ([node.name isEqualToString:@"babyGameButton"] ||
        [node.name isEqualToString:@"babyGameButtonPressed"])
    {
        _babyGameButton.hidden = true;
        _babyGameButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"targetGameButton"] ||
             [node.name isEqualToString:@"targetGameButtonPressed"])
    {
        _targetGameButton.hidden = true;
        _targetGameButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
        [node.name isEqualToString:@"fetchGameButtonPressed"])
    {
        _fetchGameButton.hidden = true;
        _fetchGameButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"therapistMenuButton"] ||
             [node.name isEqualToString:@"therapistMenuButtonPressed"])
    {
        _therapistMenuButton.hidden = true;
        _therapistMenuButtonPressed.hidden = false;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch ends */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];

    // Check if one of the buttons was pressed and load that scene
    if ([node.name isEqualToString:@"babyGameButton"] ||
        [node.name isEqualToString:@"babyGameButtonPressed"])
    {
        // reset the button
        _babyGameButton.hidden = false;
        _babyGameButtonPressed.hidden = true;
        
        NSLog(@"checking settings");
        // check if any required settings are missing
        if ([UtilityClass checkSettings])
        {
            NSLog(@"missing a setting");
            return;
        }

        // Create and configure the "baby game" scene.
        SKScene * babyGame = [[BabyMenuScene alloc] initWithSize:self.size];
        babyGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:babyGame transition:reveal];

    }
    else if ([node.name isEqualToString:@"targetGameButton"] ||
             [node.name isEqualToString:@"targetGameButtonPressed"])
    {
        // reset the button
        _targetGameButton.hidden = false;
        _targetGameButtonPressed.hidden = true;
        
        // check if any required settings are missing
        if ([UtilityClass checkSettings])
            return;

        // Create and configure the "game menu" scene.
        SKScene * targetGame = [[TargetPracticeMenuScene alloc] initWithSize:self.size];
        targetGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:targetGame transition:reveal];
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
             [node.name isEqualToString:@"fetchGameButtonPressed"])
    {
        // reset the button
        _fetchGameButton.hidden = false;
        _fetchGameButtonPressed.hidden = true;
        
        // check if any required settings are missing
        if ([UtilityClass checkSettings])
            return;

        // Create and configure the fetch game menu scene.
        SKScene * fetchGame = [[FetchScene alloc] initWithSize:self.size];
        fetchGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:fetchGame transition:reveal];
    }
    else if ([node.name isEqualToString:@"therapistMenuButton"] ||
             [node.name isEqualToString:@"therapistMenuButtonPressed"])
    {
        // reset the button
        _therapistMenuButton.hidden = false;
        _therapistMenuButtonPressed.hidden = true;
        
        // check if any required settings are missing
        if ([UtilityClass checkSettings])
            return;

        NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]   stringByAppendingPathComponent:@"logs"];
        [self listFileAtPath:folderPath];
        NSString *zipFile = [self zipFilesAtPath:folderPath];
        [self emailZipFile:zipFile];
    }
    else
    {
        _targetGameButton.hidden = false;
        _targetGameButtonPressed.hidden = true;
        _babyGameButton.hidden = false;
        _babyGameButtonPressed.hidden = true;
        _fetchGameButton.hidden = false;
        _fetchGameButtonPressed.hidden = true;
        _therapistMenuButton.hidden = false;
        _therapistMenuButtonPressed.hidden = true;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch moves/slides */
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    SKNode *currentNode = [self nodeAtPoint:currentLocation];
    SKNode *previousNode = [self nodeAtPoint:previousLocation];
    
    // Check if one of the buttons was being pressed but isn't any more
    if (currentNode.name == NULL && [self nodeIsButton:previousNode.name])
    {
        NSLog(@"moved off a button");
        _targetGameButton.hidden = false;
        _targetGameButtonPressed.hidden = true;
        _babyGameButton.hidden = false;
        _babyGameButtonPressed.hidden = true;
        _fetchGameButton.hidden = false;
        _fetchGameButtonPressed.hidden = true;
        _therapistMenuButton.hidden = false;
        _therapistMenuButtonPressed.hidden = true;
    }
    else if ([self nodeIsButton:currentNode.name] && previousNode.name == NULL)
    {
        NSLog(@"moved onto button %@", currentNode.name);
        // for when wasn't touching a button but moved/swiped onto one
        // figure out which button is pressed and change its color
        if ([currentNode.name isEqualToString:@"babyGameButton"] ||
            [currentNode.name isEqualToString:@"babyGameButtonPressed"])
        {
            _babyGameButton.hidden = true;
            _babyGameButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"targetGameButton"] ||
                 [currentNode.name isEqualToString:@"targetGameButtonPressed"])
        {
            _targetGameButton.hidden = true;
            _targetGameButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"fetchGameButton"] ||
                 [currentNode.name isEqualToString:@"fetchGameButtonPressed"])
        {
            _fetchGameButton.hidden = true;
            _fetchGameButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"therapistMenuButton"] ||
                 [currentNode.name isEqualToString:@"therapistMenuButtonPressed"])
        {
            _therapistMenuButton.hidden = true;
            _therapistMenuButtonPressed.hidden = false;
        }
    }
}


// ------------------------------------------------------------------------------------
//                             ADD BACKGROUND AND BUTTONS
// ------------------------------------------------------------------------------------

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"mainMenuBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .38;
    bgImage.yScale = .38;
    [self addChild:bgImage];
}

-(void)addBabyGameButton
{
    // baby game button icon
    _babyGameButton = [[SKSpriteNode alloc] initWithImageNamed:@"babyGameButton.png"];
    _babyGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                           CGRectGetMidY(self.frame) + 185);
    _babyGameButton.xScale = .38;
    _babyGameButton.yScale = .38;
    _babyGameButton.name = @"babyGameButton";
    [self addChild:_babyGameButton];
    
    // pressed baby game button icon
    _babyGameButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"babyGameButtonPressed.png"];
    _babyGameButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                                  CGRectGetMidY(self.frame) + 185);
    _babyGameButtonPressed.xScale = .38;
    _babyGameButtonPressed.yScale = .38;
    _babyGameButtonPressed.name = @"babyGameButtonPressed";
    _babyGameButtonPressed.hidden = true;
    [self addChild:_babyGameButtonPressed];

}

-(void)addTargetGameButton
{
    _targetGameButton = [[SKSpriteNode alloc] initWithImageNamed:@"targetGameButton.png"];
    _targetGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 190,
                                             CGRectGetMidY(self.frame) + 105);
    _targetGameButton.xScale = .38;
    _targetGameButton.yScale = .38;
    _targetGameButton.name = @"targetGameButton";
    [self addChild:_targetGameButton];
    
    // pressed target game button icon
    _targetGameButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"targetGameButtonPressed.png"];
    _targetGameButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) - 190,
                                                    CGRectGetMidY(self.frame) + 105);
    _targetGameButtonPressed.xScale = .38;
    _targetGameButtonPressed.yScale = .38;
    _targetGameButtonPressed.name = @"targetGameButtonPressed";
    _targetGameButtonPressed.hidden = true;
    [self addChild:_targetGameButtonPressed];
}

-(void)addFetchGameButton
{
    _fetchGameButton = [[SKSpriteNode alloc] initWithImageNamed:@"fetchGameButton.png"];
    _fetchGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                            CGRectGetMidY(self.frame) + 20);
    _fetchGameButton.xScale = .38;
    _fetchGameButton.yScale = .38;
    _fetchGameButton.name = @"fetchGameButton";
    [self addChild:_fetchGameButton];
    
    // pressed fetch game button icon
    _fetchGameButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"fetchGameButtonPressed.png"];
    _fetchGameButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                                   CGRectGetMidY(self.frame) + 20);
    _fetchGameButtonPressed.xScale = .38;
    _fetchGameButtonPressed.yScale = .38;
    _fetchGameButtonPressed.name = @"fetchGameButtonPressed";
    _fetchGameButtonPressed.hidden = true;
    [self addChild:_fetchGameButtonPressed];
}

-(void)addTherapistMenuButton
{
    // therapist button
    _therapistMenuButton = [[SKSpriteNode alloc]  initWithImageNamed:@"therapistMenuButton.png"];
    _therapistMenuButton.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
                                                CGRectGetMidY(self.frame) - 180);
    _therapistMenuButton.xScale = .38;
    _therapistMenuButton.yScale = .38;
    _therapistMenuButton.name = @"therapistMenuButton";
    [self addChild:_therapistMenuButton];
    
    // pressed therapist menu button icon
    _therapistMenuButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"therapistMenuButtonPressed.png"];
    _therapistMenuButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
                                                       CGRectGetMidY(self.frame) - 180);
    _therapistMenuButtonPressed.xScale = .38;
    _therapistMenuButtonPressed.yScale = .38;
    _therapistMenuButtonPressed.name = @"therapistMenuButtonPressed";
    _therapistMenuButtonPressed.hidden = true;
    [self addChild:_therapistMenuButtonPressed];
}

//-(void)addSettingsMenuButton
//{
//    // settings menu button
//    _settingsMenuButton = [[SKSpriteNode alloc]  initWithImageNamed:@"settingsMenuButton.png"];
//    _settingsMenuButton.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
//                                                CGRectGetMidY(self.frame) - 180);
//    _settingsMenuButton.xScale = .38;
//    _settingsMenuButton.yScale = .38;
//    _settingsMenuButton.name = @"settingsMenuButton";
//    [self addChild:_settingsMenuButton];
//    
//    // pressed settings menu button icon
//    _settingsMenuButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"settingsMenuButtonPressed.png"];
//    _settingsMenuButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
//                                                       CGRectGetMidY(self.frame) - 180);
//    _settingsMenuButtonPressed.xScale = .38;
//    _settingsMenuButtonPressed.yScale = .38;
//    _settingsMenuButtonPressed.name = @"settingsMenuButtonPressed";
//    _settingsMenuButtonPressed.hidden = true;
//    [self addChild:_settingsMenuButtonPressed];
//}

//-(void)update:(CFTimeInterval)currentTime {
//    /* Called before each frame is rendered */
//}



-(void)addUserInfo
{
    // get user's first and last names + therapist email from settings bundle
    NSString *lastInitial = @"";
    if (_lastName.length > 0)
    {
        lastInitial = [_lastName substringToIndex:1];
        lastInitial = [lastInitial stringByAppendingString:@"."];
    }
    NSString *wholeName = [[_firstName stringByAppendingString:@" "]
                           stringByAppendingString:lastInitial];
    NSString *usernameLabelText = [[@"Playing as " stringByAppendingString:@" "]
                                   stringByAppendingString:wholeName];
    SKLabelNode *usernameLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    usernameLabel.name = @"usernameLabel";
    usernameLabel.text = usernameLabelText;
    usernameLabel.fontSize = 20;
    usernameLabel.fontColor = [SKColor blackColor];
    usernameLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 200,
                                         CGRectGetMidY(self.frame)+ 250);
    [self addChild:usernameLabel];
}

-(void)addToNotificationCenter
{
    NSLog(@"adding main menu to notification center");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecameActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)removeFromNotificationCenter
{
    NSLog(@"removing main menu from notification center");

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

// ------------------------------------------------------------------------------------
//                             DATA CHECKING LOGIC
// ------------------------------------------------------------------------------------


// present settings menu scene when alert view closed
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 0)
//    {
//        // in the old days you could redirect to the settings app, but no more...
//        // instead, redirect to our settings menu scene
//        // Create and configure the "settings menu" scene.
//        SKScene * settingsMenu = [[SettingsMenuScene alloc] initWithSize:self.size];
//        settingsMenu.scaleMode = SKSceneScaleModeAspectFill;
//        
//        // Present the scene
//        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
//        [self.view presentScene:settingsMenu transition:reveal];
//    }
//}

-(bool)nodeIsButton:(NSString *)previousNodeName
{
    return [previousNodeName isEqualToString:@"babyGameButton"] ||
        [previousNodeName isEqualToString:@"babyGameButtonPressed"] ||
        [previousNodeName isEqualToString:@"targetGameButton"] ||
        [previousNodeName isEqualToString:@"targetGameButtonPressed"] ||
        [previousNodeName isEqualToString:@"fetchGameButton"] ||
        [previousNodeName isEqualToString:@"fetchGameButtonPressed"] ||
        [previousNodeName isEqualToString:@"therapistMenuButton"] ||
        [previousNodeName isEqualToString:@"therapistMenuButtonPressed"] ||
        [previousNodeName isEqualToString:@"settingsMenuButton"] ||
        [previousNodeName isEqualToString:@"settingsMenuButtonPressed"];
}

-(NSString *)zipFilesAtPath:(NSString *)path
{
    // clear array of log files
    [_logFiles removeAllObjects];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"MM-dd-yyyy_HH-mm"];
    NSString *currentDate = [DateFormatter stringFromDate:[NSDate date]];
    NSString *zipFileName = [[[[[_firstName stringByAppendingString:@"_"]
                                stringByAppendingString:_lastName]
                               stringByAppendingString:@"_"]
                              stringByAppendingString:currentDate]
                             stringByAppendingString:@".zip"];
    NSLog(@"zip Filename is %@", zipFileName);
    
    BOOL isDir = NO;
    NSArray *subpaths;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir)
    {
        subpaths = [fileManager subpathsAtPath:path];
    }
    NSString *archivePath = [[path stringByAppendingString:@"/" ]
                             stringByAppendingString:zipFileName ];
    NSLog(@"achive path is %@", archivePath);
    ZipArchive *archiver = [[ZipArchive alloc] init];
    [archiver CreateZipFile2:archivePath];
    NSLog(@"num paths found is %d", [subpaths count]);
    int i = 0;
    _logFiles = [[NSMutableArray alloc] initWithCapacity:[subpaths count]];
    for(NSString *subpath in subpaths)
    {
        NSLog(@"subpath %d is %@", i, subpath);
        i++;
        // ignore previously zipped files
        NSArray *nameAndExtension = [subpath componentsSeparatedByString:@"."];
        NSString *extension = nameAndExtension[[nameAndExtension count]-1];
        NSLog(@"extension is %@", extension);
        NSString *longPath = [path stringByAppendingPathComponent:subpath];
        if ([extension isEqualToString:@"zip"])
        {
            NSLog(@"ignoring zip file %@", subpath);
            continue;
        }
        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir)
        {
            [_logFiles addObject:longPath];
            [archiver addFileToZip:longPath newname:subpath];
        }
    }
    NSLog(@"compressing...");
    BOOL successCompressing = [archiver CloseZipFile2];
    if (successCompressing)
    {
        NSLog(@"successful compression! ");
        return archivePath;
    }
    else
    {
        NSLog(@"UNSUCCESSFUL compression! ");
        return @"";
    }
}

-(void)emailZipFile:(NSString *)zipFilePath
{
    NSLog(@"zip file path is %@", zipFilePath);
    NSArray *parts = [zipFilePath componentsSeparatedByString:@"/"];
    NSString *zipFile = parts[[parts count]-1];
    NSLog(@"NOW zip file name is %@", zipFile);
    
    NSArray *recipients = @[_therapistEmail];
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    // want to be able to use
    // if ([composer canSendMail]) ... to check if user has e-mail account setup yet
    
    // populate the fields
    [composer setToRecipients:recipients];
    [composer setSubject:@"re: My game logs from KidologyApp"];
    [composer setMessageBody:@"Hello,\n Attached are my game log files from today" isHTML:NO];
    NSData *zipData = [NSData dataWithContentsOfFile:zipFilePath];
    [composer addAttachmentData:zipData mimeType:@"application/zip" fileName:zipFile];
    composer.navigationBar.barStyle = UIBarStyleBlack;
    [self.view.window.rootViewController presentModalViewController:composer animated:YES];
    [composer release];
}

// Dismisses the email composition interface when users tap Cancel or Send
// Proceeds to update the message field with the result of the operation
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                            message:@"Email Succesfully Sent To Outbox!\n Go to Mail to make sure it sends!"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            for (NSString *file in _logFiles)
            {
                NSError *error;
                BOOL success = [fileManager removeItemAtPath:file error:&error];
                if(!success)
                    NSLog(@"unable to delete file %@ because %@", file, [error description]);
                else
                    NSLog(@"sucessfully deleted file %@", file);
            }
            
            break;
        }
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
            break;
    }
    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
}


-(NSArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSString *file = [directoryContent objectAtIndex:count];
        NSLog(@"File %d: %@", (count + 1), file);
    }
    NSLog(@"found %d files", count);
    
    return directoryContent;
}

-(void)loadSettingsInfo
{
    //get user's settings from the app settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    _firstName = [defaults objectForKey:@"firstName"];
    _lastName = [defaults objectForKey:@"lastName"];
    _therapistEmail = [defaults objectForKey:@"therapistEmail"];
}

-(void)appBecameActive:(NSNotification *)notification
{
    NSLog(@"updating settings info on activate");
    [[self childNodeWithName:@"usernameLabel"] removeFromParent];
    [self loadSettingsInfo];
    [self addUserInfo];
}


@end

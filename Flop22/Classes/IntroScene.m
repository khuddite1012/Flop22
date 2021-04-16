//
//  IntroScene.m
//  Flop22
//
//  Created by Airkii on 1/6/15.
//  Copyright Airkii 2015. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "HowtoPlay.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene
{
    CCButton *playBtn;
    CCButton *oneBtn;
    CCButton *twoBtn;
    CCButton *threeBtn;
    CCButton *fourBtn;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
//    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
//    [self addChild:background];
    CCSprite *back = [CCSprite spriteWithImageNamed:@"main-menu.png"];
    back.scaleX = self.contentSize.width/back.contentSize.width;
    back.scaleY = self.contentSize.height/back.contentSize.height;
    back.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
    [self addChild:back];
    
//    CCSprite *cards = [CCSprite spriteWithImageNamed:@"cards.png"];
//    cards.scale = back.scaleY;
//    cards.position = ccp(self.contentSize.width*0.23f, self.contentSize.height*0.55f);
//    [self addChild:cards];
    
//    CCSprite *logo = [CCSprite spriteWithImageNamed:@"logo.png"];
//    logo.scale = back.scaleX;
//    logo.position = ccp(self.contentSize.width*0.23f, self.contentSize.height*0.55f);
//    [self addChild:logo];
    
//    CCButton *fbBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"fb_btn.png"]];
//    fbBtn.scale = logo.scale;
//    fbBtn.position = ccp(self.contentSize.width*0.15f, self.contentSize.height*0.06f);
//    [fbBtn setTarget:self selector:@selector(onFB)];
//    [self addChild:fbBtn];
    
    playBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"play_btn.png"]];
    playBtn.scale = back.scaleY;
    playBtn.position = ccp(self.contentSize.width*0.5f, self.contentSize.height*0.58f);
    [playBtn setTarget:self selector:@selector(onPlay:)];
    [self addChild:playBtn];
    
    CCButton *instructionBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"howtoBtn.png"]];
    instructionBtn.scale = back.scaleY;
    instructionBtn.position = ccp(self.contentSize.width*0.5f, self.contentSize.height*0.72f);
    [instructionBtn setTarget:self selector:@selector(onHowto:)];
    [self addChild:instructionBtn];
    
    CCButton *contactBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"contactBtn.png"]];
    contactBtn.scale = back.scaleY;
    contactBtn.position = ccp(self.contentSize.width*0.5f, self.contentSize.height*0.44f);
    [contactBtn setTarget:self selector:@selector(onContact:)];
    [self addChild:contactBtn];
    
    
    [self createNumberBTNS];
    // Hello world
//    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Chalkduster" fontSize:36.0f];
//    label.positionType = CCPositionTypeNormalized;
//    label.color = [CCColor redColor];
//    label.position = ccp(0.5f, 0.5f); // Middle of screen
//    [self addChild:label];
    
    // Helloworld scene button
//    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Start ]" fontName:@"Verdana-Bold" fontSize:18.0f];
//    helloWorldButton.positionType = CCPositionTypeNormalized;
//    helloWorldButton.position = ccp(0.5f, 0.35f);
//    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
//    [self addChild:helloWorldButton];

    // done
	return self;
}

-(void)createNumberBTNS
{
    oneBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"player1_btn.png"]];
    oneBtn.scale = playBtn.scale;
    [oneBtn setTarget:self selector:@selector(onClick:)];
    oneBtn.position = ccp(self.contentSize.width*0.38f, self.contentSize.height*0.3f);
    oneBtn.visible = NO;
    oneBtn.name = @"1";
    [self addChild:oneBtn];
    twoBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"player2_btn.png"]];
    twoBtn.scale = playBtn.scale;
    twoBtn.position = ccp(self.contentSize.width*0.46f, self.contentSize.height*0.3f);
    [twoBtn setTarget:self selector:@selector(onClick:)];
    twoBtn.visible = NO;
    twoBtn.name = @"2";
    [self addChild:twoBtn];
    threeBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"player3_btn.png"]];
    threeBtn.scale = playBtn.scale;
    threeBtn.position = ccp(self.contentSize.width*0.54f, self.contentSize.height*0.3f);
    [threeBtn setTarget:self selector:@selector(onClick:)];
    threeBtn.visible = NO;
    threeBtn.name = @"3";
    [self addChild:threeBtn];
    fourBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"player4_btn.png"]];
    fourBtn.scale = playBtn.scale;
    fourBtn.position = ccp(self.contentSize.width*0.62f, self.contentSize.height*0.3f);
    [fourBtn setTarget:self selector:@selector(onClick:)];
    fourBtn.visible = NO;
    fourBtn.name = @"4";
    [self addChild:fourBtn];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void)onPlay:(id)sender
{
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    if ([u integerForKey:@"Coins"] == 0) {
        [u setInteger:1000 forKey:@"Coins"];
    }
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
//    playBtn.visible = NO;
//    oneBtn.visible = YES;
//    twoBtn.visible = YES;
//    threeBtn.visible = YES;
//    fourBtn.visible = YES;
}

-(void)onContact:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://frateentertainmentgroup.com"]];
}

-(void)onHowto:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HowtoPlay scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)onFB
{
//    Application.OpenURL("https://www.facebook.com/dialog/feed?"+
//                        "app_id="+AppID+
//                        "&link="+"http://goo.gl/R2QA9x"+
//                        //"&picture="+Picture+
//                        "&name="+ReplaceSpace(Name)+
//                        //"&caption="+ReplaceSpace(Caption)+
//                        "&description="+ReplaceSpace(Description)+
//                        "&redirect_uri=https://facebook.com/");
    NSURL *url;
    url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.facebook.com/dialog/feed?app_id=Flop22&link=http://&name=I'm-Playing-Flop22&redirect_url=https://facebook.com/"]];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)onClick:(id)sender
{
//    NSLog(@"%@",[(CCButton*)sender name]);
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    if ([u integerForKey:@"Coins"] == 0) {
        [u setInteger:1000 forKey:@"Coins"];
    }
    if ([[(CCButton*)sender name] isEqualToString:@"1"]) {
        [u setInteger:1 forKey:@"Spots"];
    }
    else if ([[(CCButton*)sender name] isEqualToString:@"2"])
    {
        [u setInteger:2 forKey:@"Spots"];
    }
    else if ([[(CCButton*)sender name] isEqualToString:@"3"])
    {
        [u setInteger:3 forKey:@"Spots"];
    }
    else
    {
        [u setInteger:4 forKey:@"Spots"];
    }
    
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}
//
//- (void)onSpinningClicked:(id)sender
//{
//    // start spinning scene with transition
//    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
//                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
//}

// -----------------------------------------------------------------------
@end

//
//  IntroScene.m
//  Flop22
//
//  Created by Airkii on 1/6/15.
//  Copyright Airkii 2015. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "HowtoPlay.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation HowtoPlay
{
    BOOL isActive;
    int currnetPage;
    CCSprite *mainImage[13];
    float scaleY;
    CCButton *newBack;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HowtoPlay *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CCSprite *back = [CCSprite spriteWithImageNamed:@"instructionBg.png"];
    back.scaleX = self.contentSize.width/back.contentSize.width;
    back.scaleY = self.contentSize.height/back.contentSize.height;
    back.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
    [self addChild:back];
    
    
    
    currnetPage = 1;
    scaleY = back.scaleY;
    if (back.scaleX<back.scaleY) {
        scaleY = back.scaleX;
    }
    for (int i=0; i<13; i++) {
        mainImage[i] = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"image%d.png",i+1]];
        mainImage[i].scale = scaleY;
        mainImage[i].anchorPoint = ccp(0.5f, 1.0f);
        mainImage[i].visible = NO;
        mainImage[i].position = ccp(self.contentSize.width*0.5f, self.contentSize.height*0.95f);
        [self addChild:mainImage[i]];
    }
    
    [mainImage[0] setVisible:YES];
    
    CCButton *nextBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"nextBt.png"]];
    nextBtn.scale = scaleY;
//    nextBtn.anchorPoint = ccp(0.5f, 1.0f);
    nextBtn.position = ccp(self.contentSize.width*0.92f, self.contentSize.height*0.9f);
    [nextBtn setTarget:self selector:@selector(onNext:)];
    [self addChild:nextBtn];
    
    CCButton *prevBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"backBt.png"]];
    prevBtn.scale = scaleY;
//    prevBtn.anchorPoint = ccp(0.5f, 1.0f);
    prevBtn.position = ccp(self.contentSize.width*0.08f, self.contentSize.height*0.9f);
    [prevBtn setTarget:self selector:@selector(onPrev:)];
    [self addChild:prevBtn];
    
//    CCButton *homeBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"homeBtn.png"]];
//    homeBtn.scale = scaleY;
//    homeBtn.position = ccp(self.contentSize.width*0.1f, self.contentSize.height*0.1f);
//    [homeBtn setTarget:self selector:@selector(onBack:)];
//    [self addChild:homeBtn];
    
    isActive = NO;
    newBack = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"iBack.png"]];
    newBack.scale = scaleY;
    newBack.position = ccp(self.contentSize.width*0.1f, self.contentSize.height*0.1f);
    [newBack setTarget:self selector:@selector(onBack:)];
    newBack.visible = NO;
    [self addChild:newBack];
    
	return self;
}

-(void)setMainImage
{
    isActive = YES;
    CCAction *action1 = [CCActionFadeOut actionWithDuration:0.5f];
    CCAction *action2 = [CCActionCallFunc actionWithTarget:self selector:@selector(showNewImage)];
    CCAction *action3 = [CCActionSequence actionWithArray:@[action1,action2]];
    [mainImage[currnetPage-2] runAction:action3];
}

-(void)showNewImage
{
    [mainImage[currnetPage-2] setVisible:NO];
    CCAction *action1 = [CCActionFadeIn actionWithDuration:0.5f];
    CCAction *action2 = [CCActionCallFunc actionWithTarget:self selector:@selector(endAnimation)];
    CCAction *action3 = [CCActionSequence actionWithArray:@[action1,action2]];
    [mainImage[currnetPage-1] setVisible:YES];
    [mainImage[currnetPage-1] runAction:action3];
}

-(void)setBackMainImage
{
    isActive = YES;
    CCAction *action1 = [CCActionFadeOut actionWithDuration:0.5f];
    CCAction *action2 = [CCActionCallFunc actionWithTarget:self selector:@selector(showBackNewImage)];
    CCAction *action3 = [CCActionSequence actionWithArray:@[action1,action2]];
    [mainImage[currnetPage] runAction:action3];
}

-(void)showBackNewImage
{
    [mainImage[currnetPage] setVisible:NO];
    CCAction *action1 = [CCActionFadeIn actionWithDuration:0.5f];
    CCAction *action2 = [CCActionCallFunc actionWithTarget:self selector:@selector(endAnimation)];
    CCAction *action3 = [CCActionSequence actionWithArray:@[action1,action2]];
    [mainImage[currnetPage-1] setVisible:YES];
    [mainImage[currnetPage-1] runAction:action3];
}

-(void)endAnimation
{
    if (currnetPage == 13) {
        newBack.visible = YES;
    }
    isActive = NO;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void)onBack:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)onNext:(id)sender
{
    if (isActive == YES) {
        return;
    }
    currnetPage ++;
    if (currnetPage>=14) {
        currnetPage = 13;
        
        return;
        [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
    [self setMainImage];
}

-(void)onPrev:(id)sender
{
    if (isActive == YES) {
        return;
    }
    currnetPage--;
    if (currnetPage<1) {
        currnetPage = 1;
        return;
        [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
    [self setBackMainImage];
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

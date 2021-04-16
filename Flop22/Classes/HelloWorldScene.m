//
//  HelloWorldScene.m
//  Flop22
//
//  Created by Airkii on 1/6/15.
//  Copyright Airkii 2015. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    NSUserDefaults *u;
    int c_step;
    float cscale;
    int all_coins;
    
    CGPoint points[11];
    CGPoint flops[3];
    int betedCoins[10];
    
    CCSprite *betCoins[10];
    
    CCButton *betBtn;
    CCButton *doneBtn;
    CCButton *newBtn;
    CCButton *clearBtn;
//    CCLabelTTF *mainLabel;
    CCLabelTTF *betedAmount;
    CCLabelTTF *disLabel;
    CCLabelTTF *resultLabel;
    
    CCButton *chip5Btn;
    CCButton *chip10Btn;
    CCButton *chip25Btn;
    CCButton *chip100Btn;
    
    CCLabelTTF *coinLabel;
    
    CCLabelTTF *betLabel;
    CCLabelTTF *doneLabel;
    CCLabelTTF *playAgainLabel;
    CCLabelTTF *clearlabel;
    
    int player_cards[7];
    CCSprite *card_spirte[7];
    
    BOOL isSetBet;
    int betAmount;
    NSString *betChipStrong;
    
    BOOL canEvent;
    BOOL isFlop[3];
    BOOL canBet;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    
    self = [super init];
    if (!self) return(nil);
    self.userInteractionEnabled = YES;
    CCSprite *back = [CCSprite spriteWithImageNamed:@"playBack.png"];
    back.scaleX = self.contentSize.width/back.contentSize.width;
    back.scaleY = self.contentSize.height/back.contentSize.height;
    back.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
    [self addChild:back];
    cscale = 0.0f;
    cscale = self.contentSize.height/back.contentSize.height;
    NSLog(@"Value=%f",back.scaleY);
    CCSprite *fl1 = [CCSprite spriteWithImageNamed:@"flopImg1.png"];
    fl1.scale = cscale;
    fl1.position = ccp(self.contentSize.width*0.34f, self.contentSize.height*0.663f);
    [self addChild:fl1];
    
    CCSprite *fl2 = [CCSprite spriteWithImageNamed:@"flopImg2.png"];
    fl2.scale = fl1.scale;
    fl2.position = ccp(self.contentSize.width*0.5f, self.contentSize.height*0.663f);
    [self addChild:fl2];
    
    CCSprite *fl3 = [CCSprite spriteWithImageNamed:@"flopImg3.png"];
    fl3.scale = fl2.scale;
    fl3.position = ccp(self.contentSize.width*0.66f, self.contentSize.height*0.663f);
    [self addChild:fl3];
    
    CCSprite *bo1 = [CCSprite spriteWithImageNamed:@"betFlop.png"];
    bo1.scale = cscale;
    bo1.position = ccp(self.contentSize.width*0.34f, self.contentSize.height*0.19f);
    [self addChild:bo1];
    
    betedAmount = [CCLabelTTF labelWithString:@"Bet:0" fontName:@"Verdana" fontSize:cscale*30.0f];
    betedAmount.position = ccp(self.contentSize.width*0.68f, self.contentSize.height*0.15f);
    [self addChild:betedAmount];
    
    betBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"emptyBtn.png"]];
    betBtn.scaleX = cscale*1.0f;
    betBtn.scaleY = cscale *1.9f;
    betBtn.position = ccp(self.contentSize.width*0.67f, self.contentSize.height*0.068f);
    [betBtn setTarget:self selector:@selector(onBet)];
    [self addChild:betBtn];
    
    betLabel = [CCLabelTTF labelWithString:@"Place Field Bet" fontName:@"Arial" fontSize:cscale*25.0f dimensions:CGSizeMake(betBtn.contentSize.width*cscale*0.9f, betBtn.contentSize.height*cscale*1.9f)];
    betLabel.horizontalAlignment = CCTextAlignmentCenter;
    betLabel.verticalAlignment = CCTextAlignmentCenter;
    betLabel.fontColor = [CCColor redColor];
    betLabel.position = betBtn.position;
    [self addChild:betLabel];
    
    doneBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"emptyBtn.png"]];
    doneBtn.scaleX = cscale*1.0f;
    doneBtn.scaleY = cscale*1.9f;
    doneBtn.position = ccp(self.contentSize.width*0.77f, self.contentSize.height*0.068f);
    [doneBtn setTarget:self selector:@selector(onDone)];
    [self addChild:doneBtn];
    
    doneLabel = [CCLabelTTF labelWithString:@"No Field Bet" fontName:@"Arial" fontSize:cscale*25.0f dimensions:CGSizeMake(doneBtn.contentSize.width*cscale*0.9f, doneBtn.contentSize.height*cscale*1.9f)];
    doneLabel.horizontalAlignment = CCTextAlignmentCenter;
    doneLabel.verticalAlignment = CCTextAlignmentCenter;
    doneLabel.fontColor = [CCColor redColor];
    doneLabel.position = doneBtn.position;
    [self addChild:doneLabel];
    
    newBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"emptyBtn.png"]];
    newBtn.scaleX = cscale*0.9f;
    newBtn.scaleY = cscale*1.9f;
    newBtn.label.fontColor = [CCColor redColor];
    newBtn.position = ccp(self.contentSize.width*0.865f, self.contentSize.height*0.068f);
    [newBtn setTarget:self selector:@selector(onNew)];
    [self addChild:newBtn];
    newBtn.enabled = NO;
    
    playAgainLabel = [CCLabelTTF labelWithString:@"Play Again" fontName:@"Arial" fontSize:cscale*25.0f dimensions:CGSizeMake(newBtn.contentSize.width*cscale*0.9f, newBtn.contentSize.height*cscale*1.9f)];
    playAgainLabel.horizontalAlignment = CCTextAlignmentCenter;
    playAgainLabel.verticalAlignment = CCTextAlignmentCenter;
    playAgainLabel.fontColor = [CCColor redColor];
    playAgainLabel.position = newBtn.position;
    [self addChild:playAgainLabel];
    
    clearBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"emptyBtn.png"]];
    clearBtn.scaleX = cscale*0.8f;
    clearBtn.scaleY = cscale*1.9f;
    clearBtn.label.fontColor = [CCColor redColor];
    clearBtn.position = ccp(self.contentSize.width*0.952f, self.contentSize.height*0.068f);
    [clearBtn setTarget:self selector:@selector(onClear)];
    [self addChild:clearBtn];
    clearlabel = [CCLabelTTF labelWithString:@"Clear" fontName:@"Arail" fontSize:25.0f*cscale];
    clearlabel.position = clearBtn.position;
    clearlabel.fontColor = [CCColor redColor];
    [self addChild:clearlabel];
    
    chip5Btn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"chip_5.png"]];
    chip5Btn.scale = cscale*0.4f;
    chip5Btn.name = @"5";
    chip5Btn.position = ccp(self.contentSize.width*0.58f, self.contentSize.height*0.28f);
    [chip5Btn setTarget:self selector:@selector(selectChip:)];
    [self addChild:chip5Btn];
//    chip5Btn.visible = NO;
    
//    chip10Btn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"chip_10.png"]];
//    chip10Btn.scale = doneBtn.scale;
//    chip10Btn.name = @"10";
//    chip10Btn.position = ccp(self.contentSize.width*0.74f, self.contentSize.height*0.2f);
//    [chip10Btn setTarget:self selector:@selector(selectChip:)];
//    [self addChild:chip10Btn];
    chip10Btn.visible = NO;
    
    chip25Btn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"chip_25.png"]];
    chip25Btn.scale = cscale*0.4f;
    chip25Btn.name = @"25";
    chip25Btn.position = ccp(self.contentSize.width*0.58f, self.contentSize.height*0.17f);
    [chip25Btn setTarget:self selector:@selector(selectChip:)];
    [self addChild:chip25Btn];
//    chip25Btn.visible = NO;
    
    chip100Btn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"chip_100.png"]];
    chip100Btn.scale = cscale*0.4f;
    chip100Btn.name = @"100";
    chip100Btn.position = ccp(self.contentSize.width*0.58f, self.contentSize.height*0.06f);
    [chip100Btn setTarget:self selector:@selector(selectChip:)];
    [self addChild:chip100Btn];
//    chip100Btn.visible = NO;
    
//    mainLabel = [CCLabelTTF labelWithString:@"Field" fontName:@"Arial Rounded MT Bold" fontSize:betBtn.scale * 30.0f];
//    mainLabel.position = ccp(self.contentSize.width*0.7f, self.contentSize.height*0.075f);
//    mainLabel.color = [CCColor redColor];
//    [self addChild:mainLabel];
    
    disLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:cscale*30.0f];
    disLabel.position = ccp(self.contentSize.width*0.458f, self.contentSize.height*0.04f);
    [self addChild:disLabel];
    
    resultLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:cscale*30.0f dimensions:CGSizeMake(cscale*100.0f, self.contentSize.height*0.2f)];
    resultLabel.horizontalAlignment = CCTextAlignmentCenter;
    resultLabel.verticalAlignment = CCTextAlignmentCenter;
    resultLabel.position = ccp(self.contentSize.width*0.458f, self.contentSize.height*0.15f);
    [self addChild:resultLabel];
    
    u = [NSUserDefaults standardUserDefaults];
    all_coins = (int)[u integerForKey:@"Coins"];
    
    coinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"$%d",all_coins] fontName:@"Verdana" fontSize:cscale * 50.0f];
    coinLabel.position = ccp(self.contentSize.width*0.34f, self.contentSize.height*0.04f);
    [self addChild:coinLabel];
 
    c_step = 1;
    betAmount = 0;
    isSetBet = NO;
    canBet = YES;
//    canBet = YES;
    
    canEvent = YES;
    
    CCButton *backBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"backBtn.png"]];
    backBtn.scale = back.scaleY;
    backBtn.position = ccp(self.contentSize.width*0.87f, self.contentSize.height*0.75f);
    [backBtn setTarget:self selector:@selector(onBack)];
    [self addChild:backBtn];
    
    CCSprite *mark = [CCSprite spriteWithImageNamed:@"markImg2.png"];
    mark.scale = backBtn.scale;
    mark.position = ccp(self.contentSize.width*0.87f, self.contentSize.height*0.92f);
    [self addChild:mark];
    
    CCSprite *logo = [CCSprite spriteWithImageNamed:@"markImg1.png"];
    logo.scale = cscale*1.2f;
    logo.position = ccp(self.contentSize.width*0.7f, self.contentSize.height*0.9f);
    [self addChild:logo];
    
    CCSprite *betCircle = [CCSprite spriteWithImageNamed:@"betCircleImg.png"];
    betCircle.scale = backBtn.scale;
    betCircle.position = ccp(self.contentSize.width*0.13f, self.contentSize.height*0.16f);
    [self addChild:betCircle];
    
    CCSprite *dealer = [CCSprite spriteWithImageNamed:@"standingImg.png"];
    dealer.scale = backBtn.scale;
    dealer.position = ccp(self.contentSize.width*0.24f, self.contentSize.height*0.83f);
    [self addChild:dealer];
    
    [self initPoint];
    
    
    
	return self;
}

-(void)onBack
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}


-(void)initPoint
{
    flops[0] = ccp(self.contentSize.width*0.34f, self.contentSize.height*0.663f);
    flops[1] = ccp(self.contentSize.width*0.5f, self.contentSize.height*0.663f);
    flops[2] = ccp(self.contentSize.width*0.66f, self.contentSize.height*0.663f);
    
    points[0] = ccp(self.contentSize.width*0.34f, self.contentSize.height*0.19f);
    points[1] = ccp(self.contentSize.width*0.178f, self.contentSize.height*0.472f);
    points[2] = ccp(self.contentSize.width*0.1288f-84.0f*cscale, self.contentSize.height*0.177f);
    points[3] = ccp(self.contentSize.width*0.1288f, self.contentSize.height*0.177f);
    points[4] = ccp(self.contentSize.width*0.1288f+83.0f*cscale, self.contentSize.height*0.177f);
    points[5] = ccp(self.contentSize.width*0.1288f-84.0f*cscale, self.contentSize.height*0.069f);
    points[6] = ccp(self.contentSize.width*0.1288f, self.contentSize.height*0.069f);
    points[7] = ccp(self.contentSize.width*0.12688f+83.0f*cscale, self.contentSize.height*0.069f);
    points[8] = ccp(self.contentSize.width*0.1288f-84.0f*cscale, self.contentSize.height*0.281f);
    points[9] = ccp(self.contentSize.width*0.1288f, self.contentSize.height*0.281f);
    points[10] = ccp(self.contentSize.width*0.1288f+83.0f*cscale, self.contentSize.height*0.281f);
}
// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    if (CGRectContainsPoint(CGRectMake(card_spirte[0].position.x-card_spirte[0].contentSize.width*card_spirte[0].scale/2.0f,card_spirte[0].position.y-card_spirte[0].contentSize.height*card_spirte[0].scale/2.0f,card_spirte[0].contentSize.width*card_spirte[0].scale,card_spirte[0].contentSize.height*card_spirte[0].scale), touchLoc)) {
        if (isFlop[0] == NO) {
            canEvent = NO;
            if (betedCoins[2]!=0) {
                if (betedCoins[5] == 0) {
                    c_step = 6;
                    isSetBet = YES;
                    betAmount = betedCoins[2];
                }
                else
                {
                    if (betedCoins[3]!=0) {
                        if (betedCoins[6] == 0) {
                            c_step = 7;
                            isSetBet = YES;
                            betAmount = betedCoins[3];
                        }
                        else
                        {
                            if (betedCoins[8]!=0) {
                                if (betedCoins[9]!=0) {
                                    c_step = 11;
                                }
                                else
                                {
                                    c_step = 10;
                                }
                            }
                            else
                            {
                                c_step = 9;
                            }
                        }
                    }
                    else
                    {
                        if (betedCoins[8]!=0) {
                            if (betedCoins[9]!=0) {
                                c_step = 11;
                            }
                            else
                            {
                                c_step = 10;
                            }
                        }
                        else
                        {
                            c_step = 9;
                        }
                    }
                }
            }
            else
            {
                if (betedCoins[8]!=0) {
                    if (betedCoins[9]!=0) {
                        c_step = 11;
                    }
                    else
                    {
                        c_step = 10;
                    }
                }
                else
                {
                    c_step = 9;
                }
            }
            
//            if (betedCoins[8]!=0) {
//                if (betedCoins[9]!=0) {
//                    c_step = 11;
//                }
//                else
//                {
//                    c_step = 10;
//                }
//            }
//            else
//            {
//                c_step = 9;
//            }
            isFlop[0] = YES;
            [self checkFortheResult];
        }
        else
        {
            return;
        }
    }
    else if (CGRectContainsPoint(CGRectMake(card_spirte[1].position.x-card_spirte[1].contentSize.width*card_spirte[1].scale/2.0f,card_spirte[1].position.y-card_spirte[1].contentSize.height*card_spirte[1].scale/2.0f,card_spirte[1].contentSize.width*card_spirte[1].scale,card_spirte[1].contentSize.height*card_spirte[1].scale), touchLoc))
    {
        if (isFlop[0] == YES && isFlop[1] == NO) {
            canEvent = NO;
            if (betedCoins[3]!=0) {
                if (betedCoins[6]!=0) {
                    if (betedCoins[9]!=0) {
                        c_step = 11;
                    }
                    else
                    {
                        c_step = 10;
                    }
                }
                else
                {
                    c_step = 7;
                    isSetBet = YES;
                    betAmount = betedCoins[3];
                }
            }
            else
            {
                if (betedCoins[9]!=0) {
                    c_step = 11;
                }
                else
                {
                    c_step = 10;
                }
            }
            
//            if (betedCoins[9]!=0) {
//                c_step = 11;
//            }
//            else
//            {
//                c_step = 10;
//            }
            isFlop[1] = YES;
            [self checkHand2];
        }
        else
            return;
    }
    else if (CGRectContainsPoint(CGRectMake(card_spirte[2].position.x-card_spirte[2].contentSize.width*card_spirte[2].scale/2.0f,card_spirte[2].position.y-card_spirte[2].contentSize.height*card_spirte[2].scale/2.0f,card_spirte[2].contentSize.width*card_spirte[2].scale,card_spirte[2].contentSize.height*card_spirte[2].scale), touchLoc))
    {
        if (isFlop[0] == YES && isFlop[1] == YES && isFlop[2] == NO) {
            c_step = 11;
            canEvent = NO;
            isFlop[2] = YES;
            [self checkHand3];
        }
        else
            return;
    }
}

-(BOOL)checkForBet:(int)bets
{
    if (all_coins>=bets) {
        return YES;
    }
    else
    {
        CCAction *action = [CCActionBlink actionWithDuration:0.05f];
        [coinLabel runAction:action];
        return NO;
    }
}

-(void)setCoins
{
    [coinLabel setString:[NSString stringWithFormat:@"$%d",all_coins]];
    [u setInteger:all_coins forKey:@"Coins"];
}

-(void)selectChip:(id)btn
{
    if ([[(CCButton*)btn name] isEqualToString:@"5"]) {
        betAmount += 5;
    }
    else if([[(CCButton*)btn name] isEqualToString:@"10"])
    {
        betAmount += 10;
    }
    else if([[(CCButton*)btn name] isEqualToString:@"25"])
    {
        betAmount += 25;
    }
    else
    {
        betAmount += 100;
    }
    isSetBet = YES;
    [self hideChipBtns];
    [self setBetAmount];
}

-(void)setBetAmount
{
    [betedAmount setString:[NSString stringWithFormat:@"Bet:%d",betAmount]];
}

-(void)hideChipBtns
{
//    chip5Btn.visible = NO;
//    chip25Btn.visible = NO;
//    chip10Btn.visible = NO;
//    chip100Btn.visible = NO;
}

-(void)showChipBtns
{
//    chip100Btn.visible = YES;
//    chip10Btn.visible = YES;
//    chip25Btn.visible = YES;
//    chip5Btn.visible = YES;
}

-(void)onBet
{
    if (isSetBet == NO) {
        [self showChipBtns];
        return;
    }
    if (canEvent == NO || c_step == 11) {
        return;
    }
    if (all_coins>=betAmount) {
        
        int imgNum;
        if (betAmount>=100) {
            imgNum = 100;
        }
        else if(betAmount>=25)
        {
            imgNum = 25;
        }
        else
        {
            imgNum = 5;
        }
        
        betCoins[c_step-1] = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"chip_%d.png",imgNum]];
        betCoins[c_step-1].scale = cscale*0.3f;
        betCoins[c_step-1].position = ccp(self.contentSize.width*0.645f, self.contentSize.height*0.08f);
        [self addChild:betCoins[c_step-1]];
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:points[c_step]];
        [betCoins[c_step-1] runAction:action];
        betedCoins[c_step-1] = betAmount;
        all_coins-=betAmount;
        [self setCoins];
    }
    else
    {
        CCAction *action = [CCActionBlink actionWithDuration:0.05f];
        [coinLabel runAction:action];
        return;
    }
    
    if (c_step == 4) {
        c_step = 5;
        canEvent = NO;
        CCActionDelay *delay = [CCActionDelay actionWithDuration:0.4f];
        CCActionCallFunc *func = [CCActionCallFunc actionWithTarget:self selector:@selector(dealtheCards)];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[delay,func]];
        [self runAction:seq];
    }
    else
    {
        c_step ++;
        if (c_step>=11) {
            canEvent = NO;
            return;
        }
        else if((c_step>=5) && (c_step<=7))
        {
            if (betedCoins[c_step-4] == 0) {
                if (isFlop[0] == NO) {
                    c_step = 8;
                }
                else if(isFlop[1] == NO)
                {
                    c_step = 9;
                }
                else if(isFlop[2] == NO)
                {
                    c_step = 10;
                }
            }
            
        }
        if (c_step == 8) {
            if (isFlop[0] == NO) {
                c_step = 8;
            }
            else if(isFlop[1] == NO)
            {
                c_step = 9;
            }
            else if(isFlop[2] == NO)
            {
                c_step = 10;
            }
        }
        [self setLabels];
    }
}

-(void)setBetDefault
{
    chip100Btn.enabled = YES;
    chip25Btn.enabled = YES;
    chip5Btn.enabled = YES;
    betAmount = 0;
    [self setBetAmount];
    isSetBet = NO;
}

-(void)setLabels
{
//    [playerLabel setString:[NSString stringWithFormat:@"Player%d",c_player+1]];
    if (c_step == 1) {
        [betLabel setString:@"Place Field Bet"];
        [doneLabel setString:@"No Field Bet"];
        [self setBetDefault];
    }
    else if((c_step>=2) && (c_step<=4))
    {
        [betLabel setString:[NSString stringWithFormat:@"Ante Hand %d",c_step-1]];
        [doneLabel setString:@"No Ante"];
    }
    else if((c_step>=5) && (c_step<=7))
    {
        [betLabel setString:[NSString stringWithFormat:@"Double Hand %d",c_step-4]];
        [doneLabel setString:@"No Double"];
    }
    else if((c_step>=8) && (c_step<=10))
    {
        [betLabel setString:[NSString stringWithFormat:@"Match Hand %d",c_step-7]];
        [doneLabel setString:@"No Match"];
    }
    
    if (c_step == 2) {
        [self setBetDefault];
    }
    else if(c_step>2 && c_step<8)
    {
        [self setBetFalst];
    }
    else if(c_step>=8)
    {
        [self setBetDefault];
    }
}

-(void)setBetFalst
{
    chip100Btn.enabled = NO;
    chip25Btn.enabled = NO;
    chip5Btn.enabled = NO;
    [betedAmount setString:[NSString stringWithFormat:@"%d",betAmount]];
}

-(void)dealtheCards
{
    player_cards[0] = arc4random_uniform(52)+1;
    for (int i=1; i<4; i++) {
        player_cards[i] = arc4random_uniform(52)+1;
        for (int j=0; j<i; j++) {
            if (player_cards[i] == player_cards[j]) {
                j = -1;
                player_cards[i] = arc4random_uniform(52)+1;
            }
        }
    }
//    player_cards[0] = 1;
//    player_cards[1] = 2;
//    player_cards[2] = 3;
//    player_cards[3] = 4;
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.75f];
    CCAction *action = [CCActionMoveTo actionWithDuration:0.3f position:points[0]];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[delay,action]];
    int num = player_cards[3];
    card_spirte[3] = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"cards%d.png",num]];
    card_spirte[3].scale = cscale*0.5f;
    card_spirte[3].position = ccp(self.contentSize.width*0.5f, self.contentSize.height*1.1f);
    [self addChild:card_spirte[3]];
    [card_spirte[3] runAction:seq];
    
    
    for (int i=0; i<3; i++) {
        CCAction *action2 = [CCActionDelay actionWithDuration:i*0.25f];
        CCAction *action1 = [CCActionMoveTo actionWithDuration:0.3f position:flops[i]];
        CCAction *action3 = [CCActionSequence actionWithArray:@[action2,action1]];
        card_spirte[i] = [CCSprite spriteWithImageNamed:@"card.png"];
        card_spirte[i].scale = cscale*0.25f;
        card_spirte[i].position = ccp(self.contentSize.width*0.5f, self.contentSize.height*1.1f);
        [self addChild:card_spirte[i]];
        [card_spirte[i] runAction:action3];
    }
    
    CCActionDelay *del1 = [CCActionDelay actionWithDuration:1.2f];
    CCActionCallFunc *func = [CCActionCallFunc actionWithTarget:self selector:@selector(checkFieldBets)];
    CCActionSequence *seq2 = [CCActionSequence actionWithArray:@[del1,func]];
    [self runAction:seq2];
}

-(void)checkFieldBets
{
//    [self setDisNull];
    CCActionDelay *action1 = [CCActionDelay actionWithDuration:1.0f];
    CCActionCallBlock *action2 = [CCActionCallBlock actionWithBlock:^{
        if (betedCoins[0] != 0) {
            int na = player_cards[3]%4;
            int temp = player_cards[3]/4;
            if (na != 0) {
                temp += 1;
            }
            if (temp == 2 || temp == 6) {
                [resultLabel setString:@"Win Field Bet"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",betedCoins[0]*3]];
                all_coins += betedCoins[0]*3;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[0].contentSize.height)];
                [betCoins[0] runAction:action3];
                [self setCoins];
            }
            else if(temp>=3 && temp<=5)
            {
                [resultLabel setString:@"Win Field Bet"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",betedCoins[0]*2]];
                all_coins += betedCoins[0]*2;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[0].contentSize.height)];
                [betCoins[0] runAction:action3];
                [self setCoins];
            }
            else
            {
                [resultLabel setString:@"Lose Field Bet"];
                [disLabel setString:[NSString stringWithFormat:@"Lose"]];
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[0].contentSize.height)];
                [betCoins[0] runAction:action3];
            }
        }
        else
        {
            [resultLabel setString:@""];
            [disLabel setString:[NSString stringWithFormat:@""]];
        }
    }];
    CCActionSequence *seq;
    CCActionDelay *action6 = [CCActionDelay actionWithDuration:1.5f];
    CCActionCallBlock *action5 = [CCActionCallBlock actionWithBlock:^{
        canEvent = YES;
        if (betedCoins[1] != 0) {
            c_step = 5;
        }
        else
        {
            c_step = 8;
        }
        [self setLabels];
    }];
    seq = [CCActionSequence actionWithArray:@[action1,action2,action6,action5]];
    [self runAction:seq];
}

-(void)checkFortheResult
{
//    [self setDisNull];
    float ti = 1.0f;
    [card_spirte[0] setTexture:[CCTexture textureWithFile:[NSString stringWithFormat:@"cards%d.png",player_cards[0]]]];
    CCActionDelay *action1 = [CCActionDelay actionWithDuration:ti];
    CCActionCallBlock *action2 = [CCActionCallBlock actionWithBlock:^{
        if (betedCoins[7] != 0) {
            int na1 = player_cards[3]%4;
            int temp1 = player_cards[3]/4;
            if (na1 != 0) {
                temp1 += 1;
            }
            
            int na2 = player_cards[0]%4;
            int temp2 = player_cards[0]/4;
            if (na2 != 0) {
                temp2 += 1;
            }
            
            if (temp1 == temp2) {
                [resultLabel setString:@"Win Match Hand 1"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",betedCoins[7]*11]];
                all_coins += betedCoins[7] * 11;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[7].contentSize.height)];
                [betCoins[7] runAction:action3];
                [self setCoins];
            }
            else
            {
                [resultLabel setString:@"Lose Match Hand 1"];
                [disLabel setString:[NSString stringWithFormat:@"Lose"]];
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[7].contentSize.height)];
                [betCoins[7] runAction:action3];
            }
        }
        else
        {
            [resultLabel setString:@""];
            [disLabel setString:[NSString stringWithFormat:@""]];
        }
    }];
    CCActionSequence *seq;
    CCActionDelay *action6 = [CCActionDelay actionWithDuration:2.0f];
    CCActionCallFunc *action5 = [CCActionCallFunc actionWithTarget:self selector:@selector(checkHand1Ante)];
    seq = [CCActionSequence actionWithArray:@[action1,action2,action6,action5]];
    
    [self runAction:seq];
}

-(void)setDisNull
{
//    [disLabel setString:@""];
}

-(void)checkHand1Ante
{
//    [self setDisNull];
    float ti = 1.0f;
    CCActionDelay *action1 = [CCActionDelay actionWithDuration:ti];
    CCActionCallBlock *action2 = [CCActionCallBlock actionWithBlock:^{
        if (betedCoins[1] != 0) {
            int na1 = player_cards[3]%4;
            int temp1 = player_cards[3]/4;
            if (na1 != 0) {
                temp1 += 1;
            }
            if (temp1 == 1) {
                temp1 = 11;
            }
            else if(temp1>=10)
            {
                temp1 = 10;
            }
            int na2 = player_cards[0]%4;
            int temp2 = player_cards[0]/4;
            if (na2 != 0) {
                temp2 += 1;
            }
            if (temp2 == 1) {
                temp2 = 11;
            }
            else if(temp2>=10)
            {
                temp2 = 10;
            }
            
            if (temp1 + temp2 == 22)
            {
                if ((player_cards[3] == 2 && player_cards[0] == 4) || (player_cards[3] == 4 && player_cards[0] == 2)) {
                    [resultLabel setString:@"Win Ante Hand 1"];
                    [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[1]+betedCoins[4])*16]];
                    all_coins += (betedCoins[1]+betedCoins[4])*16;
                    CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[1].contentSize.height)];
                    CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[4].contentSize.height)];
                    [betCoins[1] runAction:action3];
                    [betCoins[4] runAction:action4];
                    [self setCoins];
                }
                else
                {
                    [resultLabel setString:@"Win Ante Hand 1"];
                    [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[1]+betedCoins[4])*5]];
                    all_coins += (betedCoins[1]+betedCoins[4])*5;
                    CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[1].contentSize.height)];
                    CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[4].contentSize.height)];
                    [betCoins[1] runAction:action3];
                    [betCoins[4] runAction:action4];
                    [self setCoins];
                }
            }
            else if(temp1 + temp2 == 21)
            {
                [resultLabel setString:@"Win Ante Hand 1"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[1]+betedCoins[4])*2]];
                all_coins += (betedCoins[1]+betedCoins[4])*2;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[1].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[4].contentSize.height)];
                [betCoins[1] runAction:action3];
                [betCoins[4] runAction:action4];
                [self setCoins];
            }
            else if ((temp1 + temp2>=17) && (temp1+temp2<21)) {
                [resultLabel setString:@"Win Ante Hand 1"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[1]+betedCoins[4])*2]];
                all_coins += (betedCoins[1]+betedCoins[4])*2;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[1].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[4].contentSize.height)];
                [betCoins[1] runAction:action3];
                [betCoins[4] runAction:action4];
                [self setCoins];
            }
            else if(temp2 + temp1 == 16)
            {
                [resultLabel setString:@"Push Ante Hand 1"];
                [disLabel setString:[NSString stringWithFormat:@"Push"]];
                all_coins += (betedCoins[1]+betedCoins[4]);
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[1].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[4].contentSize.height)];
                [betCoins[1] runAction:action3];
                [betCoins[4] runAction:action4];
                [self setCoins];
            }
            else
            {
                [resultLabel setString:@"Lose Ante Hand 1"];
                [disLabel setString:[NSString stringWithFormat:@"Lose"]];
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[1].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[4].contentSize.height)];
                [betCoins[1] runAction:action3];
                [betCoins[4] runAction:action4];
            }
        }
        else
        {
            [resultLabel setString:@""];
            [disLabel setString:[NSString stringWithFormat:@""]];
        }
        canEvent = YES;
    }];
    CCActionSequence *seq;
    CCAction *delay = [CCActionDelay actionWithDuration:1.0f];
    CCActionCallFunc *func = [CCActionCallFunc actionWithTarget:self selector:@selector(setLabels)];
    seq = [CCActionSequence actionWithArray:@[action1,action2,delay,func]];
    [self runAction:seq];
}

-(void)checkHand2
{
//    [self setDisNull];
    float ti = 1.0f;
    [card_spirte[1] setTexture:[CCTexture textureWithFile:[NSString stringWithFormat:@"cards%d.png",player_cards[1]]]];
    CCActionDelay *action1 = [CCActionDelay actionWithDuration:ti];
    CCActionCallBlock *action2 = [CCActionCallBlock actionWithBlock:^{
        if (betedCoins[8] != 0) {
            int na1 = player_cards[3]%4;
            int temp1 = player_cards[3]/4;
            if (na1 != 0) {
                temp1 += 1;
            }
            
            int na2 = player_cards[1]%4;
            int temp2 = player_cards[1]/4;
            if (na2 != 0) {
                temp2 += 1;
            }
            
            if (temp1 == temp2) {
                [resultLabel setString:@"Win Match Hand 2"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",betedCoins[8]*11]];
                all_coins += betedCoins[8]*11;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[8].contentSize.height)];
                [betCoins[8] runAction:action3];
                [self setCoins];
            }
            else
            {
                [resultLabel setString:@"Lose Match Hand 2"];
                [disLabel setString:[NSString stringWithFormat:@"Lose"]];
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[8].contentSize.height)];
                [betCoins[8] runAction:action3];
            }
        }
        else
        {
            [resultLabel setString:@""];
            [disLabel setString:[NSString stringWithFormat:@""]];
        }
    }];
    CCActionSequence *seq;
    CCActionDelay *action6 = [CCActionDelay actionWithDuration:2.0f];
    CCActionCallFunc *action5 = [CCActionCallFunc actionWithTarget:self selector:@selector(checkHand2Ante)];
    seq = [CCActionSequence actionWithArray:@[action1,action2,action6,action5]];
    
    [self runAction:seq];
}

-(void)checkHand2Ante
{
//    [self setDisNull];
    float ti = 1.0f;
    CCActionDelay *action1 = [CCActionDelay actionWithDuration:ti];
    CCActionCallBlock *action2 = [CCActionCallBlock actionWithBlock:^{
        if (betedCoins[2] != 0) {
            int na1 = player_cards[3]%4;
            int temp1 = player_cards[3]/4;
            if (na1 != 0) {
                temp1 += 1;
            }
            if (temp1 == 1) {
                temp1 = 11;
            }
            else if(temp1>=10)
            {
                temp1 = 10;
            }
            int na2 = player_cards[1]%4;
            int temp2 = player_cards[1]/4;
            if (na2 != 0) {
                temp2 += 1;
            }
            if (temp2 == 1) {
                temp2 = 11;
            }
            else if(temp2>=10)
            {
                temp2 = 10;
            }
            
            if (temp1 + temp2 == 22)
            {
                if ((player_cards[3] == 2 && player_cards[1] == 4) || (player_cards[3] == 4 && player_cards[1] == 2)) {
                    [resultLabel setString:@"Win Ante Hand 2"];
                    [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[2]+betedCoins[5])*26]];
                    all_coins += (betedCoins[2]+betedCoins[5])*26;
                    CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[2].contentSize.height)];
                    CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[5].contentSize.height)];
                    [betCoins[2] runAction:action3];
                    [betCoins[5] runAction:action4];
                    [self setCoins];
                }
                else
                {
                    [resultLabel setString:@"Win Ante Hand 2"];
                    [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[2]+betedCoins[5])*6]];
                    all_coins += (betedCoins[2]+betedCoins[5])*6;
                    CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[2].contentSize.height)];
                    CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[5].contentSize.height)];
                    [betCoins[2] runAction:action3];
                    [betCoins[5] runAction:action4];
                    [self setCoins];
                }
            }
            else if(temp1 + temp2 == 21)
            {
                [resultLabel setString:@"Win Ante Hand 2"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[2]+betedCoins[5])*3]];
                all_coins += (betedCoins[2]+betedCoins[5])*3;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[2].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[5].contentSize.height)];
                [betCoins[2] runAction:action3];
                [betCoins[5] runAction:action4];
                [self setCoins];
            }
            else if ((temp1 + temp2>=17) && (temp1+temp2<21)) {
                [resultLabel setString:@"Win Ante Hand 2"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[2]+betedCoins[5])*2]];
                all_coins += (betedCoins[2]+betedCoins[5])*2;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[2].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[5].contentSize.height)];
                [betCoins[2] runAction:action3];
                [betCoins[5] runAction:action4];
                [self setCoins];
            }
            else if(temp2 + temp1 == 16)
            {
                [resultLabel setString:@"Push Ante Hand 2"];
                [disLabel setString:[NSString stringWithFormat:@"Push"]];
                all_coins += (betedCoins[2]+betedCoins[5]);
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[2].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[5].contentSize.height)];
                [betCoins[2] runAction:action3];
                [betCoins[5] runAction:action4];
                [self setCoins];
            }
            else
            {
                [resultLabel setString:@"Lose Ante Hand 2"];
                [disLabel setString:[NSString stringWithFormat:@"Lose"]];
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[2].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[5].contentSize.height)];
                [betCoins[2] runAction:action3];
                [betCoins[5] runAction:action4];
            }
        }
        else
        {
            [resultLabel setString:@""];
            [disLabel setString:[NSString stringWithFormat:@""]];
        }
        canEvent = YES;
    }];
    CCActionSequence *seq;
    CCAction *delay = [CCActionDelay actionWithDuration:1.0f];
    CCActionCallFunc *func = [CCActionCallFunc actionWithTarget:self selector:@selector(setLabels)];
    seq = [CCActionSequence actionWithArray:@[action1,action2,delay,func]];
    [self runAction:seq];
}

-(void)checkHand3
{
//    [self setDisNull];
    float ti = 1.0f;
    [card_spirte[2] setTexture:[CCTexture textureWithFile:[NSString stringWithFormat:@"cards%d.png",player_cards[2]]]];
    CCActionDelay *action1 = [CCActionDelay actionWithDuration:ti];
    CCActionCallBlock *action2 = [CCActionCallBlock actionWithBlock:^{
        if (betedCoins[9] != 0) {
            int na1 = player_cards[3]%4;
            int temp1 = player_cards[3]/4;
            if (na1 != 0) {
                temp1 += 1;
            }
            
            int na2 = player_cards[2]%4;
            int temp2 = player_cards[2]/4;
            if (na2 != 0) {
                temp2 += 1;
            }
            
            if (temp1 == temp2) {
                [resultLabel setString:@"Win Match Hand 3"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",betedCoins[9]*11]];
                all_coins += betedCoins[9]*11;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[9].contentSize.height)];
                [betCoins[9] runAction:action3];
                [self setCoins];
            }
            else
            {
                [resultLabel setString:@"Lose Match Hand 3"];
                [disLabel setString:[NSString stringWithFormat:@"Lose"]];
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[9].contentSize.height)];
                [betCoins[9] runAction:action3];
            }
        }
        else
        {
            [resultLabel setString:@""];
            [disLabel setString:[NSString stringWithFormat:@""]];
        }
    }];
    CCActionSequence *seq;
    CCActionDelay *action6 = [CCActionDelay actionWithDuration:2.0f];
    CCActionCallFunc *action5 = [CCActionCallFunc actionWithTarget:self selector:@selector(checkHand3Ante)];
    seq = [CCActionSequence actionWithArray:@[action1,action2,action6,action5]];
    [self runAction:seq];
}

-(void)checkHand3Ante
{
//    [self setDisNull];
    float ti = 1.0f;
    CCActionDelay *action1 = [CCActionDelay actionWithDuration:ti];
    CCActionCallBlock *action2 = [CCActionCallBlock actionWithBlock:^{
        if (betedCoins[3] != 0) {
            int na1 = player_cards[3]%4;
            int temp1 = player_cards[3]/4;
            if (na1 != 0) {
                temp1 += 1;
            }
            if (temp1 == 1) {
                temp1 = 11;
            }
            else if(temp1>=10)
            {
                temp1 = 10;
            }
            int na2 = player_cards[2]%4;
            int temp2 = player_cards[2]/4;
            if (na2 != 0) {
                temp2 += 1;
            }
            if (temp2 == 1) {
                temp2 = 11;
            }
            else if(temp2>=10)
            {
                temp2 = 10;
            }
            
            if (temp1 + temp2 == 22)
            {
                if ((player_cards[3] == 2 && player_cards[2] == 4) || (player_cards[3] == 4 && player_cards[2] == 2)) {
                    [resultLabel setString:@"Win Ante Hand 3"];
                    [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[3]+betedCoins[6])*41]];
                    all_coins += (betedCoins[3]+betedCoins[6])*41;
                    CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[3].contentSize.height)];
                    CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[6].contentSize.height)];
                    [betCoins[3] runAction:action3];
                    [betCoins[6] runAction:action4];
                    [self setCoins];
                }
                else
                {
                    [resultLabel setString:@"Win Ante Hand 3"];
                    [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[3]+betedCoins[6])*11]];
                    all_coins += (betedCoins[3]+betedCoins[6])*11;
                    CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[3].contentSize.height)];
                    CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[6].contentSize.height)];
                    [betCoins[3] runAction:action3];
                    [betCoins[6] runAction:action4];
                    [self setCoins];
                }
            }
            else if(temp1 + temp2 == 21)
            {
                [resultLabel setString:@"Win Ante Hand 3"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[3]+betedCoins[6])*4]];
                all_coins += (betedCoins[3]+betedCoins[6])*4;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[3].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[6].contentSize.height)];
                [betCoins[3] runAction:action3];
                [betCoins[6] runAction:action4];
                [self setCoins];
            }
            else if ((temp1 + temp2>=17) && (temp1+temp2<21)) {
                [resultLabel setString:@"Win Ante Hand 3"];
                [disLabel setString:[NSString stringWithFormat:@"+%d",(betedCoins[3]+betedCoins[6])*2]];
                all_coins += (betedCoins[3]+betedCoins[6])*2;
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[3].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[6].contentSize.height)];
                [betCoins[3] runAction:action3];
                [betCoins[6] runAction:action4];
                [self setCoins];
            }
            else if(temp2 + temp1 == 16)
            {
                [resultLabel setString:@"Push Ante Hand 3"];
                [disLabel setString:[NSString stringWithFormat:@"Push"]];
                all_coins += (betedCoins[3]+betedCoins[6]);
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[3].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(betBtn.position.x, -betCoins[6].contentSize.height)];
                [betCoins[3] runAction:action3];
                [betCoins[6] runAction:action4];
                [self setCoins];
            }
            else
            {
                [resultLabel setString:@"Lose Ante Hand 3"];
                [disLabel setString:[NSString stringWithFormat:@"Lose"]];
                CCActionMoveTo *action3 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[3].contentSize.height)];
                CCActionMoveTo *action4 = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height+betCoins[6].contentSize.height)];
                [betCoins[3] runAction:action3];
                [betCoins[6] runAction:action4];
            }
        }
        else
        {
            [resultLabel setString:@""];
            [disLabel setString:[NSString stringWithFormat:@""]];
        }
    }];
    CCActionSequence *seq;
    CCAction *delay = [CCActionDelay actionWithDuration:2.5f];
    CCActionCallBlock *func = [CCActionCallBlock actionWithBlock:^{
        newBtn.enabled = YES;
        [resultLabel setString:@"Game Over"];
    }];
    seq = [CCActionSequence actionWithArray:@[action1,action2,delay,func]];
    [self runAction:seq];
}

-(void)onNew
{
    [self resetAll];
    newBtn.enabled = NO;
    [disLabel setString:@""];
    [resultLabel setString:@""];
}

-(void)resetAll
{
    for (int j=0; j<10; j++) {
        betCoins[j].visible = NO;
        betCoins[j].position = betBtn.position;
        betedCoins[j] = 0;
    }
    
    for (int i=0; i<4; i++) {
        CCActionMoveTo *action = [CCActionMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2.0f, self.contentSize.height*1.2f)];
        [card_spirte[i] runAction:action];
    }
    CCActionDelay *action2 = [CCActionDelay actionWithDuration:0.3f];
    CCActionCallBlock *action1 = [CCActionCallBlock actionWithBlock:^{
        canEvent = YES;
        c_step = 1;
        isFlop[0] = NO;
        isFlop[1] = NO;
        isFlop[2] = NO;
        betAmount = 0;
        isSetBet = NO;
        [self setLabels];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[action2,action1]];
    [self runAction:seq];
}

-(void)onClear
{
    if(c_step == 1)
    {
        
    }
    else if(c_step == 2)
    {
        c_step = 1;
        all_coins+=betedCoins[0];
        betedCoins[0] = 0;
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:ccp(self.contentSize.width*0.35f, -self.contentSize.height*0.5f)];
        [betCoins[0] runAction:action];
        [self setBetDefault];
        [self setLabels];
        [self setCoins];
    }
    else if(c_step == 3)
    {
        c_step = 2;
        all_coins+=betedCoins[1];
        betedCoins[1] = 0;
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:ccp(self.contentSize.width*0.35f, -self.contentSize.height*0.5f)];
        [betCoins[1] runAction:action];
        [self setBetDefault];
        [self setLabels];
        [self setCoins];
    }
    else if(c_step == 4)
    {
        c_step = 3;
        all_coins+=betedCoins[2];
        betedCoins[2] = 0;
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:ccp(self.contentSize.width*0.35f, -self.contentSize.height*0.5f)];
        [betCoins[2] runAction:action];
        [self setLabels];
        [self setCoins];
    }
    else if(c_step == 5)
    {
        
    }
    else if(c_step == 6)
    {
        if (isFlop[0] == YES) {
            return;
        }
        c_step = 5;
        all_coins+=betedCoins[4];
        betedCoins[4] = 0;
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:ccp(self.contentSize.width*0.35f, -self.contentSize.height*0.5f)];
        [betCoins[4] runAction:action];
        [self setLabels];
        [self setCoins];
    }
    else if(c_step == 7)
    {
        if (isFlop[1] == YES) {
            return;
        }
        c_step = 6;
        all_coins+=betedCoins[5];
        betedCoins[5] = 0;
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:ccp(self.contentSize.width*0.35f, -self.contentSize.height*0.5f)];
        [betCoins[5] runAction:action];
        [self setLabels];
        [self setCoins];
    }
    else if(c_step == 8)
    {
        if (isFlop[2] == YES) {
            return;
        }
        c_step = 7;
        all_coins+=betedCoins[6];
        betedCoins[6] = 0;
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:ccp(self.contentSize.width*0.35f, -self.contentSize.height*0.5f)];
        [betCoins[6] runAction:action];
        [self setLabels];
        [self setCoins];
    }
    else if(c_step == 9)
    {
        if (isFlop[0] == YES) {
            return;
        }
        c_step = 8;
        all_coins+=betedCoins[7];
        betedCoins[7] = 0;
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:ccp(self.contentSize.width*0.35f, -self.contentSize.height*0.5f)];
        [betCoins[7] runAction:action];
        [self setLabels];
        [self setCoins];
    }
    else if(c_step == 10)
    {
        if (isFlop[1] == YES) {
            return;
        }
        c_step = 9;
        all_coins+=betedCoins[8];
        betedCoins[8] = 0;
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:ccp(self.contentSize.width*0.35f, -self.contentSize.height*0.5f)];
        [betCoins[8] runAction:action];
        [self setLabels];
        [self setCoins];
    }
    else if(c_step == 11)
    {
        if (isFlop[2] == YES) {
            return;
        }
        c_step = 10;
        all_coins+=betedCoins[9];
        betedCoins[9] = 0;
        CCAction *action = [CCActionMoveTo actionWithDuration:0.4f position:ccp(self.contentSize.width*0.35f, -self.contentSize.height*0.5f)];
        [betCoins[9] runAction:action];
        [self setLabels];
        [self setCoins];
    }
}

-(void)onDone
{
    if (canEvent == NO) {
        return;
    }
    if (c_step == 1) {
        betedCoins[c_step-1] = 0;
        c_step = 2;
    }
    else if((c_step>=2) && (c_step<=4))
    {
        if (betedCoins[1] == 10) {
            c_step = 5;
        }
        else
        {
            if (isFlop[0] == NO) {
                c_step = 8;
            }
            else if(isFlop[1] == NO)
            {
                c_step = 9;
            }
            else if(isFlop[2] == NO)
            {
                c_step = 10;
            }
        }
        [self dealtheCards];
        return;
    }
    else if((c_step>=5) && (c_step<=7))
    {
        if (isFlop[0] == NO) {
            c_step = 8;
        }
        else if(isFlop[1] == NO)
        {
            c_step = 9;
        }
        else if(isFlop[2] == NO)
        {
            c_step = 10;
        }
    }
    else
    {
            c_step ++;
//            canEvent = NO;
//            return;
    }
    [self setLabels];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

//- (void)onBackClicked:(id)sender
//{
//    // back to intro scene with transition
//    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
//                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
//}

// -----------------------------------------------------------------------
@end

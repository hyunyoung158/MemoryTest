//
//  ViewController.m
//  MemoryTest
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"

#define COMPUTER_ANIMATION_DURATION 0.5f
#define USER_ANIMATION_DURATION 0.2f

@interface ViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;

@end

@implementation ViewController {
    NSMutableArray *_randomList;
    NSInteger stageNum;
    NSInteger userChallengeNum;
}
// 게임 시작
- (IBAction)startGame:(id)sender {
    [self stageStart];
    self.buttonStart.hidden = YES;
}

- (IBAction)touchButton:(id)sender {
//    UIButton *button = (UIButton *)sender;
//    button.backgroundColor = [UIColor grayColor];
}

- (IBAction)selectButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self animationSelectButton:[NSNumber numberWithInteger:button.tag] withMode:[NSNumber numberWithFloat:0.2f]];
    [self userInput:button.tag];
}


- (void)stageStart {
    // 스테이지 시작 시 먼저 보여주는 과정~
    // 랜덤 배열을 생성해서 저장.
    // 배열에서 꺼내면서 버튼에 색깔로 보여주기.
    // 유저 인풋 금지.
    
    //뷰 그리기
    self.levelLabel.text = [NSString stringWithFormat:@"%d", stageNum];
    //유저 인풋 금지.
    [self buttonInputEnableMode:0];
    
    userChallengeNum = 0;
    [_randomList addObject:@(arc4random() % 4)];

    float delay = 0.0f;
    for (int i = 0; i < [_randomList count]; i++) {
        NSInteger tagNum = [[_randomList objectAtIndex:i] integerValue];
//        NSArray *objects = @[[NSNumber numberWithInteger:tagNum],[NSNumber numberWithFloat:1.0f]];
        [self performSelector:@selector(animationSelectButton:withMode:) withObject:[NSNumber numberWithInteger:tagNum] afterDelay:delay];
        delay += 1.0f;
    }
    NSLog(@"delay : %f", delay);
    [self performSelector:@selector(buttonInputEnableMode:) withObject:[NSNumber numberWithBool:1] afterDelay:delay];
}

- (void)stageFail {
    // 점수와 랭킹페이지로 갈 수 있는 버튼이 있는 alertview 를 띄운다.
    // 랭킹으로 갈 때엔 modal.
    // 확인을 누르면 뷰를 초기화~
    NSString *message = [NSString stringWithFormat:@"Your Score : %d", stageNum];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", @"Ranking", nil];

    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        // OK 눌렀을 때
        [self stageInit];
    }else if (buttonIndex == alertView.firstOtherButtonIndex + 1) {
        // Ranking 눌렀을 때
        // modal view 이동
    }
}

- (void)userInput:(NSInteger) buttonNum {
    // 해당 스테이지 마다 유저가 버튼을 누르는 부분을 받아들이는 부분.
    // 배열과 비교해서 맞으면 가만있고 틀리면 alertview 띄우고 끗.
    NSInteger answerNum = [[_randomList objectAtIndex:userChallengeNum] integerValue];
    if (buttonNum == answerNum) {
        // 맞았을 때.
        userChallengeNum++;
        
        // 다 맞췄을 때
        if (userChallengeNum == ([_randomList count])) {
            // 스테이지 클리어
            [self buttonInputEnableMode:0];
            self.levelLabel.text = [NSString stringWithFormat:@"Stage %d Clear!", stageNum];
            NSLog(@"stage clear");
            stageNum++;
            [self performSelector:@selector(stageStart) withObject:nil afterDelay:3.0f];
        }
    } else {
        // 틀렸을 때.
        NSLog(@"Fail!!!");
        [self stageFail];
    }
}
- (void)buttonInputEnableMode:(NSNumber *)mode {
    BOOL modeNum = [mode boolValue];
    if (modeNum == 1) {
        self.buttonOne.enabled = YES;
        self.buttonTwo.enabled = YES;
        self.buttonThree.enabled = YES;
        self.buttonFour.enabled = YES;
    } else {
        self.buttonOne.enabled = NO;
        self.buttonTwo.enabled = NO;
        self.buttonThree.enabled = NO;
        self.buttonFour.enabled = NO;
    }
}

// 스테이지 초기화
- (void)stageInit {
    _randomList = [[NSMutableArray alloc] init];
    stageNum = 1;
    
    // 뷰 새로 그리기.
    self.levelLabel.text = @"";
    self.buttonStart.hidden = NO;
}

- (void)animationSelectButton:(NSNumber *)buttonTagNum withMode:(NSNumber *)mode{
    NSLog(@"button tag num : %@", buttonTagNum);
    NSInteger tagNum = [buttonTagNum integerValue];
    NSInteger modeTime = [mode integerValue];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:tagNum];
    NSLog(@"button %@", button);
    UIColor *originalColor = button.backgroundColor;
    
    [UIView animateWithDuration:0.5 animations:^{
        button.backgroundColor = [UIColor grayColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            button.backgroundColor = originalColor;
        }];
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 초기화
    [self stageInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

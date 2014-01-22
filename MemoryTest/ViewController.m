//
//  ViewController.m
//  MemoryTest
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ViewController {
    NSMutableArray *_randomList;
    NSInteger stageNum;
}

- (IBAction)touchButton:(id)sender {
//    UIButton *button = (UIButton *)sender;
//    button.backgroundColor = [UIColor grayColor];
}

- (IBAction)selectButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    UIColor *originalColor = button.backgroundColor;
    
    // 버튼 색 변경
//    [UIView animateWithDuration:0.5 animations:^{
//        button.backgroundColor = [UIColor grayColor];
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.5 animations:^{
//            button.backgroundColor = originalColor;
//        }];
//    }];
    [self animationSelectButton:[NSNumber numberWithInteger:button.tag]];
    
    [self userInput:button.tag];
}

- (void)startStage {
    // 스테이지 시작 시 먼저 보여주는 과정~
    // 랜덤 배열을 생성해서 저장.
    // 배열에서 꺼내면서 버튼에 색깔로 보여주기.
    // 유저 인풋 금지.
    
    [_randomList addObject:@(arc4random() % 4)];

    
    for (int i = 0; i < [_randomList count]; i++) {
        NSInteger tagNum = [[_randomList objectAtIndex:i] integerValue];
        [self performSelector:@selector(animationSelectButton:) withObject:[NSNumber numberWithInteger:tagNum] afterDelay:1.0];
//        [self animationSelectButton:tagNum];
    }
}

- (void)animationSelectButton:(NSNumber *) buttonTagNum {
    NSLog(@"button tag num : %@", buttonTagNum);
    UIButton *button = (UIButton *)[self.view viewWithTag:(NSInteger)buttonTagNum];
    UIColor *originalColor = button.backgroundColor;
    
    [UIView animateWithDuration:0.5 animations:^{
        button.backgroundColor = [UIColor grayColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            button.backgroundColor = originalColor;
        }];
    }];
    
}

- (void)userInput:(NSInteger) buttonNum {
    // 해당 스테이지 마다 유저가 버튼을 누르는 부분을 받아들이는 부분.
    // 배열과 비교해서 맞으면 가만있고 틀리면 alertview 띄우고 끗.
}

// 스테이지 초기화
- (void)stageInit {
    _randomList = [[NSMutableArray alloc] init];
    stageNum = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 초기화
    [self stageInit];
    [self startStage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

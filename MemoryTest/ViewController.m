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

@implementation ViewController


- (void)startStage {
    // 스테이지 시작 시 먼저 보여주는 과정~
    // 랜덤 배열을 생성해서 저장.
    // 배열에서 꺼내면서 버튼에 색깔로 보여주기.
}

- (void)userInput:(NSInteger) buttonNum {
    // 해당 스테이지 마다 유저가 버튼을 누르는 부분을 받아들이는 부분.
    // 배열과 비교해서 맞으면 가만있고 틀리면 alertview 띄우고 끗.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

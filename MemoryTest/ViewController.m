//
//  ViewController.m
//  MemoryTest
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "RankingViewController.h"
#import "User.h"
#import <sqlite3.h>

#define TOTAL_TIME 10

@interface ViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;


@end

@implementation ViewController {
    NSMutableArray *_randomList;
    NSInteger stageNum;
    NSInteger userChallengeNum;
    NSTimer *_timer;
    float elapsedTime;
    BOOL animationDurationFlag;
    
    // DB
    NSMutableArray *data;
    sqlite3 *db;
    NSString *username;
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
    
    if (animationDurationFlag == 0) {
        animationDurationFlag = 1;
    }
    
//    [self animationSelectButton:[NSNumber numberWithInteger:button.tag]];
    [self userInput:button.tag];
}


- (void)stageStart {
    // 스테이지 시작 시 먼저 보여주는 과정~
    // 랜덤 배열을 생성해서 저장.
    // 배열에서 꺼내면서 버튼에 색깔로 보여주기.
    // 유저 인풋 금지.
    
    //뷰 그리기
    self.levelLabel.text = [NSString stringWithFormat:@"%d", stageNum];
    self.descLabel.text = @"";
    self.timeLabel.text = @"";
    //유저 인풋 금지.
    [self buttonInputEnableMode:0];
    
    userChallengeNum = 0;
    animationDurationFlag = 0;
    elapsedTime = 0;
    [_randomList addObject:@(arc4random() % 4)];

    float delay = 0.0f;
    for (int i = 0; i < [_randomList count]; i++) {
        NSInteger tagNum = [[_randomList objectAtIndex:i] integerValue];
        [self performSelector:@selector(animationSelectButton:) withObject:[NSNumber numberWithInteger:tagNum] afterDelay:delay];
        delay += 1.0f;
    }
    NSLog(@"delay : %f", delay);
    [self performSelector:@selector(buttonInputEnableMode:) withObject:[NSNumber numberWithBool:1] afterDelay:delay];
    // 타이머 시작
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:delay-1];
}

- (void)startTimer {
//    _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(checkTime:) userInfo:nil repeats:YES];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkTime:) userInfo:nil repeats:YES];
    NSLog(@"timer : %@", _timer);
}

- (void)checkTime:(NSTimer *)timer {
    NSLog(@"%f", elapsedTime);
    NSInteger remainTime = TOTAL_TIME - (NSInteger)elapsedTime;
    self.timeLabel.text = [NSString stringWithFormat:@"%d", remainTime];
    
    // 시간 초과
    if (remainTime <= 0) {
        [self stageFail];
        [_timer invalidate];
    }else {
        elapsedTime += timer.timeInterval;
    }
    
}

- (void)stageFail {
    // 점수와 랭킹페이지로 갈 수 있는 버튼이 있는 alertview 를 띄운다.
    // 랭킹으로 갈 때엔 modal.
    // 확인을 누르면 뷰를 초기화~
    [_timer invalidate];
    NSString *message = [NSString stringWithFormat:@"Your Score : %d", stageNum];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", @"Ranking", nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    username = textField.text;
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        // OK 눌렀을 때
        [self addData:username WithScore:stageNum];
        [self stageInit];
    }else if (buttonIndex == alertView.firstOtherButtonIndex + 1) {
        // Ranking 눌렀을 때
        // modal view 이동
        [self addData:username WithScore:stageNum];
        [self performSegueWithIdentifier:@"segue" sender:self];
        [self stageInit];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"segue" isEqualToString:segue.identifier]) {
        RankingViewController *rankVC = segue.destinationViewController;
        //모달 뷰 컨트롤러의 데이터에 값 전달
        [self resolveData];
        rankVC.data = data;
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
            [_timer invalidate];
            [self buttonInputEnableMode:0];
            self.descLabel.text = [NSString stringWithFormat:@"Stage %d Clear!", stageNum];
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
//        [self.view setUserInteractionEnabled:NO];
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
    animationDurationFlag = 0;
    elapsedTime = 0;
    // 뷰 새로 그리기.
    self.levelLabel.text = @"Memory Tests";
    self.buttonStart.hidden = NO;
    [self buttonInputEnableMode:0];
    self.buttonStart.enabled = YES;
    
}

- (void)animationSelectButton:(NSNumber *)buttonTagNum{
    NSLog(@"button tag num : %@", buttonTagNum);
    float duration;
    
    if (animationDurationFlag == 0) {
        duration = 0.5f;
    }else {
        duration = 0.2f;
    }
    
    NSInteger tagNum = [buttonTagNum integerValue];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:tagNum];
    NSLog(@"button %@", button);
    UIImage *originalImage = button.imageView.image;
    NSLog(@"%@", originalImage);
    
    
    [UIView animateWithDuration:duration animations:^{
        button.backgroundColor = [UIColor grayColor];
//        button setImage:[UIImage imageNamed:<#(NSString *)#>] forState:<#(UIControlState)#>
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
                    button.backgroundColor = [UIColor clearColor];
        }];
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 초기화
    [self stageInit];
    
    // DB 초기화
    data = [[NSMutableArray alloc] init];
    [self openDB];
    
    // 버튼 이미지 할당
    [self.buttonOne setImage:[UIImage imageNamed:@"star1@2x.png"] forState:UIControlStateNormal]; // 노말
    [self.buttonOne setImage:[UIImage imageNamed:@"star1@2x.png"] forState:UIControlStateDisabled]; // disable
    [self.buttonOne setImage:[UIImage imageNamed:@"star1_s@2x.png"] forState:UIControlStateHighlighted]; // 누를 때
    [self.buttonTwo setImage:[UIImage imageNamed:@"star2@2x.png"] forState:UIControlStateNormal];
    [self.buttonTwo setImage:[UIImage imageNamed:@"star2@2x.png"] forState:UIControlStateDisabled];
    [self.buttonTwo setImage:[UIImage imageNamed:@"star2_s@2x.png"] forState:UIControlStateHighlighted];
    [self.buttonThree setImage:[UIImage imageNamed:@"star3@2x.png"] forState:UIControlStateNormal];
    [self.buttonThree setImage:[UIImage imageNamed:@"star3@2x.png"] forState:UIControlStateDisabled];
    [self.buttonThree setImage:[UIImage imageNamed:@"star3_s@2x.png"] forState:UIControlStateHighlighted];
    [self.buttonFour setImage:[UIImage imageNamed:@"star4@2x.png"] forState:UIControlStateNormal];
    [self.buttonFour setImage:[UIImage imageNamed:@"star4@2x.png"] forState:UIControlStateDisabled];
    [self.buttonFour setImage:[UIImage imageNamed:@"star4_s@2x.png"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ===================== DB ===================
//db 오픈 없으면 새로 만들기
- (void)openDB {
    //데이터베이스 파일 경로 구하기
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbFilePath = [docPath stringByAppendingPathComponent:@"db.sqlite"];
    
    //데이터 베이스 파일 체크
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existFile = [fm fileExistsAtPath:dbFilePath];
    
    //없으면 데이터 베이스 파일 생성.
    if (NO == existFile) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
        NSError *error;
        BOOL success = [fm copyItemAtPath:defaultDBPath toPath:dbFilePath error:&error];
        
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
        
    }
    //데이터 베이스 오픈은 항상 해줘야.
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    NSAssert1(SQLITE_OK == ret, @"Error on opening Database : %s", sqlite3_errmsg(db));
    NSLog(@"Success on Opening Database");
    //테이블 생성
    const char *createSQL = "CREATE TABLE IF NOT EXISTS USER (TITLE TEXT, score INT);";
    char *errorMsg;
    ret = sqlite3_exec(db, createSQL, NULL, NULL, &errorMsg);
    
    if (ret != SQLITE_OK) {
        [fm removeItemAtPath:dbFilePath error:nil];
        NSAssert1(SQLITE_OK == ret, @"Error on creating table: %s", errorMsg);
        NSLog(@"creating table with ret : %d", ret);
    }
    
}

// 새로운 데이터를 데이터베이스에 저장한다.
- (void)addData:(NSString *)input WithScore:(NSInteger)score {
    NSLog(@"adding data :%@", input);
    
    //sqlite3_exec 로 실행하기
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO USER (TITLE, score) VALUES ('%@', %d)", input, score];
    NSLog(@"sql : %@", sql);
    
    char *errMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, nil, &errMsg);
    
    if (SQLITE_OK != ret) {
        NSLog(@"Error on Insert New data : %s", errMsg);
    }
    //이후 화면 갱신을 위해서 select를 호출
    [self resolveData];
}

//데이터베이스 닫기
- (void)closeDB {
    sqlite3_close(db);
}

//데이터베이스에서 정보를 가져온다.
- (void)resolveData {
    //기존 데이터 삭제
    [data removeAllObjects];
    
    //데이터베이스에서 사용할 쿼리 준비
    NSString *queryStr = @"SELECT score, title FROM USER ORDER BY score DESC";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"Error(%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    //모든 행의 정보를 얻어온다.
    while (SQLITE_ROW == sqlite3_step(stmt)) {
        int rowID = sqlite3_column_int(stmt, 0);
        char *title = (char *)sqlite3_column_text(stmt, 1);
        
        //User 객체 생성, 데이터 세팅
        User *one = [[User alloc] init];
        one.score = rowID;
        one.name = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
        
        [data addObject:one];
    }
    
    sqlite3_finalize(stmt);
    
    //테이블 갱신
//    [self.table reloadData];
}

@end

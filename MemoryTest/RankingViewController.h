//
//  RankingViewController.h
//  MemoryTest
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingViewController : UIViewController

@property (nonatomic) NSInteger score;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *data;
@end

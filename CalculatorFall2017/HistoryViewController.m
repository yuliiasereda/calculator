//
//  HistoryViewController.m
//  CalculatorFall2017
//
//  Created by Yuliia on 16.11.17.
//  Copyright © 2017 Yuliia Sereda. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"History";
    self.result.text = [[self.historyContent valueForKey:@"description"] componentsJoinedByString:@" \n "];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cleanAllHistory {
    [self.historyContent removeAllObjects];
    self.result.text = @"";
}

@end

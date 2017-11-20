//
//  HistoryViewController.h
//  CalculatorFall2017
//
//  Created by Yuliia on 16.11.17.
//  Copyright © 2017 Yuliia Sereda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController
@property(weak, nonatomic) IBOutlet UILabel *result;
@property(weak, nonatomic) NSString *dataTransfer;
@property (nonatomic, strong) NSMutableArray *historyContent;

@end

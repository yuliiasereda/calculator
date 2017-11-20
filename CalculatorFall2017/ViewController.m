//
//  ViewController.m
//  CalculatorFall2017
//
//  Created by Yuliia on 29.10.17.
//  Copyright © 2017 Yuliia Sereda. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorModel.h"
#import "HistoryViewController.h"

static int const maxNumberOfCharacters = 16;

@interface ViewController () <UIGestureRecognizerDelegate>

@property(weak, nonatomic) IBOutlet UILabel *resultLabel;
@property(assign, nonatomic) BOOL isUserInTheMiddleOfTyping;
@property(assign, nonatomic) double displayValue;
@property(assign, nonatomic) BOOL isEnableToTyping;
@property(strong, nonatomic) NSString *operator;
@property(strong, nonatomic) CalculatorModel *calculator;
@property(strong, nonatomic) UISwipeGestureRecognizer *swipeRight;
@property(strong, nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic, strong) NSMutableArray *testArray;


@end

@implementation ViewController

- (CalculatorModel *)calculator{
    if(!_calculator){
        _calculator = [CalculatorModel new];
    }
    return _calculator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Calculator";
    self.testArray = [NSMutableArray array];
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action: @selector(deleteLastCharacter:)];
    self.swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    self.swipeRight.delegate = self;
    [self.resultLabel addGestureRecognizer:self.swipeRight];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action: @selector(deleteLastCharacter:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    self.swipeLeft.delegate = self;
    [self.resultLabel addGestureRecognizer:self.swipeLeft];
}

-(IBAction)deleteLastCharacter:(UISwipeGestureRecognizer *)gestureRecognizer{
    if (self.resultLabel.text.length > 1) {
        self.resultLabel.text = [self.resultLabel.text substringToIndex:self.resultLabel.text.length - 1];
    } else {
        self.resultLabel.text = @"0";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (double)displayValue{
    return self.resultLabel.text.doubleValue;
}

- (void)setDisplayValue:(double)displayValue{
    self.resultLabel.text = [NSString stringWithFormat:@"%g", displayValue];
}

- (IBAction)touchDigitButton:(UIButton *)sender {
    if(self.resultLabel.text.length >= maxNumberOfCharacters){
        return;
    }
    if(self.isUserInTheMiddleOfTyping){
        NSString *currentlyDisplayedValue = self.resultLabel.text;
        NSString *digitText = sender.currentTitle;
        self.resultLabel.text = [currentlyDisplayedValue stringByAppendingString:digitText];
    } else {
        self.resultLabel.text = sender.currentTitle;
        self.isUserInTheMiddleOfTyping = YES;
    }
}

- (IBAction)performOperation:(UIButton *)sender {
    if(self.isUserInTheMiddleOfTyping){
        [self.calculator setOperand:self.displayValue];
        [self.testArray addObject:[@(self.displayValue) stringValue]];
    }
    NSString *mathematicalSymbol = sender.currentTitle;
    self.isUserInTheMiddleOfTyping = NO;
    if(mathematicalSymbol){
        [self.calculator performOperation:mathematicalSymbol];
        [self.testArray addObject:mathematicalSymbol];
        if([self.calculator isGivingResultImmediately:mathematicalSymbol]){
            [self.testArray addObject:[@(self.calculator.result) stringValue]];
        }
    }
    self.displayValue = self.calculator.result;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"fromFirstToSecond"]){
        HistoryViewController *historyViewController=(HistoryViewController *)segue.destinationViewController;
        historyViewController.historyContent = [NSMutableArray array];
//        NSRange endRange = NSMakeRange(self.testArray.count >= 5 ? self.testArray.count - 5 : 0, MIN(self.testArray.count, 5));
//        historyViewController.historyContent = [self.testArray subarrayWithRange:endRange];
        historyViewController.historyContent = [self.testArray mutableCopy];
    }
}
@end

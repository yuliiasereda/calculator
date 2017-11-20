//
//  CalculatorModel.h
//  CalculatorFall2017
//
//  Created by Yuliia on 03.11.17.
//  Copyright © 2017 Yuliia Sereda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorModel : NSObject

@property(assign, nonatomic, readonly) double result;

- (void)performOperation:(NSString *)mathematicalSymbol;
- (void)setOperand:(double)operand;
- (BOOL) isGivingResultImmediately:(NSString *)mathematicalSymbol;
@end

//
//  CalculatorModel.m
//  CalculatorFall2017
//
//  Created by Yuliia on 03.11.17.
//  Copyright © 2017 Yuliia Sereda. All rights reserved.
//

#import "CalculatorModel.h"

typedef double(^unaryOperation)(double value);
typedef double(^binaryOperation)(double first, double second);

@interface CalculatorModel()
@property(assign, nonatomic) double accumulator;
@property(assign, nonatomic) double pendingFirstOperand;
@property(copy, nonatomic) binaryOperation pendingBinaryOperation;
@end


@implementation CalculatorModel

typedef enum: NSUInteger {
    OperationUndefined,
    OperationConstant,
    OperationUnary,
    OperationBinary,
    OperationEquals
} Operation;

- (void)setOperand:(double)operand{
    self.accumulator = operand;
}

- (void)performOperation:(NSString *)mathematicalSymbol{
    if(!mathematicalSymbol){
        return;
    }
    
    Operation operationType = [self operationType:mathematicalSymbol];
    
    switch (operationType) {
        case OperationConstant:
            self.accumulator = [[self constants][mathematicalSymbol] doubleValue];
            break;
        case OperationUnary:
            self.accumulator = [self unaryOperation:mathematicalSymbol operand:self.accumulator];
            break;
        case OperationBinary:
            [self executePendingBinaryOperation];
            self.pendingFirstOperand = self.accumulator;
            self.pendingBinaryOperation = [self binaryOperations][mathematicalSymbol];
            break;
        case OperationEquals:
            [self executePendingBinaryOperation];
            break;
            default:
            break;
    }
}

- (void)executePendingBinaryOperation{
    if(self.pendingBinaryOperation){
        self.accumulator = self.pendingBinaryOperation(self.pendingFirstOperand, self.accumulator);
        self.pendingBinaryOperation = nil;
    }
}

- (double)result{
    return self.accumulator;
}

- (Operation)operationType:(NSString *)mathematicalSymbol{
    NSArray *constants = @[@"π", @"e", @"C"];
    NSArray *unaryOperation = @[@"√", @"x²", @"10ˣ", @"1/x", @"㏒₂", @"㏒₁₀", @"±", @"x!", @"cos", @"sin", @"tan"];
    NSArray *binaryOperaton = @[@"+", @"−", @"×", @"÷", @"﹪"];
    NSArray *operationEquals = @[@"="];
    
    if([constants containsObject:mathematicalSymbol]){
        return OperationConstant;
    }
    if([unaryOperation containsObject:mathematicalSymbol]){
        return OperationUnary;
    }
    if([binaryOperaton containsObject:mathematicalSymbol]){
        return OperationBinary;
    }
    if([operationEquals containsObject:mathematicalSymbol]){
        return OperationEquals;
    }
    return OperationUndefined;
}

- (NSDictionary <NSString *, NSNumber *> *)constants{
    return @{
             @"π" : @(M_PI),
             @"e" : @(M_E),
             @"C" : @(0)
             };
}

- (NSDictionary *)unaryOperations {
    return @{
             @"√" : ^(double value){
                 return sqrt(value);
             },
             @"x²" : ^(double value){
                 return pow(value, 2);
             },
             @"10ˣ" : ^(double value){
                 return pow(10, value);
             },
             @"1/x" : ^(double value){
                 return 1 / value;
             },
             @"㏒₂" : ^(double value){
                 return log2(value);
             },
             @"㏒₁₀" : ^(double value){
                 return log10(value);
             },
             @"±" : ^(double value){
                 return (-1) * value;
                 },
             @"x!" : ^(double value){
                 return [self factorial:value];
                },
             @"cos" : ^(double value){
                 return cos(value);
             },
             @"sin" : ^(double value){
                 return sin(value);
             },
             @"tan" : ^(double value){
                 return tan(value);
             }
             };
}

- (NSDictionary *) binaryOperations{
    return @{
             @"+" : ^(double first, double second){
                 return first + second;
             },
             @"−" : ^(double first, double second){
                 return first - second;
             },
             @"×" : ^(double first, double second){
                 return first * second;
             },
             @"÷" : ^(double first, double second){
                 return first / second;
             }
             };
}

- (double) unaryOperation:(NSString *)operation operand:(double)operand{
    unaryOperation op = [self unaryOperations][operation];
    return op(operand);
}

- (double) factorial:(double)value{
    int result = 1;
    for ( int i = 2; i <= value; i++ ) {
        result *= i;
    }
    return result;
}

- (BOOL) isGivingResultImmediately:(NSString *)mathematicalSymbol{
    NSArray *operationsGiveResultImmediately = @[@"√", @"x²", @"10ˣ", @"1/x", @"㏒₂", @"㏒₁₀", @"±", @"x!", @"cos", @"sin", @"tan", @"="];
       return [operationsGiveResultImmediately containsObject:mathematicalSymbol];
}

@end

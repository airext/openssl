//
//  TestRSA.h
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 04.12.2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestRSA : NSObject

#pragma mark - Shared Instance

+ (TestRSA*)sharedInstance;


#pragma mark - Test

- (void)test;

- (void)test_ane;

@end

NS_ASSUME_NONNULL_END

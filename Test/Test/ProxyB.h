//
//  ProxyB.h
//  Test
//
//  Created by YoloMao on 2021/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProxyB : NSProxy

- (nonnull instancetype)initWithTarget:(nonnull id)target;

@end

NS_ASSUME_NONNULL_END

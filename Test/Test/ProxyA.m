//
//  ProxyA.m
//  Test
//
//  Created by YoloMao on 2021/5/18.
//

#import "ProxyA.h"
#import <objc/runtime.h>

@interface ProxyA ()

@property (nonatomic, weak, readonly, nullable) id target;

@end

@implementation ProxyA

- (nonnull instancetype)initWithTarget:(nonnull id)target {
    _target = target;
    return self;
}

//1.第一种方式，直接实现
////本身实现了sayHello
//- (void)sayHello {
//    NSLog(@"ProxyA to %@ sayHello", [_target class]);
//}

//2.另一种方式，动态实现
////动态添加了sayHello
//void a_sayHelloMethod(id obj, SEL _cmd) {
//    NSLog(@"ProxyA to %@ dynamic sayHello", [((ProxyA *)obj).target class]);
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(sayHello)) {
//        class_addMethod([self class], sel, (IMP)a_sayHelloMethod, "v@:");
//        return YES;
//    }
//    return NO;
//}

//如果本身实现或动态添加了sayHello，不会进入forwardingTargetForSelector
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(sayHello)) {
        return _target;
    }
    return nil;
}

//...
- (void)forwardInvocation:(NSInvocation *)invocation {
    
}

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [super methodSignatureForSelector:sel];
}

@end

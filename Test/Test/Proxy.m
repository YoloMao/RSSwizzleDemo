//
//  Proxy.m
//  Test
//
//  Created by YoloMao on 2021/5/14.
//

#import "Proxy.h"
#import <objc/runtime.h>

@implementation Proxy

//动态添加了sayHello
void sayHelloMethod(id obj, SEL _cmd) {
    NSLog(@"Proxy sayHello");
}

////本身实现了sayHello
//- (void)sayHello {
//    NSLog(@"Proxy sayHello");
//}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(sayHello)) {
        class_addMethod([self class], sel, (IMP)sayHelloMethod, "v@:");
        return YES;
    }
    return NO;
}

//如果本身实现或动态添加了sayHello，不会进入forwardingTargetForSelector
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(sayHello)) {
        return [[NSClassFromString(@"Student") alloc] init];
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

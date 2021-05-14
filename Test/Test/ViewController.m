//
//  ViewController.m
//  Test
//
//  Created by YoloMao on 2021/5/11.
//

#import "ViewController.h"
#import "MPSwizzler.h"
#import "MPSwizzle.h"
#import "RSSwizzle.h"

#import "Proxy.h"

@interface Person : NSObject

@end

@implementation Person

- (void)sayHello {
    NSLog(@"person say hello");
}

- (void)p_sayHello {
    [self p_sayHello];
    NSLog(@"Person + swizzle say hello");
}

@end

@interface Student : Person

@end

@implementation Student

//- (void)sayHello {
////    [super sayHello];
//    NSLog(@"student say hello");
//}

- (void)s_sayHello {
    [self s_sayHello];
    NSLog(@"Student + swizzle say hello");
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //MPSwizzler、MPSwizzle(JRSwizzle)、RSSwizzle(新增mode RSSwizzleModeOnceInTheInheritanceChain)对比
    [self hookTest];
    
    //proxy中间层设置Delegate情形模拟，注意proxy是否直接或动态实现了selector对应的imp
    //realDelegateFromSelector中，新增对class_getInstanceMethod([proxy class], selector)的判断
    [self proxyDelegateTest];
}

- (void)rsswizzleClass:(Class)cls selector:(SEL)sel key:(const void *)key {
    RSSwizzleInstanceMethod(cls, sel, RSSWReturnType(void), RSSWArguments(), RSSWReplacement({
        RSSWCallOriginal();
        NSLog(@"%@ swizzle say hello", NSStringFromClass([self class]));
    }), RSSwizzleModeOnceInTheInheritanceChain, key);
}

- (void)hookTest {
//    //MPSwizzler
//    [MPSwizzler swizzleSelector:@selector(sayHello) onClass:[Person class] withBlock:^(id obj, SEL sel) {
//        NSLog(@"Person + swizzle say hello");
//    } named:@"sayhello"];
//
//    [MPSwizzler swizzleSelector:@selector(sayHello) onClass:[Student class] withBlock:^(id obj, SEL sel) {
//        NSLog(@"Student + swizzle say hello");
//    } named:@"sayhello"];
//
//    //MPSwizzle
//    [Person mp_swizzleMethod:@selector(sayHello) withMethod:@selector(p_sayHello) error:nil];
//    [Student mp_swizzleMethod:@selector(sayHello) withMethod:@selector(s_sayHello) error:nil];
    
    //RSSwizzle
    static const void *key = &key;
    [self rsswizzleClass:[Student class] selector:@selector(sayHello) key:key];
    [self rsswizzleClass:[Person class] selector:@selector(sayHello) key:key];
    
    Person *p = [Person new];
    [p sayHello];

    NSLog(@"---------------------");

    Student *s = [Student new];
    [s sayHello];

    NSLog(@"---------------------");
}

- (void)proxyDelegateTest {
    Proxy *px = [Proxy alloc];
    id realDelegate = [MPSwizzler realDelegateFromSelector:@selector(sayHello) proxy:px];
    
    static const void *key = &key;
    [self rsswizzleClass:[Person class] selector:@selector(sayHello) key:key];
    [self rsswizzleClass:[realDelegate class] selector:@selector(sayHello) key:key];
    
    [px performSelector:@selector(sayHello)];
}

@end

# RSSwizzleDemo
基于RSSwizzle实现对象继承链中只Hook一次同一方法

在当前继承链中，classToSwizzle调用selector对应imp实现时，保证swizzle实现只调用一次（比如埋点）

特殊情况：如果子类和父类都hook了此函数，且子类调用super，swizzle实现会调用2次（无法避免）

而且，此mode违背了RSSwizzle设计初衷：[origin implementation应该在调用时获取，而不是在swizzling]

要解决以上问题，可用动态子类的方式（参考KVO）来hook（最佳方案）
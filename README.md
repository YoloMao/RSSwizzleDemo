# RSSwizzleDemo
基于 RSSwizzle 实现对象继承链中只 Hook 一次同一方法

在当前继承链中，classToSwizzle 调用 selector 对应 imp 实现时，无论 hook 的先后顺序，保证 swizzle 实现只调用一次（比如埋点）

主要解决：同一继承链中，swizzle 实现出现 n 次的情况

特殊情况：当对父类和子类（重写了父类方法，并调用 super 实现）同时 Hook，swizzle 实现会调用 2 次（无法避免）

而且，此 mode 违背了 RSSwizzle 设计初衷：[origin implementation 应该在调用时获取，而不是在 swizzling]

要解决以上问题，可用动态子类的方式（参考 KVO）来 hook（最佳方案）
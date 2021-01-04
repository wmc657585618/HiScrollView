# HiScrollView
解决 scroll 嵌套 scroll 滑动冲突。<br/>
在最底层的 scroll 添加滑动手势, 最底层的 scroll 控制相应的 scroll 来滑动。<br/>
scroll 的 scrollenable = false. 不能滑动。<br/>
兼容了 mjrefresh. 可以正常使用刷新。<br/>

properties:
```
@property (nonatomic, assign) BOOL hi_scrollEnabled; // 会禁用原来的scroll, scrollEnabled = false.

@property (nonatomic, assign) HiBouncesInsets bouncesInsets; // default is false.

@property (nonatomic, assign) NSInteger topProperty; // top 响应优先级. default is 0.
@property (nonatomic, assign) NSInteger bottomProperty;
@property (nonatomic, assign) NSInteger leftProperty;
@property (nonatomic, assign) NSInteger rightProperty;
@property (nonatomic, assign) BOOL hi_refresh;// 支持刷新 default is NO.
```

API:
```
/// 只能设置一次
- (void)hi_scrollWithScrollDirection:(HiScrollViewDirection)direction;
```

使用：<br/>
```hi_scrollEnabled``` 设置为 true.<br/>
```bouncesInsets``` 设置弹簧的方向,不设置没有刷新。<br/>
```topProperty,bottomProperty,leftProperty,rightProperty``` 各个方向上的响应的优先级。默认 0, 值越大, 优先级越高。<br/>
```hi_refresh``` 开启刷新, 默认 false.<br/>

在最底层的 scroll 调用 ```- hi_scrollWithScrollDirection: ```

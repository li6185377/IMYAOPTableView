# IMYAOPTableView

无业务入侵，无逻辑入侵，业务端察觉不到 UITableView/UICollectionView 的 AOP框架

按道理最低应该是支持 iOS 5.0的，但是已经没有iOS7之前的机子测试了。 所以不敢保证没问题。

这个框架已经在 美柚 稳定 2016 年就开始使用，美柚总用户突破1亿，日活接近千万，代码的稳定性是可以放心的。有需求或者bug可以提issues，我会尽快回复。

![](http://sc.seeyouyima.com/shopGuide/data/59647e039f684_1920_576.png?imageView2/2/w/800/h/600)

## 要求

* iOS 7+ 
* ARC only

## 集成

If you are using CocoaPods, then, just add this line to your PodFile<br>

```objective-c
pod 'IMYAOPTableView'
```

## 用法

```
look ./AOPTableViewDemo
```

《如何优雅的插入广告》
====================================

当应用发展到一定阶段，一般都会在feeds流中插入广告，来进行广告的变现，这是每个应用都要进行的过程。 比如微信朋友圈，微博，QQ空间。。。 不列举了，一般有feeds流的都会有广告。

![](https://raw.githubusercontent.com/MeetYouDevs/IMYAOPTableView/master/screenshot/demo1.jpg)

当你的应用也需要在原有的业务上插入广告，你会怎么做？ 可能你会直接叫接口把广告跟业务数据合并下，就下发给你。然后你在业务层去各种判断。 

![](https://raw.githubusercontent.com/MeetYouDevs/IMYAOPTableView/master/screenshot/demo2.jpg)

曾经这样做的程序猿应该很多，累吗？ 这样子的插入，需要去改各种代码，还可能在一个微小的角落 可能直接调用了  `- (nullable __kindof UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;` ，然后返回的类型不对，应用直接Crash了

### 出栏

现在这个框架就是出来解决这种情况的！！该框架前无古人开源（可能我没搜到），个人觉得觉得没有比这套更好的解决方案了。

要解决的目标：

1. 旧代码少改动，或者不改动。
2. 业务跟广告模块分离
3. 广告模块可以获取真实数据源。
4. 上手简单


![](https://raw.githubusercontent.com/MeetYouDevs/IMYAOPTableView/master/screenshot/demo3.jpg)

### 用法：

我先下载了 [YYKit](https://github.com/ibireme/YYKit)，YYKit作者对代码的极致追求也是我喜欢的。主要原因是因为它里面有Feeds(Twitter,微博)的demo。就像我们以前的业务代码，够复杂，逻辑够多。

### 开始

我对demo的具体代码是不了解的，但是有了IMYAOPTableView，我已经可以不需要懂内部的实现，就可以对它进行广告的插入。 

先找到了初始化 Twitter,微博 的ViewController地方，并且获取TableView的AopUtils。只有3行代码。  哦，还有一个声明。


```objective-c

	///只是声明，防止提前释放
	@property (nonatomic, strong) IMYAOPDemo* aopDemo;
	
	///插入3行代码的地方
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        
        ///begin 插入3行代码
        self.aopDemo = [IMYAOPDemo new];
        UITableView* feedsTableView = [ctrl valueForKey:@"tableView"];
        self.aopDemo.aopUtils = feedsTableView.aop_utils;
        ///end
        
        ctrl.title = _titles[indexPath.row];
        self.title = @" ";
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

```

这个时候需要新建一个，维护广告逻辑的类，简单的建立了个`IMYAOPDemo`文件，核心代码就是设置数据回调，跟选择插入的位置。


```objective-c

- (void)injectTableView {
    [self.aopUtils.tableView registerClass:[UITableViewCell class]  forCellReuseIdentifier:@"AD"];

    ///广告回调，跟TableView的Delegate，DataSource 一样。
    self.aopUtils.delegate = self;
    self.aopUtils.dataSource = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self insertRows];
    });
}
///简单的rows插入
- (void)insertRows {
    NSMutableArray<IMYAOPTableViewInsertBody*>* insertBodys = [NSMutableArray array];
    ///随机生成了5个要插入的位置
    for (int i = 0 ; i< 5; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arc4random()%10 inSection:0];
        [insertBodys addObject:[IMYAOPTableViewInsertBody insertBodyWithIndexPath:indexPath]];
    }
    ///清空 旧数据
    [self.aopUtils insertWithSections:nil];
    [self.aopUtils insertWithIndexPaths:nil];
    
    ///插入 新数据, 同一个 row 会按数组的顺序 row 进行 递增
    [self.aopUtils insertWithIndexPaths:insertBodys];

    ///调用tableView的reloadData，进行页面刷新
    [self.aopUtils.tableView reloadData];
}

```

广告的回调，其实看代码，他们也是继承了TableView Delegate，跟DataSource，保持跟TableView回调的一致性，方便把旧的广告代码迁移过来。

```objective-c

	@protocol IMYAOPTableViewDelegate <UITableViewDelegate>;
	@protocol IMYAOPTableViewDataSource <UITableViewDataSource>
```

接下来就是要实现TableView的广告回调了， 其实下面两个回调是不会调用的，就是返回数据源数量的回调，因为这个是由业务模块决定的。但是没实现xcode会有警告，所以也可以顺手写上。

```objective-c

	- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; 
	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

```

```objective-c

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AD"];
    if(cell.contentView.subviews.count == 0) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat imageHeight = 162 * (screenWidth/320.0f);
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, imageHeight)];
        imageView.image = [UIImage imageNamed:@"aop_ad_image.jpeg"];
        imageView.layer.borderColor = [UIColor blackColor].CGColor;
        imageView.layer.borderWidth = 1;
        [cell.contentView addSubview:imageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 200, 50)];
        label.text = @"不要脸的广告!";
        [cell.contentView addSubview:label];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"插入的cell要显示啦");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"被点击了> <" message:[NSString stringWithFormat:@"我的位置: %@",indexPath] delegate:nil cancelButtonTitle:@"哦~滚" otherButtonTitles:nil];
    [alertView show];
}
	
```


效果图 （GIF , 如不播放，可点击到新页面试试）:  

![](https://raw.githubusercontent.com/MeetYouDevs/IMYAOPTableView/master/screenshot/demo0.gif)  

#PagePhotos
之前使用过一个叫做
AutoSlideScrollView的控件,但是时间长了会导致很卡顿,
总结了几个框架的,重写了一下,不会再出现卡顿了.
![程序界面](https://raw.githubusercontent.com/zhaozihui/PagePhotos/master/IMG_1211.PNG)

使用方法
```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PagePhotosView *pagePhotosView = [[PagePhotosView alloc] initWithFrame: CGRectMake(0, 0, 320, 260) withDataSource: self animationDuration:3];
    [self.view addSubview:pagePhotosView];

}




// 有多少页
//
- (int)numberOfPages
{
    return 5;
}

// 每页的图片
//
- (UIButton *)buttonAtIndex:(int)index
{
    NSString *imageName = [NSString stringWithFormat:@"1933_%d.jpg", index + 1];
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickAtIndex:(int)index {
    NSLog(@"index:%d",index);
}

```


#联系作者:zhaozihui@gmail.com
//
//  ViewController.m
//  SecondWatch
//
//  Created by nd on 16/7/25.
//  Copyright © 2016年 com.nd. All rights reserved.
//

#import "ViewController.h"


#define kW self.view.frame.size.width
#define kH self.view.frame.size.hieght
int count=0;


@interface ViewController ()

{
    NSTimer *_timer;
    NSInteger  *_seconds;

}
//显示时间的label
@property (nonatomic,strong) UILabel *mainLabel;

//右上角的计次时间
@property (nonatomic,strong) UILabel *conLabel;

//开始、暂停按钮
@property (nonatomic,strong) UIButton *startButton;

//计次按钮
@property (nonatomic,strong) UIButton *jcButton;

//显示计次信息的tableView
@property (nonatomic,strong) UITableView *jcTableView;

//tableView 中的cell
@property (nonatomic,strong) UITableViewCell *cell;

//保存计次数据的数组
@property (nonatomic,strong) NSMutableArray *jcArray;

@end


@implementation ViewController

//初始化jcArray
-(NSMutableArray *) jcArray
{

    if(_jcArray == nil)
    {
        _jcArray = [NSMutableArray array];
    
    }

    return _jcArray;

}


//入口
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self _loadViews];
}


//初始化视图
-(void) _loadViews
{
    self.title=@"秒表";
    
    //右上角  显示时间内容
    UILabel *conLabel = [[UILabel alloc] initWithFrame:CGRectMake(237, 15, 80, 35)];
    conLabel.text = @"00:00.00";
    conLabel.font = [UIFont fontWithName:@"ArialMT" size:18];
    conLabel.textAlignment = NSTextAlignmentCenter;
    self.conLabel = conLabel;
  //  conLabel.backgroundColor=[UIColor colorWithRed:0.57 green:0.80 blue:0.93 alpha:1.00];
    [self.view addSubview:conLabel];
    
    //秒表面板
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,60,kW,100)];
    mainLabel.text = @"00:00.00";
    mainLabel.font = [UIFont fontWithName:@"ArialMT" size:60];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    //避免初始化后对象改变
    self.mainLabel = mainLabel;
 //   mainLabel.backgroundColor=[UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1.00];
    [self.view addSubview:mainLabel];

    //按钮的背景视图
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0,160,kW,100)];
    bView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    [self.view addSubview:bView];
    
    
    //开始/停止按钮
    
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake((kW-160)/3,10,80,80)];
    startButton.backgroundColor = [UIColor whiteColor];
    startButton.layer.cornerRadius = 40;
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton setTitle:@"停止" forState:UIControlStateSelected];
    [startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    startButton.tag = 1;
    [startButton addTarget:self action:@selector(StartAndPause:) forControlEvents:UIControlEventTouchUpInside];
    self.startButton = startButton;
    [bView addSubview:startButton];
 
    //计次按钮
    
    UIButton *jcButton = [[UIButton alloc] initWithFrame:CGRectMake((kW-160)/3*2+80,10,80,80)];
    jcButton.backgroundColor = [UIColor whiteColor];
    jcButton.layer.cornerRadius = 40;
    [jcButton setTitle:@"计次" forState:UIControlStateNormal];
    
    [jcButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    jcButton.tag = 2;
    [jcButton addTarget:self action:@selector(CountNum) forControlEvents:UIControlEventTouchUpInside];
    self.jcButton = jcButton;
    [bView addSubview:jcButton];
    
    
    //显示计次信息的tableView
    UITableView * jcTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,260,kW,220) style:UITableViewStylePlain];
   // jcTableView.backgroundColor = [UIColor yellowColor];
    jcTableView.rowHeight = 40;
    jcTableView.delegate = self;
    jcTableView.dataSource = self;
    self.jcTableView = jcTableView;
    
    [self.view addSubview:jcTableView];

}

//响应开始和暂停按钮事件
-(void)StartAndPause:(UIButton *) sButton {

    sButton.selected = !sButton.selected;
    
    if(_timer == nil){
      //0.01秒更新一次
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        NSLog(@"开始计时...");
    
    }
    else{
        [_timer invalidate]; //让定时器失效
        
        count = 0;
        _timer = nil;
        _mainLabel.text = @"00:00.00";
        _conLabel.text = @"00:00.00";
        
        _seconds=NULL;
        self.cell = nil;
        self.jcArray = nil;
        [self.jcTableView reloadData];
    }
}


//计次
-(void)CountNum{

    count++;
    
    _conLabel.text = _mainLabel.text;
    NSLog(@"第%d次，%@",count,_conLabel.text);
    [self.jcArray addObject:[NSString stringWithFormat:@"第%d次\t%@",count,_mainLabel.text]];
    
    
    [self.jcTableView reloadData];
//    _conLabel.text = @"00:00.00";
}


-(void)runAction{
    
    _seconds++;
    
    //动态改变显示的时间
    NSString * startTime = [NSString stringWithFormat:@"%02li:%02li.%02li",(long)_seconds/60/100%60,(long)_seconds/100%60,(long)_seconds%100];
    _mainLabel.text = startTime;


}

//实现UITabViewDataSource 的方法
- (NSInteger)tableView:(UITableView *)jcTableView numberOfRowsInSection:(NSInteger)section {
    return self.jcArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)jcTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identity = @"JRTable";
    UITableViewCell *cell =[jcTableView dequeueReusableCellWithIdentifier:identity];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.textLabel.text = self.jcArray[indexPath.row];
    
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    
    self.cell=cell;
    return self.cell;
}


//实现代理的方法
//-(CGFloat)tableView:(UITableView *)jcTableView heightForHeaderInSection:(NSInteger)section{
//    if(section==0){
//        return 50;
//    }
//    return 40;
//}
//
//#pragma mark 设置每行高度（每行高度可以不一样）
//-(CGFloat)tableView:(UITableView *)jcTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 45;
//}
//
//#pragma mark 设置尾部说明内容高度
//-(CGFloat)tableView:(UITableView *)jcTableView heightForFooterInSection:(NSInteger)section{
//    return 40;
//}
//


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

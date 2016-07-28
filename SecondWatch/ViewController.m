//
//  ViewController.m
//  SecondWatch
//
//  Created by nd on 16/7/25.
//  Copyright © 2016年 com.nd. All rights reserved.
//

#import "ViewController.h"


#define KScreenWidth self.view.frame.size.width
#define kScreenHieght self.view.frame.size.hieght

//记录是否按下开始按钮的flag
BOOL isStartButtonPressed = NO;


@interface ViewController () {
    NSTimer *_timer;
    NSInteger  *_secondsForMainLabel;   //for mainLabel
    NSInteger *_secondsForConLabel;   //for conLabel

}
//显示时间的label
@property (nonatomic, strong) UILabel *mainLabel;

//右上角的计次时间
@property (nonatomic,strong) UILabel *cornerLabel;

//开始、暂停按钮
@property (nonatomic,strong) UIButton *startAndPauseButton;

//计次、复位按钮
@property (nonatomic,strong) UIButton *countAndResetButton;

//显示计次信息的tableView
@property (nonatomic,strong) UITableView *tableView;

//tableView 中的cell
@property (nonatomic,strong) UITableViewCell *cell;

//保存计次数据的数组
@property (nonatomic,strong) NSMutableArray *timeArray;

@end


@implementation ViewController

//初始化timeArray
- (NSMutableArray *)timeArray {
    
    if(_timeArray == nil)
    {
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}


//入口
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self _loadViews];
}


//初始化视图
- (void) _loadViews {
    
    self.title=@"秒表";
    //右上角  显示时间内容
    UILabel *cornerLabel = [[UILabel alloc] initWithFrame:CGRectMake(237, 15, 80, 35)];
    cornerLabel.text = @"00:00.00";
    cornerLabel.font = [UIFont fontWithName:@"ArialMT" size:18];
    cornerLabel.textAlignment = NSTextAlignmentCenter;
    self.cornerLabel = cornerLabel;
    [self.view addSubview:cornerLabel];
    
    //秒表面板
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, KScreenWidth, 100)];
    mainLabel.text = @"00:00.00";
    mainLabel.font = [UIFont fontWithName:@"ArialMT" size:60];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    //？？？？
    self.mainLabel = mainLabel;
    [self.view addSubview:mainLabel];
    
    //按钮的背景视图
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, KScreenWidth, 100)];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    [self.view addSubview:backgroundView];
    
    //开始/停止按钮
    UIButton *startAndPauseButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160) / 3, 10, 80, 80)];
    startAndPauseButton.backgroundColor = [UIColor whiteColor];
    startAndPauseButton.layer.cornerRadius = 40;
    [startAndPauseButton setTitle:@"开始" forState:UIControlStateNormal];
    [startAndPauseButton setTitle:@"停止" forState:UIControlStateSelected];
    [startAndPauseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [startAndPauseButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [startAndPauseButton addTarget:self action:@selector(startAndPause:) forControlEvents:UIControlEventTouchUpInside];
    self.startAndPauseButton = startAndPauseButton;
    [backgroundView addSubview:startAndPauseButton];
 
    //计次按钮
    UIButton *countAndResetButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160) / 3 * 2 + 80, 10, 80, 80)];
    countAndResetButton.backgroundColor = [UIColor whiteColor];
    countAndResetButton.layer.cornerRadius = 40;
    NSString *title = @"计次";
    [countAndResetButton setTitle:title forState:UIControlStateNormal];
    [countAndResetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [countAndResetButton addTarget:self action:@selector(countAndReset) forControlEvents:UIControlEventTouchUpInside];
    self.countAndResetButton = countAndResetButton;
    [backgroundView addSubview:countAndResetButton];
    
    
    //显示计次信息的tableView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 260, KScreenWidth, 220) style:UITableViewStylePlain];
    tableView.rowHeight = 36.6;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];

}

//响应开始和暂停按钮事件
- (void)startAndPause:(UIButton *)startButton {
    
    startButton.selected = !startButton.selected;
    if(!isStartButtonPressed) {
      //0.01秒更新一次
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_countAndResetButton setTitle:@"计次" forState:UIControlStateNormal];
        NSLog(@"开始计时...");
    } else {
        NSLog(@"暂停...");
        [_timer invalidate]; //让定时器失效
        [_countAndResetButton setTitle:@"复位" forState:UIControlStateNormal];
    }
    isStartButtonPressed = !isStartButtonPressed;
}


//计次和复位
- (void)countAndReset {
    
    //初始情况下不能计次
    if(_timer == nil) {
        return;
    }
    //计次
    if(isStartButtonPressed) {
        _secondsForConLabel=0;
        [self.timeArray addObject:_cornerLabel.text];
         NSLog(@"第%d次，%@", _timeArray.count, _cornerLabel.text);
        [self.tableView reloadData];
    } else {
        //复位
        _timer=nil;
        _mainLabel.text=@"00:00.00";
        _cornerLabel.text=@"00:00.00";
        _secondsForMainLabel = 0 ;
        _secondsForConLabel = 0;
        [self.countAndResetButton setTitle:@"计次" forState:UIControlStateNormal];
        self.cell=nil;
        self.timeArray=nil;
        [self.tableView reloadData];
        NSLog(@"复位.....");
    }
    
}


- (void)updateTime {
    
    _secondsForMainLabel++;
    _secondsForConLabel++;
    //动态改变显示的时间
    NSString * mainLabelTime = [NSString stringWithFormat:@"%02li:%02li.%02li", (long)_secondsForMainLabel / 60 / 100 % 60, (long)_secondsForMainLabel / 100 % 60, (long)_secondsForMainLabel % 100];
        _mainLabel.text = mainLabelTime;
    NSString *cornerLabelTime =[NSString stringWithFormat:@"%02li:%02li.%02li", (long)_secondsForConLabel / 60 / 100 % 60, (long)_secondsForConLabel / 100 % 60, (long)_secondsForConLabel % 100];
      _cornerLabel.text = cornerLabelTime;
}

//实现UITabViewDataSource 的方法
- (NSInteger)tableView:(UITableView *)jcTableView numberOfRowsInSection:(NSInteger)section {
    return self.timeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)jcTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identity = @"JRTable";
    UITableViewCell *cell =[jcTableView dequeueReusableCellWithIdentifier:identity];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    NSInteger originRow = [indexPath row];
    NSInteger reverseRow = _timeArray.count - 1 - originRow;
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"第%d次\t\t%@", reverseRow + 1, [self.timeArray objectAtIndex:reverseRow] ];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    self.cell = cell;
    return self.cell;
}
    
@end

//
//  ViewController.m
//  YL_CarTypeView
//
//  Created by AS150701001 on 16/6/3.
//  Copyright © 2016年 lele. All rights reserved.
//

#define  kScreenWidth [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight [UIScreen mainScreen].bounds.size.height
#define  kDuration   0.5
#define  kCellHeight 44.0
#define  kCellY    100

#define kTabViewWidth  (kScreenWidth * 0.6)
#import "ViewController.h"
#import "MainCar.h"
#import "subName.h"
#import "Colours.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _selectMainRow; // 记录主表选择的行号
}
@property(nonatomic,weak) UITableView* mainTabView;
@property(nonatomic,weak) UITableView* subTabView;
@property(nonatomic,strong) NSArray* carList;
@property(nonatomic,weak) UIButton* carTypeBtn;
@property(nonatomic,copy) NSString* selectCarType; // 记录选择的车型
@property(nonatomic,copy) NSString* selectCarIcon; // 记录选择车型的图标
@property(nonatomic,weak) UIButton* cover; // 遮盖
@property(nonatomic,weak) UILabel* titleLabel; // 遮盖

@end

@implementation ViewController
-(NSArray*)carList
{
    if (_carList==nil) {
        _carList=[MainCar mainCars];
    }
    return _carList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}

-(void)buildUI
{
    // titleLabel
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    titleLabel.text=@"车型品牌选择器";
    titleLabel.backgroundColor=[UIColor skyBlueColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    // 创建车辆认证按钮
    UILabel* car= [self labelWithTitle:@"  车型品牌"];
    car.backgroundColor=[UIColor groupTableViewBackgroundColor];
    car.frame=CGRectMake(0, kCellY, kScreenWidth, kCellHeight);
    
    //添加右端图片
    CGFloat imageW=kCellHeight;
    CGFloat imageX=kScreenWidth-imageW-5;
    UIImageView* arrow_right=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_rightImage"]];
    arrow_right.center=CGPointMake(kScreenWidth - (kScreenWidth * 0.06), car.center.y);
    arrow_right.image=[UIImage imageNamed:@"arrow_rightImage"];
    [self.view addSubview:arrow_right];
    
    // 添加描述 Label
    CGFloat labelX=0;
    CGFloat labelY=kCellY;
    CGFloat labelW=imageX;
    CGFloat labelH=kCellHeight;
    
    UIButton* carTypeBtn=[[UIButton alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    carTypeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [carTypeBtn setTitle:@"请选择车型" forState:UIControlStateNormal];
    [carTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    carTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:carTypeBtn];
    self.carTypeBtn=carTypeBtn;
    [carTypeBtn addTarget:self action:@selector(selectCarTypeClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIEdgeInsets insert=UIEdgeInsetsMake(0, 0, 0, 5);
    [carTypeBtn setImageEdgeInsets:insert];
    carTypeBtn.adjustsImageWhenHighlighted=NO;
    
    // 主表头
    UIView* mainView=[self titleView];
    // 从表头
    UIView* subView=[self titleView];
    
    for (UIView* view in subView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            self.titleLabel=(UILabel*)view;
        }
    }
    UIButton* closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, kCellHeight -1, kCellHeight  - 1)];
    [closeBtn setImage:[UIImage imageNamed:@"btn_navigation_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UIView* lineView2=[[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight -1,kTabViewWidth, 1)];
    lineView2.backgroundColor=[UIColor lightGrayColor];
    [subView addSubview:closeBtn];
    
    // 添加遮盖
    UIButton* cover=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    cover.alpha=0.0;
    cover.backgroundColor=[UIColor blackColor];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    self.cover=cover;
    
    self.mainTabView=[self tabView];
    self.mainTabView.tableHeaderView=mainView;
    
    self.subTabView=[self tabView];
    self.subTabView.tableHeaderView=subView;
    
}

-(UILabel*) labelWithTitle:(NSString*)title
{
    UILabel* label= [[UILabel alloc] init];
    label.text=title;
    [self.view addSubview:label];
    return label;
}

#pragma mark -- 设置表头
-(UIView*) titleView
{
    UIView* titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kCellHeight)];
    titleView.backgroundColor=[UIColor whiteColor];
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTabViewWidth, kCellHeight - 1)];
    label.text=@"请选择";
    label.textAlignment=NSTextAlignmentCenter;
    UIView* lineView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame),kTabViewWidth, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [titleView addSubview:label];
    [titleView addSubview:lineView];
    return titleView;
}

-(UITableView*)tabView
{
    UITableView* TabView=[[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth * 0.6, kScreenHeight)];
    TabView.dataSource=self;
    TabView.delegate=self;
    [self.view addSubview:TabView];
    return TabView;
}

-(void)close
{
    [self hidMainTabView:self.subTabView];
}

#pragma mark -- UITableViewDataSource 与 delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTabView) {
        return    self.carList.count;
    }else{
        MainCar* car=self.carList[_selectMainRow];
        return car.subCars.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell=nil;
    
    if (tableView == self.mainTabView) {
        static NSString* identifire=@"identifire";
        
        cell=[tableView dequeueReusableCellWithIdentifier:identifire];
        
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
        }
        MainCar* model=self.carList[indexPath.row];
        
        if (model.subCars.count > 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }
        cell.textLabel.text=model.name;
        cell.imageView.image=[UIImage imageNamed:model.icon];
        
    }else {
        static NSString* identifire=@"subidentifire";
        
        cell=[tableView dequeueReusableCellWithIdentifier:identifire];
        
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
        }
        MainCar* model=self.carList[_selectMainRow];
        
        cell.textLabel.text=model.subCars[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mainTabView)
    {
        _selectMainRow=indexPath.row;
        MainCar* car=self.carList[indexPath.row];
        if (car.subCars.count > 0) {
            [self showMainTabView:self.subTabView];
            self.titleLabel.text=car.name;
            [self.subTabView  reloadData];
        }else{
            [self hidMainTabView:self.mainTabView];
            self.selectCarIcon=car.icon;
            self.selectCarType=car.name;
        }
        
    }else{
        [self coverClick];
        MainCar* car=self.carList[_selectMainRow];
        self.selectCarIcon=car.icon;
        self.selectCarType=car.subCars[indexPath.row];
    }
}

-(void)selectCarTypeClick
{
    [self showMainTabView:self.mainTabView];
    
}

#pragma mark -- 遮盖被点击
-(void)coverClick
{
    [self hidMainTabView:self.mainTabView];
    [self hidMainTabView:self.subTabView];
}


#pragma mark -- tabView 的展示与隐藏
-(void) showMainTabView:(UITableView*)tabView
{
    [UIView animateWithDuration:kDuration animations:^{
        CGRect f=tabView.frame;
        f.origin.x=kScreenWidth * 0.4;
        tabView.frame=f;
        self.cover.alpha=0.5;
    }];
}

-(void) hidMainTabView:(UITableView*)tabView
{
    [UIView animateWithDuration:kDuration animations:^{
        CGRect f=tabView.frame;
        f.origin.x=kScreenWidth ;
        tabView.frame=f;
        if (tabView == self.mainTabView) {
            self.cover.alpha=0.0;
        }
    }];
}



-(void)setSelectCarIcon:(NSString *)selectCarIcon
{
    _selectCarIcon=selectCarIcon;
    [self.carTypeBtn  setImage:[UIImage imageNamed:selectCarIcon] forState:UIControlStateNormal];
}

-(void)setSelectCarType:(NSString *)selectCarType
{
    _selectCarType=selectCarType;
    [self.carTypeBtn setTitle:selectCarType forState:UIControlStateNormal];
}


#pragma mark -- 隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end

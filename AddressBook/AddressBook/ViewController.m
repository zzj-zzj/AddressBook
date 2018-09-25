//
//  ViewController.m
//  AddressBook
//
//  Created by 许小六 on 2018/9/6.
//  Copyright © 2018年 许小六. All rights reserved.
//

#import "ViewController.h"
#import "ResultViewController.h"
#import "SortingSolution.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSArray *dataArray;
//@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) ResultViewController *resultVC;
@property (nonatomic, strong) NSMutableDictionary *mDic;
@property (nonatomic, strong) NSArray *indexArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";

    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self returnFirstwordWithName:@"111name"];
    [self returnFirstwordWithName:@"$$$"];
    [self returnFirstwordWithName:@"name"];
    [self returnFirstwordWithName:@"nnme"];
    [self returnFirstwordWithName:@"?name"];
    [self returnFirstwordWithName:@"中文"];
    [self returnFirstwordWithName:@"名字"];
    [self returnFirstwordWithName:@"名22字"];
    [self returnFirstwordWithName:@"avc"];
    [self returnFirstwordWithName:@"123%"];
    
    NSString *s1 = @"陈亦群";
    NSString *s2 = @"陈入库";
    NSString *s3 = @"陈佩仪";
    NSLog(@"one=%ld, %ld, %ld", (long)[s1 localizedCompare:s2], [s2 localizedCompare:s3], [s3 localizedCompare:s1]);
    
    self.dataArray = @[@"名22字", @"111name", @"陈开明", @"陈佩玉", @"$$$", @"中文", @"avc", @"?name", @"陈总播", @"陈如库", @"沈家湾", @"厦门", @"曾小贤", @"zenxiao", @"陈亦群"];
    self.mDic = [SortingSolution sortObjectsWith:self.dataArray];
    self.indexArray = [self.mDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 localizedCompare:obj2];
    }];
    [self.tableView reloadData];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ----- Private Methods

- (NSString *)returnFirstwordWithName:(NSString *)name {
    NSMutableString *ms = [[NSMutableString alloc] initWithString:name];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        NSLog(@"Pingying: %@", ms);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        NSLog(@"Pingying: %@", ms);
    }
    NSString *firstString = [ms substringToIndex:1];
    NSLog(@"%@的首字母是%@", name, firstString);
    return firstString;
}


#pragma mark ----- UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
    NSLog(@"SearchController即将present");
    NSLog(@"此时showsCancelButton == NO, 只有YES时才能有效修改按钮样式 >>> %d", self.searchController.searchBar.showsCancelButton);
    // kvc设置取消按钮样式
    self.searchController.searchBar.showsCancelButton = YES;
    UIButton *canceLBtn = [_searchController.searchBar valueForKey:@"cancelButton"];
    [canceLBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceLBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"SearchController已经present完成");
    NSLog(@"self.searchController.searchBar.showsCancelButton2 === %d", self.searchController.searchBar.showsCancelButton);
}


- (void)willDismissSearchController:(UISearchController *)searchController {
    NSLog(@"SearchController即将Dismiss");
    NSLog(@"self.searchController.searchBar.showsCancelButton3 === %d", self.searchController.searchBar.showsCancelButton);
}


- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"SearchController已经Dismiss完成");
    NSLog(@"self.searchController.searchBar.showsCancelButton4 === %d", self.searchController.searchBar.showsCancelButton);
}


#pragma mark ----- UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    [self.resultArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchController.searchBar.text];
    self.resultVC.resultArray = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:predicate]];
    [self.resultVC.resultTableView reloadData];
}


#pragma mark ----- UITableViewDelegate & UITableViewDataSource

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
    return [self.mDic[self.indexArray[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.indexArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuse" forIndexPath:indexPath];
//    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.text = self.mDic[self.indexArray[indexPath.section]][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark ----- Setter & Getter

- (NSArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [NSArray array];
    }
    return _indexArray;
}

- (NSMutableDictionary *)mDic {
    if (!_mDic) {
        _mDic = [NSMutableDictionary dictionary];
    }
    return _mDic;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"aa", @"a1", @"v", @"sa", @"a1", @"vc", @"cc", @"cs", @"1"];
    }
    return _dataArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellReuse"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        // 针对_searchController来说self是父视图 可能被苹果官方修复
        self.definesPresentationContext = YES;
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);

        // 修改searchBar的背景颜色
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//        _searchController.searchBar.barTintColor = [UIColor redColor];
//        UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
//        barImageView.layer.borderColor = [UIColor clearColor].CGColor;
//        barImageView.layer.borderWidth = 1;
        
        _searchController.searchBar.tintColor = [UIColor blackColor];
        _searchController.searchBar.placeholder = @"搜索";
    }
    return _searchController;
}


- (ResultViewController *)resultVC {
    if (!_resultVC) {
        _resultVC = [[ResultViewController alloc] init];
    }
    return _resultVC;
}


@end

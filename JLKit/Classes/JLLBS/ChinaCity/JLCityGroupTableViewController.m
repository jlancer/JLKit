//
//  JLCityGroupTableViewController.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLCityGroupTableViewController.h"
#import "JLStorage.h"

@interface JLCityGroupTableViewController ()

@property (nonatomic, strong) NSArray *cityGroupArray;

@end

@implementation JLCityGroupTableViewController

- (NSArray *)cityGroupArray {
    
    if (!_cityGroupArray) {
        NSString *plistPath = [JLStorage podBundleResource:@"cityGroups.plist" type:nil class:[self class]];
        NSArray *cityGroupArray = [NSArray arrayWithContentsOfFile:plistPath];
        //所有字典对象转成模型对象
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dic in cityGroupArray) {
            //声明一个空的CityGroup对象
            JLCityGroup *cityGroup = [JLCityGroup new];
            //KVC绑定模型对象属性和字典key的关系
            [cityGroup setValuesForKeysWithDictionary:dic];
            [mutableArray addObject:cityGroup];
        }
        _cityGroupArray = mutableArray;
    }
    return _cityGroupArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(clickBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)clickBackItem {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.cityGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    JLCityGroup *cityGroup = self.cityGroupArray[section];
    return cityGroup.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // Configure the cell...
    JLCityGroup *cityGroup = self.cityGroupArray[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}

//返回section的头部文本
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    JLCityGroup *cityGroup = self.cityGroupArray[section];
    return cityGroup.title;
}

//返回tableViewIndex数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    //方式一
    //    NSMutableArray *titleMutablArray = [NSMutableArray array];
    //    for (TRCityGroup *cityGroup in self.cityGroupArray) {
    //        [titleMutablArray addObject:cityGroup.title];
    //    }
    //    return [titleMutablArray copy];
    //方式二
    return [self.cityGroupArray valueForKeyPath:@"title"];
}

//选中那一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLCityGroup *cityGroup = self.cityGroupArray[indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
    //发送通知，包含参数
    //回调Block
    if (_block != nil) {
        
        _block(cityName);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

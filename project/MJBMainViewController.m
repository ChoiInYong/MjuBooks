//
//  MJBMainViewController.m
//  project
//
//  Created by Kyuseon on 2015. 5. 19..
//  Copyright (c) 2015년 Kyuseon. All rights reserved.
//

#import "MJBMainViewController.h"

@interface MJBMainViewController ()

@end

@implementation MJBMainViewController
@synthesize productTV;

- (void)viewDidLoad {
    productTV=[[UITableView alloc]init];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Log Out" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    [super viewDidLoad];    
    // Do any additional setup after loading the view from its nib.
       
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Formal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewStylePlain reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text=[NSString stringWithFormat:@"Index row of this cell: %d",indexPath.row];
    return cell;
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

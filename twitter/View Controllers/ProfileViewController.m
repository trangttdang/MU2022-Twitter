//
//  ProfileViewController.m
//  twitter
//
//  Created by Trang Dang on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "Tweet.h"
#import "TweetCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *userTimelineTableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userTimelineTableView.delegate = self;
    self.userTimelineTableView.dataSource = self;
    
    
    // Do any additional setup after loading the view.
//        [[APIManager shared] getUserTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
//            if (tweets) {
//                NSLog(@"😎😎😎 Successfully loaded home timeline");
//                for (Tweet *tweet in tweets) {
//                    NSString *text = tweet.text;
//                    NSLog(@"%@",text);
//                }
//                self.arrayOfTweets = tweets;
//                NSLog(@"%@",self.arrayOfTweets);
//            } else {
//                NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
//            }
//
//            [self.homeTimelineTableView reloadData];
//        }];
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

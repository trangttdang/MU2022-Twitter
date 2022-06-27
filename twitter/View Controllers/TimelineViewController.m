//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DetailTweetViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, TweetCellDelegate,DetailTweetViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeTimelineTableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;

@end

@implementation TimelineViewController
- (IBAction)didTapCompose:(id)sender {
    ComposeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    viewController.delegate = self;
    [self.navigationController pushViewController: viewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMoreData:20];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:(UIControlEventValueChanged)];
    [self.homeTimelineTableView insertSubview:refreshControl atIndex:0];
    
    self.homeTimelineTableView.dataSource = self;
    self.homeTimelineTableView.delegate = self;
    

    
    // Get timeline
//    [[APIManager shared] getHomeTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
//        if (tweets) {
//            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (Tweet *tweet in tweets) {
//                NSString *text = tweet.text;
//                NSLog(@"%@",text);
//            }
//            self.arrayOfTweets = tweets;
//            NSLog(@"%@",self.arrayOfTweets);
//        } else {
//            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
//        }
//
//        [self.homeTimelineTableView reloadData];
//    }];
    
//    NSNumber *countLoaded = [NSNumber numberWithInteger:20];
    
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

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

//returne rows are in each section of the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}


//Returne a preconfigured cell that will be used to render the row in the table specified by the indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.tweet = tweet;
    
    cell.profileImageView.image = [UIImage imageWithData:urlData];
    cell.profileImageView.layer.cornerRadius = 5;
//
//    [cell.profileImageButton setImage:[UIImage imageWithData:urlData] forState:UIControlStateNormal];
//    cell.profileImageButton.layer.cornerRadius = 5;
    cell.userNameLabel.text = tweet.user.name;
    cell.dateCreatedLabel.text = tweet.createdAtString;
    cell.userScreenNameLabel.text = tweet.user.screenName;
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    cell.tweet.favoriteImageAddress =tweet.favoriteImageAddress;
    cell.tweet.retweetImageAddress = tweet.retweetImageAddress;

    [cell.favoriteButton setImage:[UIImage imageNamed:tweet.favoriteImageAddress] forState:UIControlStateNormal];
    [cell.retweetButton setImage:[UIImage imageNamed:tweet.retweetImageAddress] forState:UIControlStateNormal];
    
    cell.textTextView.text = tweet.text;
    cell.textTextView.editable = NO;
    cell.textTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    
    NSURL *mediaUrlHttps = [NSURL URLWithString:tweet.mediaUrlHttps];
    NSData *mediaData = [NSData dataWithContentsOfURL:mediaUrlHttps];
    if(tweet.mediaUrlHttps){
        cell.mediaImageView.image = [UIImage imageWithData:mediaData];
        cell.mediaImageView.layer.cornerRadius = 5;
    } else{
        cell.mediaImageView.hidden = YES;
    }
    
    cell.tweet.inReplyToStatusIdString = tweet.inReplyToStatusIdString;
    cell.tweet.inReplyToScreenName = tweet.inReplyToScreenName;
//    NSString *replyToScreenName = [NSString stringWithFormat:@"%@", tweet.inReplyToScreenName];
//    if(![replyToScreenName  isEqual: @"<null>"]){
//    cell.inReplyToScreenNameLabel.text = [@"Replying to " stringByAppendingString: [@"@" stringByAppendingString: [NSString stringWithFormat:@"%@", tweet.inReplyToScreenName]]];
//    } else{
//        cell.inReplyToScreenNameLabel.hidden = YES;
//    }
    cell.inReplyToScreenNameLabel.text = [@"Replying to " stringByAppendingString: [@"@" stringByAppendingString: [NSString stringWithFormat:@"%@", cell.tweet.inReplyToScreenName]]];
    
    
//    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [cell.profileImageView setUserInteractionEnabled:YES];

    cell.delegate  = self;
    return cell;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self loadMoreData:20];
    [refreshControl endRefreshing];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.arrayOfTweets count]){
        [self loadMoreData:[self.arrayOfTweets count] + 20];
    }
}
-(void)loadMoreData:(NSInteger)count{
    NSNumber *countLoaded = [NSNumber numberWithInteger:count];
    
    [[APIManager shared] getHomeTimelineWithCompletion:countLoaded completion:^(NSMutableArray *tweets, NSError *error) {
                if (tweets) {
                    NSLog(@"😎😎😎 Successfully loaded home timeline");
                    for (Tweet *tweet in tweets) {
                        NSLog(@"%@",tweet.text);

                    }
                    
                    self.arrayOfTweets = tweets;
                    NSLog(@"%@",self.arrayOfTweets);
                } else {
                    NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
                }
        
                [self.homeTimelineTableView reloadData];
    }];

}
    

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTweetViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailTweetViewController"];
//    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    viewController.tweet = tweet;
//    viewController.tweetCell = tweetCell;
    viewController.delegate = self;
    [self.navigationController pushViewController: viewController animated:YES];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//   UINavigationController *navigationController = [segue destinationViewController];
//   ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
//   composeController.delegate = self;
//}



- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    NSLog(@"%@",tweet.inReplyToStatusIdString);
    NSLog(@"%@",tweet.inReplyToScreenName);
    [self.homeTimelineTableView reloadData];
    
}


- (void)didUnRetweet:(nonnull Tweet *)tweet {
//    [self.arrayOfTweets removeObject:tweet];
    [self.homeTimelineTableView reloadData];
}

- (void)didTapFavorite:(nonnull Tweet *)tweet {
    [self.homeTimelineTableView reloadData];
}
- (void)didTapProfileImage:(Tweet *)tweet{
    ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    viewController.user = tweet.user;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didFavorite:(nonnull Tweet *)tweet {
    [self.homeTimelineTableView reloadData];
}


@end

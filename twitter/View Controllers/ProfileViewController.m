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

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *userTimelineTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *userDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UILabel *statusCountLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userTimelineTableView.delegate = self;
    self.userTimelineTableView.dataSource = self;
    
    NSString *URLString = self.user.profilePicture;
    NSString *URLBackgroundString = self.user.profileBackgroundPicture;
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    NSURL *urlBackground = [NSURL URLWithString:URLBackgroundString];
    NSData *urlDataBackground = [NSData dataWithContentsOfURL:urlBackground];
    
    self.profileImageView.image = [UIImage imageWithData:urlData];
    self.profileBackgroundImageView.image = [UIImage imageWithData:urlDataBackground];
    
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d", self.user.followingCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%d", self.user.followersCount];
    self.userDescriptionTextView.text = self.user.profileDescription;
    self.userDescriptionTextView.editable = NO;
    self.userDescriptionTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.userNameLabel.text = self.user.name;
    self.screenNameLabel.text = self.user.screenName;
    self.statusCountLabel.text = [NSString stringWithFormat:@"%d", self.user.statusCount];
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
//    NSInteger count = 20;
//    NSNumber *countLoaded = [NSNumber numberWithInteger:count];
    [[APIManager shared] getUserTimelineWithCompletion:self.user.screenName completion:^(NSMutableArray *tweets, NSError *error) {
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
        
                [self.userTimelineTableView reloadData];
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.tweet = tweet;
    
    cell.profileImageView.image = [UIImage imageWithData:urlData];
    cell.profileImageView.layer.cornerRadius = 5;
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
    cell.inReplyToScreenNameLabel.text = [@"Replying to " stringByAppendingString: [@"@" stringByAppendingString: [NSString stringWithFormat:@"%@", cell.tweet.inReplyToScreenName]]];
    
    [cell.profileImageView setUserInteractionEnabled:YES];
    cell.delegate = self;
    return cell;

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}


- (void)didTapFavorite:(nonnull Tweet *)tweet {

}

- (void)didTapProfileImage:(nonnull Tweet *)tweet {

}

- (void)didTweet:(nonnull Tweet *)tweet {
    
}

- (void)didUnRetweet:(nonnull Tweet *)tweet {
    
}


@end

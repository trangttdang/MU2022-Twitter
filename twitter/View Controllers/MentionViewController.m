//
//  MentionViewController.m
//  twitter
//
//  Created by Trang Dang on 6/27/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "MentionViewController.h"
#import "APIManager.h"
#import "TweetCell.h"

@interface MentionViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MentionTableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@end

@implementation MentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.MentionTableView.delegate = self;
    self.MentionTableView.dataSource = self;
    // Do any additional setup after loading the view.
    [[APIManager shared] getUserMentionWithCompletion:^(NSMutableArray *tweets, NSError *error) {
                if (tweets) {
                    NSLog(@"😎😎😎 Successfully loaded home timeline");
                    for (Tweet *tweet in tweets) {
                        NSLog(@"%@",tweet.text);
                    }
                    self.arrayOfTweets = tweets;

                } else {
                    NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
                }
        [self.MentionTableView reloadData];

    }];
//    NSInteger i = 20;
//    NSNumber *countLoaded = [NSNumber numberWithInteger:i];
//    [[APIManager shared] getHomeTimelineWithCompletion:countLoaded completion:^(NSMutableArray *tweets, NSError *error) {
//                if (tweets) {
//                    NSLog(@"😎😎😎 Successfully loaded home timeline");
//                    for (Tweet *tweet in tweets) {
//                        NSLog(@"%@",tweet.text);
//
//                    }
//
//                    self.arrayOfTweets = tweets;
//                    NSLog(@"%@",self.arrayOfTweets);
//                } else {
//                    NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
//                }
//
//                [self.MentionTableView reloadData];
//    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
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
//
//    cell.tweet.inReplyToStatusIdString = tweet.inReplyToStatusIdString;
//    cell.tweet.inReplyToScreenName = tweet.inReplyToScreenName;
//    cell.inReplyToScreenNameLabel.text = [@"Replying to " stringByAppendingString: [@"@" stringByAppendingString: [NSString stringWithFormat:@"%@", cell.tweet.inReplyToScreenName]]];
//
    
    if(![tweet.inReplyToStatusIdString isEqual:[NSNull null]]){
    cell.inReplyToScreenNameLabel.text = [@"Replying to " stringByAppendingString: [NSString stringWithFormat:@"%@", tweet.inReplyToScreenName]];
    } else{
        cell.inReplyToScreenNameLabel.hidden = YES;
    }
    
    
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

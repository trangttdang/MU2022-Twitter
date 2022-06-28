//
//  DetailTweetViewController.m
//  twitter
//
//  Created by Trang Dang on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailTweetViewController.h"
#import "APIManager.h"
#import "ComposeViewController.h"
#import "TweetCell.h"

@interface DetailTweetViewController () <ComposeViewControllerDelegate, TweetCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePostedLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *textTextView;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UITableView *replyTableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets ;
//@property (strong, nonatomic) NSMutableArray *arrayOfReplyTweets;

@end

@implementation DetailTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.replyTableView.delegate = self;
    self.replyTableView.dataSource = self;
    
    self.arrayOfTweets = [[NSMutableArray alloc] init];
    [[APIManager shared] getUserMentionWithCompletion:^(NSMutableArray *tweets, NSError *error) {
                if (tweets) {
                    NSLog(@"😎😎😎 Successfully loaded home timeline");
                    
                    for (Tweet *tweet in tweets) {
                        NSLog(@"%@",tweet.text);
                        if ([[NSString stringWithFormat:@"%@", tweet.inReplyToStatusIdString] isEqual: [NSString stringWithFormat:@"%@", self.tweet.idStr]]){
                            [self.arrayOfTweets addObject:tweet];
                        }
                    }
//                    self.arrayOfTweets = tweets;

                } else {
                    NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
                }
        [self.replyTableView reloadData];

    }];
    
    // Do any additional setup after loading the view.
    self.userNameLabel.text = self.tweet.user.name;
    self.userScreenNameLabel.text = self.tweet.user.screenName;
    self.textTextView.text = self.tweet.text;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    self.profileImageView.image = [UIImage imageWithData:urlData];
    self.datePostedLabel.text = self.tweet.createdAtSpecificString;
    [self.retweetButton setImage:[UIImage imageNamed:self.tweet.retweetImageAddress] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:self.tweet.favoriteImageAddress] forState:UIControlStateNormal];
    
    self.textTextView.text = self.tweet.text;;
    self.textTextView.editable = NO;
    self.textTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    NSURL *mediaUrlHttps = [NSURL URLWithString:self.tweet.mediaUrlHttps];
    NSData *mediaData = [NSData dataWithContentsOfURL:mediaUrlHttps];
    
    if(self.tweet.mediaUrlHttps){
        self.mediaImageView.image = [UIImage imageWithData:mediaData];
        self.mediaImageView.layer.cornerRadius = 5;
    } else{
        self.mediaImageView.hidden = YES;
    }
//    self.delegate = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didTapReply:(id)sender {
    ComposeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    viewController.delegate = self;
    viewController.inReplyToStatusID = self.tweet.idStr;
    viewController.inReplyToScreenName = self.tweet.user.screenName;
    viewController.username = self.tweet.user.screenName;
    [self.navigationController pushViewController: viewController animated:YES];
}

- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted == NO){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        self.tweet.retweetImageAddress =@"retweet-icon-green";
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        [self.retweetButton setImage:[UIImage imageNamed:self.tweet.retweetImageAddress] forState:UIControlStateNormal];
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                NSLog(@"Tweet retweet count %d", tweet.retweetCount);

                [self.delegate didTweet:self.tweet];
            }
        }];
    } else if(self.tweet.retweeted == YES){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
//        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        self.tweet.retweetImageAddress =@"retweet-icon";
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        [self.retweetButton setImage:[UIImage imageNamed:self.tweet.retweetImageAddress] forState:UIControlStateNormal];
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                NSLog(@"Tweet retweet count - unretweet %d", tweet.retweetCount);
                [self.delegate didUnRetweet:tweet];
            }
        }];
    }
    
}

- (IBAction)didTapFavorite:(id)sender {
        if(self.tweet.favorited == NO){
        //Update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        self.tweet.favoriteImageAddress = @"favor-icon-red";
        // Send a POST request to the POST favorites/create endpoint
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        [self.favoriteButton setImage:[UIImage imageNamed:self.tweet.favoriteImageAddress] forState:UIControlStateNormal];
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                NSLog(@"Tweet favorite count %d", tweet.favoriteCount);
                [self.delegate didTapFavorite:tweet];
            }
        }];
    } else if(self.tweet.favorited == YES){
        //Update the local tweet model
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        //Update cell UI
        self.tweet.favoriteImageAddress = @"favor-icon";
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        [self.favoriteButton setImage:[UIImage imageNamed:self.tweet.favoriteImageAddress] forState:UIControlStateNormal];
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                NSLog(@"Tweet favorite count %d", tweet.favoriteCount);
                [self.delegate didTapFavorite:tweet];
            }
        }];
    }
    
}

- (void)didTweet:(nonnull Tweet *)tweet {
    self.tweet.inReplyToStatusIdString = tweet.inReplyToStatusIdString;
    self.tweet.inReplyToScreenName = tweet.inReplyToScreenName;
    NSLog(@"It replied");
//    [self.delegate didTweet:tweet];
    
}

- (void)didTapProfileImage:(nonnull Tweet *)tweet {
    
}


- (void)didUnRetweet:(nonnull Tweet *)tweet {
    
}


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



@end

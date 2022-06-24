//
//  DetailTweetViewController.m
//  twitter
//
//  Created by Trang Dang on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailTweetViewController.h"
#import "APIManager.h"

@interface DetailTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePostedLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *textTextView;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@end

@implementation DetailTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
//    if(self.tweet.favorited == YES){
//        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
//    } else if (self.tweet.favorited == NO){
//        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
//    }
//    if(self.tweet.retweeted == YES){
//        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
//    }
//    if(self.tweet.retweeted == NO){
//        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
//                [self.delegate didTapFavorite:tweet];
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
//                [self.delegate didTapFavorite:tweet];
            }
        }];
    }
    
}

@end

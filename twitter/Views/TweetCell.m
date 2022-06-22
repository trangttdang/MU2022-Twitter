//
//  TweetCell.m
//  twitter
//
//  Created by Trang Dang on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted == NO){
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                NSLog(@"Tweet retweet count %d", tweet.retweetCount);

                    self.tweet.retweeted = YES;
                    self.tweet.retweetCount += 1;
                    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
                [self refreshData];
            }
        }];
    } else if(self.tweet.retweeted == YES){

        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                NSLog(@"Tweet retweet count %d", tweet.retweetCount);
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
                [self refreshData];
            }
        }];
    }
    // Send a POST request to the POST favorites/create endpoint
    
}
- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited == NO){

        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                NSLog(@"Tweet favorite count %d", tweet.favoriteCount);
//                [self.delegate didTapFavorite:tweet];
                //Update the local tweet model
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                //Update cell UI
                [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
                [self refreshData];
                
            }
        }];
    } else if(self.tweet.favorited == YES){

        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                NSLog(@"Tweet favorite count %d", tweet.favoriteCount);
//                [self.delegate didTapFavorite:tweet];
                //Update the local tweet model
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                //Update cell UI
                [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
                [self refreshData];
            }
        }];
    }

    
    
}

- (void)refreshData{
//    self.userNameLabel.text = self.tweet.user.name;
//    self.textLabel.text = self.tweet.text;
//    self.dateCreatedLabel.text = self.tweet.createdAtString;
//    self.userScreenNameLabel.text = self.tweet.user.screenName;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}
@end

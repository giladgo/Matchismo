//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Gilad Goldberg on 9/19/13.
//  Copyright (c) 2013 Gilad Goldberg. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface MatchismoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchMode;
@end

@implementation MatchismoViewController

- (void)viewDidLoad {
    [self deal];
}


- (void) setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (IBAction)changeMatchMode:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.game.matchMode = 2;
    }
    else if (sender.selectedSegmentIndex == 1) {
        self.game.matchMode = 3;
    }
}

- (void) updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
}

- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flip Count: %d", self.flipCount];
}
- (IBAction)deal {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                    usingDeck:[[PlayingCardDeck alloc] init]
                 ];
    self.matchMode.enabled = YES;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    int oldScore = self.game.score;
    Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    int newScore = self.game.score;
    if ([self.game.latestMatchedCards count]) {
        // There was a match attempt
        if ([card match:self.game.latestMatchedCards]) {
            // It was successful
            self.statusLabel.text = [NSString stringWithFormat:@"Matched %@ & %@ for %d points!",
                                     card,
                                     [self.game.latestMatchedCards componentsJoinedByString:@" & "],
                                     abs(newScore - oldScore)];
        }
        else {
            // It wasn't
            self.statusLabel.text = [NSString stringWithFormat:@"%@ & %@ Don't match, you lose %d points.",
                                     card,
                                     [self.game.latestMatchedCards componentsJoinedByString:@" & "],
                                     abs(newScore - oldScore)];
        }
    }
    else {
        if (card.isFaceUp) {
            self.statusLabel.text = [NSString stringWithFormat:@"Flipped up %@.", card];
        }
        else {
            self.statusLabel.text = [NSString stringWithFormat:@"Flipped down %@.", card];
        }
    }
    self.flipCount++;
    self.matchMode.enabled = NO;
    [self updateUI];
}

@end

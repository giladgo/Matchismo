//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Gilad Goldberg on 9/19/13.
//  Copyright (c) 2013 Gilad Goldberg. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString* latestStatus;
@property (strong, nonatomic) NSMutableArray *cards; // of Card

@property (strong, readwrite, nonatomic) NSArray *latestMatchedCards;

@end

@implementation CardMatchingGame

- (NSMutableArray *) cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSUInteger)matchMode {
    if (!_matchMode) _matchMode = 2;
    return _matchMode;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
- (void)flipCardAtIndex:(NSUInteger)index {
    Card * card = [self cardAtIndex:index];
    if (card && !card.isUnplayable) {
        self.latestMatchedCards = @[];
        if (!card.isFaceUp) {
            self.score -= FLIP_COST;
            
            NSMutableArray *matchedCards = [[NSMutableArray alloc] init];
            
            for (Card* otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [matchedCards addObject:otherCard];
                }
            }
            
            if ([matchedCards count] == (self.matchMode - 1)) {
                int matchScore = [card match:matchedCards];
                
                if (matchScore) {
                    card.unplayable = YES;
                    for (Card* otherCard in matchedCards) {
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore * MATCH_BONUS;
                } else {
                    for (Card* otherCard in matchedCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                }
                self.latestMatchedCards = matchedCards;
            }
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}
- (id) init {
    self = nil;
    return self;
}

- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck*) deck {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            }
            else {
                self = nil;
                break;
            }
        }
        
    }
    
    return self;
}


@end

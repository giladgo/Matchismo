//
//  PlayingCard.m
//  Matchismo
//
//  Created by Gilad Goldberg on 9/19/13.
//  Copyright (c) 2013 Gilad Goldberg. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard()
-(BOOL)matchSuit: (NSArray *)otherCards;
-(BOOL)matchRank: (NSArray *)otherCards;
@end

@implementation PlayingCard

-(BOOL)matchSuit: (NSArray *)otherCards
{
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.suit != self.suit) {
            return NO;
        }
    }
    return YES;
}
-(BOOL)matchRank: (NSArray *)otherCards
{
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.rank != self.rank) {
            return NO;
        }
    }
    return YES;
}


- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([self matchSuit:otherCards]) {
        score = 1 * [otherCards count];
    } else if ([self matchRank:otherCards]) {
        score = 4 * [otherCards count];
    }

    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter && getter

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

@end

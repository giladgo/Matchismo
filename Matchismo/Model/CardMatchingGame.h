//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Gilad Goldberg on 9/19/13.
//  Copyright (c) 2013 Gilad Goldberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (id) init;

// designated initializer
- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck*) deck;

- (void) flipCardAtIndex:(NSUInteger)index;

- (Card *) cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;

@property (strong, readonly, nonatomic) NSArray *latestMatchedCards;
@property (nonatomic) NSUInteger matchMode;

@end

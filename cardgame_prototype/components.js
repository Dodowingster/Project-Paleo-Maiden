// Deck holds the ordered list of cards and provides shuffle/draw operations
class Deck {
    constructor(cardList = []) {
        this.cardList = Array.isArray(cardList) ? cardList.slice() : [];
    }

    shuffle() {
        // Fisher-Yates
        for (let i = this.cardList.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [this.cardList[i], this.cardList[j]] = [this.cardList[j], this.cardList[i]];
        }
        return this;
    }

    drawCard() {
        // take from top (front)
        return this.cardList.shift() || null;
    }

    addToBottom(card) {
        this.cardList.push(card);
        return this;
    }

    size() {
        return this.cardList.length;
    }
}

// Discard pile holds played/discarded cards and can return them to a deck
class DiscardPile {
    constructor() {
        this.cardList = [];
    }

    add(card) {
        this.cardList.push(card);
        return this;
    }

    clear() {
        this.cardList = [];
        return this;
    }

    // Move all cards back into the given deck (appended to bottom)
    returnToDeck(deck) {
        if (!deck || !Array.isArray(deck.cardList)) throw new Error('Invalid deck to return to');
        while (this.cardList.length) {
            deck.cardList.push(this.cardList.shift());
        }
        return this;
    }
}

// Hand holds a player's cards and can draw from its associated deck
class Hand {
    constructor({ maxNo = 10, turnNo = 3 } = {}) {
        this.maxNo = maxNo;
        this.turnNo = turnNo;
        this.cards = [];
    }

    draw(deck, numDraw){
        if (!deck) throw new Error('Hand has no deck to draw from');
        const drawn = [];
        for (let i = 0; i < numDraw && this.cards.length < this.maxNo; i++) {
            const c = deck.drawCard();
            if (!c) break;
            this.cards.push(c);
            drawn.push(c);
        }
        return drawn;
    }

    // Draw cards up to a target hand size, handling deck reshuffling from a discard pile.
    drawUpTo(deck, discardPile) {
        const want = Math.min(this.turnNo, this.maxNo) - this.size();
        if (want <= 0) return [];

        let drawn = this.draw(deck, want);
        const stillWant = Math.min(this.turnNo, this.maxNo) - this.size();

        // If we still need more cards, the deck is empty, and the discard pile has cards,
        // then reshuffle the discard pile into the deck and try drawing again.
        if (stillWant > 0 && deck && deck.size() === 0 && discardPile && discardPile.cardList.length > 0) {
            console.log(`Insufficient deck: returning discard to deck and shuffling`);
            discardPile.returnToDeck(deck);
            deck.shuffle();
            const drawn2 = this.draw(deck, stillWant);
            drawn = drawn.concat(drawn2);
        }

        return drawn;
    }

    addCard(card) {
        if (this.cards.length >= this.maxNo) return false;
        this.cards.push(card);
        return true;
    }

    removeCard(card) {
        const idx = this.cards.indexOf(card);
        if (idx === -1) return null;
        return this.cards.splice(idx, 1)[0];
    }

    size() {
        return this.cards.length;
    }

    clear() {
        this.cards = [];
        return this;
    }
}

class Character {
    // deckArg may be a Deck instance (arrays are no longer accepted)
    constructor({ health = 30, maxMana = 3, name = null, deck: deckArg = null, handMax = 10, handTurn = 3, speedDice = new Dice() } = {}) {
        this.health = health;
        this.mana = maxMana;
        this.maxMana = maxMana;
        this.name = name;
        this.speedDice = speedDice;

        // Normalize deckArg into a Deck. Only Deck instances are accepted; otherwise default to empty Deck.
        if (deckArg instanceof Deck) {
            this.deck = deckArg;
        } else {
            this.deck = new Deck([]);
        }

        this.discard = new DiscardPile();
        this.hand = new Hand({ maxNo: handMax, turnNo: handTurn, deck: this.deck });
    }

    takeDamage(amount) {
        this.health = Math.max(0, this.health - amount);
        return this.health;
    }

    heal(amount) {
        this.health += amount;
        return this.health;
    }

    canPlay(card) {
        if (!card || typeof card.manaCost !== 'number') return false;
        return this.mana >= card.manaCost;
    }

    spendMana(amount) {
        if (amount > this.mana) throw new Error('Not enough mana');
        this.mana -= amount;
        return this.mana;
    }

    restoreMana() {
        this.mana = this.maxMana;
        return this.mana;
    }

    // Play a card (remove from hand if present), spend mana, apply effects, and send card to discard
    playCard(card, target) {
        if (!this.canPlay(card)) throw new Error('Cannot play card: insufficient mana or invalid card');
        this.spendMana(card.manaCost);

        // remove from hand if it exists
        this.hand.removeCard(card);

        const res = card.play(this, target);

        // add to discard
        this.discard.add(card);
        return res;
    }
}

class Card {
    // This implementation fully commits to an `effects` array.
    // Each element can be either a function(caster, target) or an object with apply(caster, target).
    constructor({ manaCost = 0, effects = [], color = 'colourless', name = null } = {}) {
        const validColors = ['red', 'colourless'];
        if (!validColors.includes(color)) throw new Error(`Invalid color: ${color}`);
        this.manaCost = manaCost;
        this.color = color;
        this.name = name;

        if (!Array.isArray(effects)) throw new Error('Card constructor: effects must be an array');
        this.effects = effects.slice(); // copy to avoid external mutation
    }

    // Add a new effect (function or Effect-like object)
    addEffect(effect) {
        this.effects.push(effect);
        return this;
    }

    // Remove first matching effect by reference
    removeEffect(effect) {
        const idx = this.effects.indexOf(effect);
        if (idx !== -1) this.effects.splice(idx, 1);
        return this;
    }

    // Apply all effects in order. Returns an array of results (one per effect).
    play(caster, target) {
        const results = [];
        for (const eff of this.effects) {
            if (typeof eff === 'function') {
                results.push(eff(caster, target));
                continue;
            }
            if (eff && typeof eff.apply === 'function') {
                results.push(eff.apply(caster, target));
                continue;
            }
            // unsupported effect representation
            results.push(null);
        }
        return results;
    }
}

/* Optional: small Effect helper and a common DamageEffect example */

class Effect {
    apply(caster, target) {
        // override in subclasses
        throw new Error('Effect.apply not implemented');
    }

    toString() {
        return this.description;
    }
}

class DamageEffect extends Effect {
    constructor(amount) {
        super();
        this.amount = amount;
        this.description = `Deal ${amount} damage`;
    }

    apply(caster, target) {
        if (!target || typeof target.takeDamage !== 'function') throw new Error('Invalid target for damage');
        target.takeDamage(this.amount);
        return { damage: this.amount };
    }
}

class HealEffect extends Effect {
    // target: 'caster' (default) or 'target'
    constructor(amount, target = 'caster') {
        super();
        this.amount = amount;
        this.target = target;
        this.description = `Heal ${amount} to ${target}`;
    }

    apply(caster, target) {
        const recipient = this.target === 'target' ? target : caster;
        if (!recipient || typeof recipient.heal !== 'function') throw new Error('Invalid recipient for heal');
        recipient.heal(this.amount);
        return { heal: this.amount };
    }
}


class Dice {
    constructor({ faceValues = [1,2,3,4,5,6] } = {}){
        this.faceValues = faceValues
    }

    roll(){
        return this.faceValues[Math.floor(Math.random() * (this.faceValues.length - 1))];
    }
}

const GameStates = {
    GAME_START: 'GameStart',
    START_TURN: 'StartTurn',
    FIRST_PLAY: 'FirstPlay',
    SECOND_PLAY: 'SecondPlay',
    GAME_OVER: 'GameOver',
};

class GameStateManager {
    constructor(playerA, playerB) {
        this.playerA = playerA;
        this.playerB = playerB;
        this.turn = 0;
        this.currentState = GameStates.GAME_START;
        this.activePlayer = null;
        this.inactivePlayer = null;
        this.turnData = {
            beforeA: [],
            beforeB: [],
            playedA: [],
            playedB: [],
        };
    }

    advance() {
        switch (this.currentState) {
            case GameStates.GAME_START:
                this.currentState = GameStates.START_TURN;
                break;

            case GameStates.START_TURN:
                this.turn++;
                const startRes = startTurn(this.playerA, this.playerB);

                this.turnData = {
                    beforeA: startRes.beforeA,
                    beforeB: startRes.beforeB,
                    playedA: [],
                    playedB: [],
                };

                // Determine who goes first
                const rollA = this.playerA.speedDice.roll();
                const rollB = this.playerB.speedDice.roll();

                if (rollA >= rollB) {
                    this.activePlayer = this.playerA;
                    this.inactivePlayer = this.playerB;
                } else {
                    this.activePlayer = this.playerB;
                    this.inactivePlayer = this.playerA;
                }
                this.currentState = GameStates.FIRST_PLAY;
                break;

            case GameStates.FIRST_PLAY:
                const result1 = runTurn(this.activePlayer, this.inactivePlayer);
                if (this.activePlayer === this.playerA) {
                    this.turnData.playedA = result1.played;
                } else {
                    this.turnData.playedB = result1.played;
                }
                this.currentState = (this.inactivePlayer.health <= 0) ? GameStates.GAME_OVER : GameStates.SECOND_PLAY;
                break;

            case GameStates.SECOND_PLAY:
                const result2 = runTurn(this.inactivePlayer, this.activePlayer);
                if (this.inactivePlayer === this.playerA) {
                    this.turnData.playedA = result2.played;
                } else {
                    this.turnData.playedB = result2.played;
                }
                this.currentState = (this.activePlayer.health <= 0) ? GameStates.GAME_OVER : GameStates.START_TURN;
                break;

            case GameStates.GAME_OVER:
                this.previousState = GameStates.GAME_OVER;
                break;
        }
        console.log('');
    }
}

// Example usage:
const shuffleArray = (arr) => {
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
};

// startTurn: prepare players for a turn (restore mana and draw up to their hand size)
function startTurn(playerA, playerB) {
    // restore mana
    playerA.restoreMana();
    playerB.restoreMana();

    console.log(`${playerA.name} and ${playerB.name} mana restored to ${playerA.mana}/${playerA.maxMana} and ${playerB.mana}/${playerB.maxMana}`);

    const drawnA = playerA.hand.drawUpTo(playerA.deck, playerA.discard);
    const drawnB = playerB.hand.drawUpTo(playerB.deck, playerB.discard);

    // Capture the hands as they are immediately after drawing (this is the "before play" view)
    const beforeA = playerA.hand.cards.slice();
    const beforeB = playerB.hand.cards.slice();

    console.log(`${playerA.name} drew ${drawnA.length} card(s): ${drawnA.map(c => c.name).join(', ')}`);
    console.log(`${playerB.name} drew ${drawnB.length} card(s): ${drawnB.map(c => c.name).join(', ')}`);

    return { beforeA, beforeB };
}

// playSingleCard: selects and plays the best single card from a player's hand.
// Returns an object with the played card and a boolean indicating if more cards can be played.
function playSingleCard(player, target) {
    const playable = player.hand.cards.filter(c => player.canPlay(c));

    if (playable.length === 0) {
        return { playedCard: null, canPlayMore: false };
    }

    // AI Logic: Prioritize highest mana cost, then color (red > colourless)
    playable.sort((a, b) => {
        // 1. Higher mana cost first
        if (b.manaCost !== a.manaCost) {
            return b.manaCost - a.manaCost;
        }
        // 2. Color priority: 'red' > 'colourless'
        if (a.color === 'red' && b.color === 'colourless') {
            return -1;
        }
        if (a.color === 'colourless' && b.color === 'red') {
            return 1;
        }
        return 0;
    });

    const cardToPlay = playable[0];

    try {
        player.playCard(cardToPlay, target);
        console.log(`${player.name} played: Card(name=${cardToPlay.name||'<anon>'}, mana=${cardToPlay.manaCost}, color=${cardToPlay.color})`);
    } catch (e) {
        console.error(`Error playing card ${cardToPlay.name}:`, e);
        // If a card fails to play, we might still be able to play others.
        const stillPlayable = player.hand.cards.some(c => player.canPlay(c));
        return { playedCard: null, canPlayMore: stillPlayable };
    }

    // Check if any more cards can be played after this one
    const canPlayMore = player.hand.cards.some(c => player.canPlay(c));

    return { playedCard: cardToPlay, canPlayMore };
}

function runTurn(player, target) {
    // Ensure the turn is prepared; call startTurn to restore mana/draw and capture pre-play hands
    const before = player.hand.cards.slice();
    const played = [];
    let canPlay = true;

    while(canPlay) {
        const result = playSingleCard(player, target);
        if (result.playedCard) {
            played.push(result.playedCard);
        }
        canPlay = result.canPlayMore;
    }

    // Log details of cards played this turn
    console.log(`${player.name}'s turn ended. Total cards played: ${played.length}`);

    // Discard remaining cards in hand at end of turn
    function discardHand(player) {
        while (player.hand.cards.length) {
            const c = player.hand.cards.shift();
            player.discard.add(c);
        }
    }

    discardHand(player);

    // Return played lists and the pre-play hands so callers (UI) can show them
    return { played, before };
}

// Expose library for Node (require) and attach to globalThis for browser usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        Deck,
        DiscardPile,
        Hand,
        Character,
        Card,
        Effect,
        DamageEffect,
        HealEffect,
        GameStates,
        GameStateManager,
        playSingleCard,
        startTurn,
        runTurn,
        shuffleArray
    };
}

// Attach to globalThis so browser scripts can access the classes/functions as globals
if (typeof globalThis !== 'undefined') {
    globalThis.Deck = Deck;
    globalThis.DiscardPile = DiscardPile;
    globalThis.Hand = Hand;
    globalThis.Character = Character;
    globalThis.Card = Card;
    globalThis.Effect = Effect;
    globalThis.DamageEffect = DamageEffect;
    globalThis.HealEffect = HealEffect;
    globalThis.GameStates = GameStates;
    globalThis.GameStateManager = GameStateManager;
    globalThis.playSingleCard = playSingleCard;
    globalThis.startTurn = startTurn;
    globalThis.runTurn = runTurn;
    globalThis.shuffleArray = shuffleArray;
}
 
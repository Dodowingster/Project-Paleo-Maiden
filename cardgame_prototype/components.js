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
    constructor({ maxNo = 10, turnNo = 3, deck = null } = {}) {
        this.maxNo = maxNo;
        this.turnNo = turnNo;
        this.cards = [];
        this.deck = deck;
    }

    // Draw up to numDraw cards from the associated deck (default 3), stopping if hand reaches maxNo
    draw() {
        if (!this.deck) throw new Error('Hand has no deck to draw from');
        const drawn = [];
        for (let i = 0; i < this.turnNo && this.cards.length < this.maxNo; i++) {
            const c = this.deck.drawCard();
            if (!c) break;
            this.cards.push(c);
            drawn.push(c);
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
    constructor({ health = 30, mana = 3, maxMana = 3, name = null, deck: deckArg = null, handMax = 10, handTurn = 3 } = {}) {
        this.health = health;
        this.mana = mana;
        this.maxMana = maxMana;
        this.name = name;

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

// Example usage:
const shuffleArray = (arr) => {
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
};

// startTurn: prepare players for a turn (restore mana and draw up to their hand size)
function startTurn(playerA, playerB, targetHandSize = 3) {
    // restore mana
    playerA.restoreMana();
    playerB.restoreMana();

    console.log(`${playerA.name} and ${playerB.name} mana restored to ${playerA.mana}/${playerA.maxMana} and ${playerB.mana}/${playerB.maxMana}`);

    // both draw up to targetHandSize (or reach their hand max). Handle deck refill if needed.
    function drawUpTo(player) {
        const want = Math.min(targetHandSize, player.hand.maxNo) - player.hand.size();
        if (want <= 0) return [];
        const drawn = player.hand.draw(want);
        // if we still want more and deck is empty but discard has cards, refill once and draw remaining
        if (player.hand.size() < Math.min(targetHandSize, player.hand.maxNo)) {
            if (player.deck.size() === 0 && player.discard.cardList.length > 0) {
                console.log(`${player.name} has insufficient deck: returning discard to deck and shuffling`);
                player.discard.returnToDeck(player.deck);
                player.deck.shuffle();
                player.hand.draw(Math.min(targetHandSize, player.hand.maxNo) - player.hand.size());
            } else if (player.deck.size() === 0 && player.discard.cardList.length === 0) {
                // Explicit guard/log when a draw attempt fails due to empty deck and empty discard
                console.log(`${player.name} attempted to draw ${want} card(s) but no cards available (deck and discard are empty).`);
            }
        }
        return drawn;
    }

    const drawnA = drawUpTo(playerA);
    const drawnB = drawUpTo(playerB);

    // Capture the hands as they are immediately after drawing (this is the "before play" view)
    const beforeA = playerA.hand.cards.slice();
    const beforeB = playerB.hand.cards.slice();

    console.log(`${playerA.name} drew ${drawnA.length} card(s): ${drawnA.map(c => c.name).join(', ')}`);
    console.log(`${playerB.name} drew ${drawnB.length} card(s): ${drawnB.map(c => c.name).join(', ')}`);

    return { beforeA, beforeB };
}

// runTurn: play cards and handle end-of-turn discarding. startTurn should be called before runTurn
function runTurn(playerA, playerB, performStart = true) {
    // Ensure the turn is prepared; call startTurn to restore mana/draw and capture pre-play hands
    let beforeA, beforeB;
    if (performStart) {
        const res = startTurn(playerA, playerB);
        beforeA = res.beforeA;
        beforeB = res.beforeB;
    } else {
        // caller already ran startTurn; snapshot current hands as 'before'
        beforeA = playerA.hand.cards.slice();
        beforeB = playerB.hand.cards.slice();
    }

    // Helper to play as many cards as possible in random order, recording played cards
    function playAllPossible(player, opponent, playedList) {
        let progress = true;
        while (progress) {
            const playable = player.hand.cards.filter(c => player.canPlay(c));
            if (playable.length === 0) break;
            shuffleArray(playable);
            progress = false;
            for (const card of playable) {
                if (player.canPlay(card)) {
                    try {
                        player.playCard(card, opponent);
                        playedList.push(card);
                    } catch (e) {
                        // ignore and continue
                    }
                    progress = true;
                }
            }
        }
    }

    const playedA = [];
    const playedB = [];

    playAllPossible(playerA, playerB, playedA);
    playAllPossible(playerB, playerA, playedB);

    // Log details of cards played this turn
    const describeCard = (c) => `Card(name=${c.name||'<anon>'}, mana=${c.manaCost}, color=${c.color}, effects=${Array.isArray(c.effects)?c.effects.length:0})`;
    console.log(`${playerA.name} played: ${playedA.map(describeCard).join(' || ') || '<none>'}`);
    console.log(`${playerB.name} played: ${playedB.map(describeCard).join(' || ') || '<none>'}`);

    // Discard remaining cards in hand at end of turn
    function discardHand(player) {
        while (player.hand.cards.length) {
            const c = player.hand.cards.shift();
            player.discard.add(c);
        }
    }

    discardHand(playerA);
    discardHand(playerB);

    // Return played lists and the pre-play hands so callers (UI) can show them
    return { playedA, playedB, beforeA, beforeB };
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
        SimpleEffect,
        DamageEffect,
        HealEffect,
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
    globalThis.SimpleEffect = SimpleEffect;
    globalThis.DamageEffect = DamageEffect;
    globalThis.HealEffect = HealEffect;
    globalThis.startTurn = startTurn;
    globalThis.runTurn = runTurn;
    globalThis.shuffleArray = shuffleArray;
}
 
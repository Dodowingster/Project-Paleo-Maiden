document.addEventListener('DOMContentLoaded', () => {
    // --- GAME STATE (Corresponds to GDD Sections I & II) ---

    // Card definitions - what each card does
    const CARD_DEFINITIONS = {
        'Basic Attack': { type: 'Attack', value: 5, color: 'Red' },
        'Basic Guard': { type: 'Guard', value: 5, color: 'Blue' },
        'Power Strike': { type: 'Attack', value: 8, color: 'Red' },
        'Quick Guard': { type: 'Guard', value: 8, color: 'Blue' },
        'Focus Energy': { type: 'Buff', value: 3, target: 'damage', color: 'Red' },
        'Healing Aura': { type: 'Heal', value: 10, color: 'Green' },
        'Sharp Claw': { type: 'Attack', value: 6, color: 'Green' },
        'Bonus Power Card': { type: 'Attack', value: 10, color: 'Red' },
        'Red Discipline Card': { type: 'Attack', value: 6, color: 'Red' },
        'Green Discipline Card': { type: 'Heal', value: 5, color: 'Green' },
    };

    const gameState = {
        year: 1,
        turns: 24,
        fossilFunds: 100,
        champion: {
            name: 'Tyran Rex',
            pMagic: 100,
            maxPMagic: 100,
            color: 'Red', // 🔴
            position: 0, // index on the map
            deck: ['Basic Attack', 'Basic Attack', 'Basic Attack', 'Basic Guard', 'Basic Guard'],
            consecutiveWins: 0,
        },
        map: [],
        gameLog: [],
        gameOver: false,
    };

    // State for the current combat encounter
    let combatState = {
        active: false,
        player: {
            pMagic: 0,
            block: 0,
            damageBuff: 0,
        },
        opponent: {
            pMagic: 0,
            block: 0,
        },
        drawPile: [],
        hand: [],
        discardPile: [],
    };

    // --- DOM ELEMENTS ---
    const pMagicDisplay = document.getElementById('p-magic-display');
    const yearDisplay = document.getElementById('year-display');
    const turnsDisplay = document.getElementById('turns-display');
    const fundsDisplay = document.getElementById('funds-display');
    const mapContainer = document.getElementById('world-map');
    const logMessages = document.getElementById('log-messages');
    const rollDiceBtn = document.getElementById('roll-dice-btn');
    const restBtn = document.getElementById('rest-btn');
    const rewardModal = document.getElementById('reward-modal');
    const rewardOptions = document.getElementById('reward-options');
    const confirmRewardBtn = document.getElementById('confirm-reward-btn');
    const combatModal = document.getElementById('combat-modal');
    const combatPlayerStatus = document.getElementById('combat-player-status');
    const combatOpponentStatus = document.getElementById('combat-opponent-status');
    const combatHand = document.getElementById('combat-hand');
    const combatNextTurnBtn = document.getElementById('combat-next-turn-btn');
    const combatLog = document.getElementById('combat-log');

    // --- CORE GAME LOGIC ---

    /**
     * Initializes the game, creates the map, and renders the initial state.
     */
    function init() {
        // Create the world map based on GDD Section III
        const spaceTypes = ['Sparring Session', 'Dojo', 'Hot Spring', 'Sparring Session', 'Milestone', 'Sparring Session', 'Dojo', 'Hot Spring'];
        gameState.map = Array(16).fill(null).map((_, i) => {
            const type = spaceTypes[i % spaceTypes.length];
            let cssClass = '';
            switch (type) {
                case 'Sparring Session': cssClass = 'space-sparring'; break;
                case 'Dojo': cssClass = 'space-dojo'; break;
                case 'Hot Spring': cssClass = 'space-hot-spring'; break;
                case 'Milestone': cssClass = 'space-milestone'; break;
            }
            return { id: i, type, cssClass };
        });

        renderMap();
        createPlayerToken();
        updateUI();
        logEvent("The Paleo-Maiden Championship begins!");
    }

    /**
     * Renders all UI elements based on the current gameState.
     */
    function updateUI() {
        pMagicDisplay.textContent = `${gameState.champion.pMagic} / ${gameState.champion.maxPMagic}`;
        yearDisplay.textContent = `${gameState.year} (Triassic)`;
        turnsDisplay.textContent = gameState.turns;
        fundsDisplay.textContent = gameState.fossilFunds;

        // Update player token position
        const playerToken = document.getElementById('player-token');
        const targetSpace = document.querySelector(`.map-space[data-id='${gameState.champion.position}']`);
        if (playerToken && targetSpace) {
            playerToken.style.top = `${targetSpace.offsetTop + (targetSpace.offsetHeight / 2) - 15}px`;
            playerToken.style.left = `${targetSpace.offsetLeft + (targetSpace.offsetWidth / 2) - 15}px`;
        }

    }

    /**
     * Logs an event to the on-screen log panel.
     */
    function logEvent(message, type = 'normal') {
        const p = document.createElement('p');
        p.textContent = message;
        if (type === 'error') p.style.color = 'red';
        if (type === 'info') p.style.color = 'blue';
        logMessages.prepend(p);
    }

    function spendTurn(amount = 1, isResting = false) {
        if (gameState.gameOver) return false;

        // Check for game over conditions at the start of a turn-spending action
        if (gameState.champion.pMagic <= 0) {
            // If P-Magic is 0, only resting is allowed. Any other action ends the game.
            if (!isResting) {
                logEvent("Cannot act with 0 P-Magic! You must rest. Your career ends.", 'error');
                endGame();
                return false;
            }
        }
        if (gameState.turns <= 0) {
            logEvent("You are out of turns for the year! The League Exam begins...", 'info');
            endGame();
            return false;
        }

        if (gameState.turns >= amount) {
            gameState.turns -= amount;
            return true;
        }
        return false;
    }

    function endGame() {
        gameState.gameOver = true;
        rollDiceBtn.disabled = true;
        restBtn.disabled = true;
        rollDiceBtn.style.backgroundColor = '#6c757d';
        restBtn.style.backgroundColor = '#6c757d';
        logEvent("GAME OVER. Please refresh to play again.", 'error');
    }

    // --- MAP & MOVEMENT (GDD Section III) ---

    function rollDice() {
        if (!spendTurn(1, false)) return; // false: this is not a rest action

        const roll = Math.floor(Math.random() * 6) + 1;
        logEvent(`You rolled a ${roll}.`);
        gameState.champion.position = (gameState.champion.position + roll) % gameState.map.length;
        updateUI();

        // Use a timeout to let the player see the token move before the event triggers
        setTimeout(landOnSpace, 600);
    }

    function landOnSpace() {
        const space = gameState.map[gameState.champion.position];
        logEvent(`You landed on: ${space.type}.`);

        switch (space.type) {
            case 'Sparring Session':
                startCombat(false); // false = not a milestone
                break;
            case 'Milestone':
                logEvent("An Academic Milestone! This is a tough, mandatory battle.", 'info');
                startCombat(true); // true = is a milestone
                break;
            case 'Dojo':
                logEvent("You visit the Dojo. (Prototype: +$50 Funds instead of shop).");
                gameState.fossilFunds += 50;
                break;
            case 'Hot Spring':
                logEvent("You visit the Hot Spring. (Prototype: +10 P-Magic).");
                gameState.champion.pMagic = Math.min(gameState.champion.maxPMagic, gameState.champion.pMagic + 10);
                break;
        }
        updateUI();
    }

    // --- COMBAT SYSTEM (GDD Section IV) ---

    function startCombat(isMilestone) {
        combatState.active = true;
        combatState.isMilestone = isMilestone;

        // Setup player for combat
        combatState.player.pMagic = gameState.champion.pMagic;
        combatState.player.block = 0;
        combatState.player.damageBuff = 0;

        // Setup opponent
        combatState.opponent.pMagic = isMilestone ? 80 : 40;
        combatState.opponent.block = 0;

        // Setup deck
        combatState.drawPile = [...gameState.champion.deck];
        shuffle(combatState.drawPile);
        combatState.hand = [];
        combatState.discardPile = [];

        combatLog.innerHTML = '';
        combatLogEvent('Combat begins!', 'system');
        combatModal.classList.remove('modal-hidden');
        runCombatTurn();
    }

    function runCombatTurn() {
        // --- Player's Turn ---
        // 1. Reset block
        combatState.player.block = 0;

        // 2. Draw up to 5 cards (GDD Section IV)
        while (combatState.hand.length < 5 && (combatState.drawPile.length > 0 || combatState.discardPile.length > 0)) {
            if (combatState.drawPile.length === 0) {
                combatLogEvent('Reshuffling discard pile into deck.', 'system');
                combatState.drawPile = [...combatState.discardPile];
                shuffle(combatState.drawPile);
                combatState.discardPile = [];
            }
            combatState.hand.push(combatState.drawPile.pop());
        }

        // 3. AI selects cards to play (simple logic for prototype)
        const cardsToPlay = chooseCards(combatState.hand);
        combatLogEvent(`Champion plays: ${cardsToPlay.join(', ')}`, 'player');

        // 4. Resolve card effects
        let totalDamage = 0;
        for (const cardName of cardsToPlay) {
            const card = CARD_DEFINITIONS[cardName];
            if (!card) continue;

            switch (card.type) {
                case 'Attack':
                    totalDamage += card.value + combatState.player.damageBuff;
                    break;
                case 'Guard':
                    combatState.player.block += card.value;
                    break;
                case 'Buff':
                    combatState.player.damageBuff += card.value;
                    combatLogEvent(`Champion feels stronger! (+${card.value} damage)`, 'player');
                    break;
                case 'Heal':
                    combatState.player.pMagic = Math.min(gameState.champion.maxPMagic, combatState.player.pMagic + card.value);
                    combatLogEvent(`Champion heals for ${card.value} P-Magic.`, 'player');
                    break;
            }
        }

        // 5. Update hand and discard pile
        combatState.discardPile.push(...cardsToPlay);
        combatState.hand = combatState.hand.filter(card => !cardsToPlay.includes(card));

        // --- Opponent's Turn (Simplified) ---
        const opponentDamage = combatState.isMilestone ? 15 : 10;
        combatLogEvent(`Opponent attacks for ${opponentDamage} damage.`, 'opponent');

        // --- Damage Resolution ---
        // Player damages opponent
        const damageToOpponent = Math.max(0, totalDamage - combatState.opponent.block);
        combatState.opponent.pMagic -= damageToOpponent;
        combatLogEvent(`You deal ${damageToOpponent} damage.`, 'player');

        // Opponent damages player
        const damageToPlayer = Math.max(0, opponentDamage - combatState.player.block);
        combatState.player.pMagic -= damageToPlayer;
        combatLogEvent(`You take ${damageToPlayer} damage.`, 'opponent');

        updateCombatUI();

        // --- Check for end of combat ---
        if (combatState.opponent.pMagic <= 0) {
            endCombat(true); // Win
        } else if (combatState.player.pMagic <= 0) {
            endCombat(false); // Loss
        }
    }

    function endCombat(isVictory) {
        combatState.active = false;
        const pMagicBeforeCombat = gameState.champion.pMagic;
        combatModal.classList.add('modal-hidden');
        gameState.champion.pMagic = combatState.player.pMagic;

        if (isVictory) {
            // On victory, if P-Magic is 0 or less, set it to 1 to prevent an immediate game over.
            if (gameState.champion.pMagic <= 0) {
                gameState.champion.pMagic = 1;
            }
            let fundsWon = combatState.isMilestone ? 100 : 30;
            gameState.fossilFunds += fundsWon;
            gameState.champion.consecutiveWins++;
            logEvent(`VICTORY! You won the spar and gained $${fundsWon}.`, 'info');

            // Red Class Passive: Killing Streak (GDD Section V)
            if (gameState.champion.color === 'Red' && gameState.champion.consecutiveWins >= 3) {
                logEvent("Killing Streak! Red's passive grants an extra card.", 'info');
                gameState.champion.deck.push('Bonus Power Card');
                gameState.champion.consecutiveWins = 0; // Reset streak
            }

            // Perfect Victory bonus (GDD Section IV)
            if (combatState.player.pMagic >= pMagicBeforeCombat) {
                logEvent("Perfect Victory! You earned an extra $20.", 'info');
                gameState.fossilFunds += 20;
            }

            showRewardModal();
        } else {
            gameState.champion.pMagic = 0; // Set P-Magic to 0 on defeat, but don't end the game.
            gameState.champion.consecutiveWins = 0;
            logEvent(`DEFEAT! You lost the spar. Your P-Magic is now 0. You must rest to recover.`, 'error');
        }
        updateUI();
    }

    // Simple AI to choose which cards to play from hand
    function chooseCards(hand) {
        const guards = hand.filter(c => CARD_DEFINITIONS[c]?.type === 'Guard');
        const attacks = hand.filter(c => CARD_DEFINITIONS[c]?.type === 'Attack');
        // Prioritize playing one guard card if available, then play up to two attack cards.
        const play = [];
        if (guards.length > 0) play.push(guards[0]);
        play.push(...attacks.slice(0, 2));
        return play.slice(0, 3); // Max 3 cards per turn
    }

    function updateCombatUI() {
        combatPlayerStatus.textContent = `Player P-Magic: ${combatState.player.pMagic}`;
        combatOpponentStatus.textContent = `Opponent P-Magic: ${combatState.opponent.pMagic}`;
        combatHand.innerHTML = combatState.hand.map(cardName => {
            const cardDef = CARD_DEFINITIONS[cardName];
            const colorClass = cardDef ? `card-${cardDef.color.toLowerCase()}` : '';
            return `<div class="card ${colorClass}">${cardName}</div>`;
        }).join('');
    }

    function combatLogEvent(message, source = 'system') {
        const p = document.createElement('p');
        p.textContent = message;
        p.classList.add(`log-${source}`);
        combatLog.prepend(p);
    }

    function showRewardModal() {
        rewardModal.classList.remove('modal-hidden');
        rewardOptions.innerHTML = '';

        // Blue Class Passive: Scholarly Insight (GDD Section V)
        const numChoices = gameState.champion.color === 'Blue' ? 4 : 3;
        const possibleRewards = Object.keys(CARD_DEFINITIONS).filter(c => c.includes('Basic') === false);

        for (let i = 0; i < numChoices; i++) {
            const card = possibleRewards[Math.floor(Math.random() * possibleRewards.length)];
            rewardOptions.innerHTML += `<label><input type="radio" name="reward" value="${card}" ${i === 0 ? 'checked' : ''}> ${card}</label><br>`;
        }
    }

    function confirmReward() {
        const selectedCard = document.querySelector('input[name="reward"]:checked');
        if (selectedCard) {
            // GDD: 15 card max deck size
            if (gameState.champion.deck.length < 15) {
                gameState.champion.deck.push(selectedCard.value);
                logEvent(`Acquired new card: ${selectedCard.value}. Deck size is now ${gameState.champion.deck.length}.`);
            } else {
                logEvent(`Deck is full (15 cards)! Could not add ${selectedCard.value}.`);
            }
        }
        rewardModal.classList.add('modal-hidden');
    }

    // --- OTHER ACTIONS (GDD Section III) ---

    function restAtCampsite() {
        if (!spendTurn(1, true)) return; // true: this IS a rest action

        // Major P-Magic Recovery
        const recoveryAmount = Math.floor(gameState.champion.maxPMagic * 0.75);
        gameState.champion.pMagic = Math.min(gameState.champion.maxPMagic, gameState.champion.pMagic + recoveryAmount);
        logEvent(`You rest at the campsite, recovering ${recoveryAmount} P-Magic.`);

        // Green Class Passive: Double Time (GDD Section V)
        if (gameState.champion.color === 'Green') {
            // In a real game, you'd prompt the user. Here we'll just simulate the choice.
            const wantsExtraRoll = confirm("As a Green class, you can reject the free card to get an extra dice roll. OK for extra roll, Cancel for free card.");
            if (wantsExtraRoll) {
                logEvent("Double Time! You sacrifice learning for an extra move.");
                rollDice(); // This roll does not cost a turn
                return; // Skip the card gain
            }
        }

        // Standard card gain
        const disciplineCard = `${gameState.champion.color} Discipline Card`;
        if (gameState.champion.deck.length < 15) gameState.champion.deck.push(disciplineCard);
        logEvent(`You reflect on your training and gain a ${disciplineCard}.`);
        updateUI();
    }

    // --- RENDER & BINDINGS ---

    function renderMap() {
        mapContainer.innerHTML = gameState.map.map(space =>
            `<div class="map-space ${space.cssClass}" data-id="${space.id}">${space.type}</div>`
        ).join('');
    }

    function createPlayerToken() {
        const token = document.createElement('div');
        token.id = 'player-token';
        token.textContent = 'P';
        mapContainer.appendChild(token);
    }

    // Fisher-Yates Shuffle
    function shuffle(array) {
        for (let i = array.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]];
        }
    }

    // Event Listeners
    rollDiceBtn.addEventListener('click', rollDice);
    restBtn.addEventListener('click', restAtCampsite);
    confirmRewardBtn.addEventListener('click', confirmReward);
    combatNextTurnBtn.addEventListener('click', runCombatTurn);

    // Start the game
    init();
});
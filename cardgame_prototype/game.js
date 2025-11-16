// ui.js - moved from index.html inline script
// Capture console.log to show in UI and keep original console behavior
(function(){
	const origLog = console.log.bind(console);
	const logEl = document.getElementById('log');
	console.log = function(...args){
		origLog(...args);
		const line = args.map(a => typeof a === 'object' ? JSON.stringify(a) : String(a)).join(' ');
		logEl.textContent += line + '\n';
		logEl.scrollTop = logEl.scrollHeight;
	};
})();

// Demo driver
let p1, p2, turn = 0;

function makeTemplates(){
	return [
		{ name: 'Strike', manaCost: 1, effects: () => [new DamageEffect(2)], color: 'red' },
		{ name: 'Slash', manaCost: 2, effects: () => [new DamageEffect(3)], color: 'red' },
		{ name: 'Minor Heal', manaCost: 1, effects: () => [ new HealEffect(1, 'caster') ], color: 'colourless' },
		{ name: 'Fireblast', manaCost: 3, effects: () => [new DamageEffect(6)], color: 'red' },
		{ name: 'Jab', manaCost: 1, effects: () => [new DamageEffect(1)], color: 'red' },
		{ name: 'Smash', manaCost: 2, effects: () => [new DamageEffect(4)], color: 'red' },
		{ name: 'Second Wind', manaCost: 1, effects: () => [ new HealEffect(2, 'caster') ], color: 'colourless' },
		{ name: 'Crush', manaCost: 2, effects: () => [new DamageEffect(3)], color: 'red' },
	];
}

function makeDeckFromTemplates(templates, count){
	const out = [];
	for(let i=0;i<count;i++){
		const t = templates[Math.floor(Math.random()*templates.length)];
		out.push(new Card({ name: t.name, manaCost: t.manaCost, effects: t.effects(), color: t.color }));
	}
	return out;
}

function updateUI(info){
	if (!p1 || !p2) return;
	document.getElementById('pA_name').textContent = p1.name;
	document.getElementById('pB_name').textContent = p2.name;
	document.getElementById('pA_stats').textContent = `HP: ${p1.health}  Mana: ${p1.mana}/${p1.maxMana}  Deck: ${p1.deck.size()}  Hand: ${p1.hand.size()}  Discard: ${p1.discard.cardList.length}`;
	document.getElementById('pB_stats').textContent = `HP: ${p2.health}  Mana: ${p2.mana}/${p2.maxMana}  Deck: ${p2.deck.size()}  Hand: ${p2.hand.size()}  Discard: ${p2.discard.cardList.length}`;

	function makeCardEl(c, small=false){
		const div = document.createElement('div');
		const colorClass = c && c.color ? ('card-' + c.color.replace(/[^a-z0-9\-]/gi,'').toLowerCase()) : 'card-colourless';
		div.className = 'card' + (small ? ' small' : '') + ' ' + colorClass;
		const title = document.createElement('div'); title.className='title'; title.textContent = c.name || '<anon>';
		const meta = document.createElement('div'); meta.className='meta'; meta.textContent = `${c.manaCost} Mana • ${c.color}`;
		// Effect descriptions (Option B): use .description or toString() when available
		const effectsContainer = document.createElement('div');
		effectsContainer.className = 'meta';
		if (Array.isArray(c.effects) && c.effects.length > 0) {
			for (const eff of c.effects) {
				let desc = null;
				if (eff && typeof eff.description === 'string') desc = eff.description;
				else if (eff && typeof eff.toString === 'function' && eff.toString !== Object.prototype.toString) desc = eff.toString();
				else if (typeof eff === 'function') desc = '<custom function effect>';
				else desc = '<unknown effect>';
				const p = document.createElement('div'); p.textContent = desc; effectsContainer.appendChild(p);
			}
		} else {
			effectsContainer.textContent = 'No effects';
		}
		div.appendChild(title); div.appendChild(effectsContainer); div.appendChild(meta);
		return div;
	}

	// Adjust card scale so many cards fit in one row: set --card-scale and .scaled class on the container
	function adjustCardScale(container, count) {
		if (!container) return;
		const gap = 8; // must match CSS
		const cardBase = 100; // base card width in px
		if (!count || count <= 0) {
			container.classList.remove('scaled');
			container.style.removeProperty('--card-scale');
			return;
		}
		// measure available width (allow some padding)
		const avail = container.clientWidth || container.getBoundingClientRect().width || 460;
		const total = count * cardBase + Math.max(0, count - 1) * gap;
		if (total > avail) {
			let scale = avail / total;
			if (scale < 0.4) scale = 0.4; // don't shrink too far
			container.style.setProperty('--card-scale', scale);
			container.classList.add('scaled');
		} else {
			container.classList.remove('scaled');
			container.style.removeProperty('--card-scale');
		}
	}

	// const pAHand = document.getElementById('pA_hand'); pAHand.innerHTML='';
	// for(const c of p1.hand.cards) { pAHand.appendChild(makeCardEl(c)); }
	// adjustCardScale(pAHand, p1.hand.cards.length);
	// const pBHand = document.getElementById('pB_hand'); pBHand.innerHTML='';
	// for(const c of p2.hand.cards) { pBHand.appendChild(makeCardEl(c)); }
	// adjustCardScale(pBHand, p2.hand.cards.length);

	// Render hand-before if provided in info
	const pAHandBefore = document.getElementById('pA_hand_before');
	const pAHandBeforeLabel = document.getElementById('pA_hand_before_label');
	const pBHandBefore = document.getElementById('pB_hand_before');
	const pBHandBeforeLabel = document.getElementById('pB_hand_before_label');
	if (info && info.beforeA) {
		pAHandBefore.style.display = '';
		pAHandBeforeLabel.style.display = '';
		pAHandBefore.innerHTML = '';
		for (const c of info.beforeA) pAHandBefore.appendChild(makeCardEl(c));
		adjustCardScale(pAHandBefore, info.beforeA.length);
	} else {
		pAHandBefore.style.display = 'none';
		pAHandBeforeLabel.style.display = 'none';
		pAHandBefore.innerHTML = '';
	}
	if (info && info.beforeB) {
		pBHandBefore.style.display = '';
		pBHandBeforeLabel.style.display = '';
		pBHandBefore.innerHTML = '';
		for (const c of info.beforeB) pBHandBefore.appendChild(makeCardEl(c));
		adjustCardScale(pBHandBefore, info.beforeB.length);
	} else {
		pBHandBefore.style.display = 'none';
		pBHandBeforeLabel.style.display = 'none';
		pBHandBefore.innerHTML = '';
	}

	// Deck/discard counts
	document.getElementById('pA_deck_count').textContent = p1.deck.size();
	document.getElementById('pB_deck_count').textContent = p2.deck.size();
	document.getElementById('pA_discard_count').textContent = p1.discard.cardList.length;
	document.getElementById('pB_discard_count').textContent = p2.discard.cardList.length;

	// Clear previous played display
	document.getElementById('pA_played')?.remove();
	document.getElementById('pB_played')?.remove();
	document.getElementById('turnCounter').textContent = `Turn: ${turn}`;
	document.getElementById('turnCounter').textContent = `Turn: ${turn}`;

	// Render played cards from the provided info if present
	if (info && info.playedA) {
		const pAplayedContainer = document.createElement('div');
		pAplayedContainer.id = 'pA_played';
		const labelA = document.createElement('div'); labelA.className = 'muted'; labelA.textContent = 'Played this turn:';
		pAplayedContainer.appendChild(labelA);
		const cardsA = document.createElement('div'); cardsA.className = 'cards';
		for (const c of (info.playedA || [])) cardsA.appendChild(makeCardEl(c));
		pAplayedContainer.appendChild(cardsA);
		document.getElementById('playerA').appendChild(pAplayedContainer);
	}

	if (info && info.playedB){
		const pBplayedContainer = document.createElement('div');
		pBplayedContainer.id = 'pB_played';
		const labelB = document.createElement('div'); labelB.className = 'muted'; labelB.textContent = 'Played this turn:';
		pBplayedContainer.appendChild(labelB);
		const cardsB = document.createElement('div'); cardsB.className = 'cards';
		for (const c of (info.playedB || [])) cardsB.appendChild(makeCardEl(c));
		pBplayedContainer.appendChild(cardsB);
		document.getElementById('playerB').appendChild(pBplayedContainer);
	}
}

function startGame(){
	document.getElementById('log').textContent = '';
	turn = 0;
	
	// Get deck sizes from input fields
	const p1DeckSize = parseInt(document.getElementById('pA_configDeck').value, 10) || 20; // Default to 20 if empty or invalid
	const p2DeckSize = parseInt(document.getElementById('pB_configDeck').value, 10) || 20; // Default to 20 if empty or invalid

	// Get other config values from input fields, with defaults
	const p1Name = document.getElementById('pA_configName').value || 'Alice';
    const p1HP = parseInt(document.getElementById('pA_configHP').value, 10) || 30;
    const p1ManaPool = parseInt(document.getElementById('pA_configManaPool').value, 10) || 3;
    const p1HandTurn = parseInt(document.getElementById('pA_configHandTurn').value, 10) || 3;
    const p1HandMax = parseInt(document.getElementById('pA_configHandMax').value, 10) || 10;

    const p2Name = document.getElementById('pB_configName').value || 'Bob';
    const p2HP = parseInt(document.getElementById('pB_configHP').value, 10) || 30;
    const p2ManaPool = parseInt(document.getElementById('pB_configManaPool').value, 10) || 3;
    const p2HandTurn = parseInt(document.getElementById('pB_configHandTurn').value, 10) || 3;
    const p2HandMax = parseInt(document.getElementById('pB_configHandMax').value, 10) || 10;

	const templates = makeTemplates();
	const p1Deck = new Deck(makeDeckFromTemplates(templates, p1DeckSize));
	const p2Deck = new Deck(makeDeckFromTemplates(templates, p2DeckSize));

	// Use the config values when creating the character
	p1 = new Character({ name: p1Name, health: p1HP, maxMana: p1ManaPool, handMax: p1HandMax, handTurn: p1HandTurn, deck: p1Deck, speedDice: new Dice() });
	p2 = new Character({ name: p2Name, health: p2HP, maxMana: p2ManaPool, handMax: p2HandMax, handTurn: p2HandTurn, deck: p2Deck, speedDice: new Dice() });
	p1.deck.shuffle(); p2.deck.shuffle();
	updateUI();
	document.getElementById('nextTurnRunBtn').disabled = false;
	console.log('Game started. Click Next Turn to advance.');
}

function nextTurn(){
	if (!p1 || !p2) return;
	// prevent double-clicking while a turn is running
	document.getElementById('nextTurnRunBtn').disabled = true;
	let winnerName = '';
	turn++;
	try {
		console.log(`\n--- Running turn ${turn} ---`);
		// Prepare the turn (restore mana and draw) and show the hand-before-play
		const startRes = startTurn(p1, p2);
		updateUI({ beforeA: startRes.beforeA, beforeB: startRes.beforeB });
		// Now run the play phase; pass false so runTurn does not call startTurn again
		console.log('Rolling speed check to see who goes first.');
		is_p1_faster = isP1Faster(p1, p2, 0);
		firstPlayer = p1;
		secondPlayer = p2;
		if (!is_p1_faster){
			firstPlayer = p2;
			secondPlayer = p1;
		}
		console.log(firstPlayer.name + ' goes first.');
		const result = runTurn(firstPlayer, secondPlayer) || {};
		updateUI({ playedA: is_p1_faster ? result.played : [], playedB: is_p1_faster ? [] : result.played, beforeA: startRes.beforeA, beforeB: startRes.beforeB });
		winnerName = checkHP_0(p1, p2, false);
		if (!winnerName){
			console.log(secondPlayer.name + ' goes second.');
			const result2 = runTurn(secondPlayer, firstPlayer) || {};
			updateUI({ playedA: is_p1_faster ? result.played : result2.played, playedB: is_p1_faster ? result2.played : result.played, beforeA: startRes.beforeA, beforeB: startRes.beforeB });
			checkHP_0(p1, p2, true);
		}
	} catch (err) {
		console.error(err);
		console.log('An error occurred running the turn; Next Turn re-enabled.');
		document.getElementById('nextTurnRunBtn').disabled = false;
	}
}

function isP1Faster(p1, p2, iteration = 0){
	p1Spd = p1.speedDice.roll();
	p2Spd = p2.speedDice.roll();
	if (p1Spd == p2Spd){
		return isP1Faster(p1, p2, iteration + 1)
	}
	else{
		console.log('p1Spd: ' + p1Spd.toString());
		console.log('p2Spd: ' + p2Spd.toString());
		return p1Spd > p2Spd;
	}
}

function checkHP_0(p1, p2, turnEnd = false){
	// If a character reached 0 HP, end the game in the UI
	let msg;
	let winnerName = '';
	if (p1.health === 0 || p2.health === 0) {
		
		if (p1.health === 0 && p2.health === 0) {
			msg = 'Both players have fallen — draw';
			winnerName = 'Draw';
		}
		else if (p1.health === 0) {
			msg = `${p2.name} wins!`;
			winnerName = p2.name;
		}
		else {
			msg = `${p1.name} wins!`;
			winnerName = p1.name;
		}
		console.log(msg);
		document.getElementById('nextTurnRunBtn').disabled = true;
	} else {
		// re-enable button after turn completes
		if (turnEnd) document.getElementById('nextTurnRunBtn').disabled = false;
	}

	return winnerName;
}

function resetGame(){
	location.reload();
}

document.getElementById('startBtn').addEventListener('click', startGame);
document.getElementById('nextTurnRunBtn').addEventListener('click', nextTurn);
// document.getElementById('resetBtn').addEventListener('click', resetGame);

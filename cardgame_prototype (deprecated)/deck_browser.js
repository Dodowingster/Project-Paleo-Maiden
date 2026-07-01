// deck_browser.js - Logic for the deck browser UI.

function makeCardEl(c) {
    const div = document.createElement('div');
    const colorClass = c && c.color ? ('card-' + c.color.replace(/[^a-z0-9\-]/gi, '').toLowerCase()) : 'card-colourless';
    div.className = 'card ' + colorClass;
    const title = document.createElement('div');
    title.className = 'title';
    title.textContent = c.name || '<anon>';
    const meta = document.createElement('div');
    meta.className = 'meta';
    meta.textContent = `${c.manaCost} Mana • ${c.color}`;
    
    const effectsContainer = document.createElement('div');
    effectsContainer.className = 'meta';

    // Create temporary card instance to get effect descriptions
    const cardInstance = new Card(c);

    if (Array.isArray(cardInstance.effects) && cardInstance.effects.length > 0) {
        for (const eff of cardInstance.effects) {
            let desc = null;
            if (eff && typeof eff.description === 'string') desc = eff.description;
            else if (eff && typeof eff.toString === 'function' && eff.toString !== Object.prototype.toString) desc = eff.toString();
            else if (typeof eff === 'function') desc = '<custom function effect>';
            else desc = '<unknown effect>';
            const p = document.createElement('div');
            p.textContent = desc;
            effectsContainer.appendChild(p);
        }
    } else {
        effectsContainer.textContent = 'No effects';
    }
    div.appendChild(title);
    div.appendChild(effectsContainer);
    div.appendChild(meta);
    return div;
}

function displayDeck(deckName) {
    const cardDisplay = document.getElementById('cardDisplay');
    cardDisplay.innerHTML = '';

    if (!deckName || !globalThis.playerDecks[deckName]) return;

    const cardNames = globalThis.playerDecks[deckName];
    for (const cardName of cardNames) {
        const template = globalThis.cardCollection.find(c => c.name === cardName);
        if (template) {
            cardDisplay.appendChild(makeCardEl(template));
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const deckSelector = document.getElementById('deckSelector');
    const deckNames = Object.keys(globalThis.playerDecks);

    for (const name of deckNames) {
        const option = document.createElement('option');
        option.value = name;
        option.textContent = name;
        deckSelector.appendChild(option);
    }

    deckSelector.addEventListener('change', (event) => displayDeck(event.target.value));
});
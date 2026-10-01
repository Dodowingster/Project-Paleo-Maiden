// deck_data.js - Predefined decklists for players.

if (typeof globalThis === 'undefined') {
    var globalThis = window;
}

globalThis.playerDecks = {
    // A balanced deck with a mix of attack and healing.
    'starterDeckA': [
        'Strike', 'Strike', 'Strike',
        'Slash', 'Slash',
        'Minor Heal', 'Minor Heal',
        'Second Wind',
        'Jab', 'Jab',
        'Smash',
        'Crush'
    ],
    // An aggressive, red-focused deck.
    'starterDeckB': [
        'Strike', 'Strike',
        'Slash', 'Slash', 'Slash',
        'Fireblast',
        'Jab', 'Jab', 'Jab',
        'Smash', 'Smash', 'Crush'
    ]
};
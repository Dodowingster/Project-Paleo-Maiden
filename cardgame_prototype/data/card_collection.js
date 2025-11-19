// card_collection.js - A central library of all available card templates.

if (typeof globalThis === 'undefined') {
    var globalThis = window;
}

globalThis.cardCollection = [
	{ name: 'Strike', manaCost: 1, effects: () => [new DamageEffect(2)], color: 'red' },
	{ name: 'Slash', manaCost: 2, effects: () => [new DamageEffect(3)], color: 'red' },
	{ name: 'Minor Heal', manaCost: 1, effects: () => [ new HealEffect(1, 'caster') ], color: 'colourless' },
	{ name: 'Fireblast', manaCost: 3, effects: () => [new DamageEffect(6)], color: 'red' },
	{ name: 'Jab', manaCost: 1, effects: () => [new DamageEffect(1)], color: 'red' },
	{ name: 'Smash', manaCost: 2, effects: () => [new DamageEffect(4)], color: 'red' },
	{ name: 'Second Wind', manaCost: 1, effects: () => [ new HealEffect(2, 'caster') ], color: 'colourless' },
	{ name: 'Crush', manaCost: 2, effects: () => [new DamageEffect(3)], color: 'red' },
];
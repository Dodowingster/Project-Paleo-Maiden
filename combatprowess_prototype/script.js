document.addEventListener('DOMContentLoaded', () => {
    // --- CHARACTER DATA ---
    const CHARACTERS = [
        {
            name: "Tyran Rex",
            discipline: "Brute",
            innateSecretArt: "Tyrant Divider",
            // Assuming you'll have profile pages later based on the character_designs folder
            profileUrl: "../character_designs/tyran-rex.html",
            image: "../character_designs/tyrannosaurus_rex/Mugshot.png"
        },
        {
            name: "Kitadani Fukuira",
            discipline: "Focus",
            innateSecretArt: "Kime-Dachi, Senkō Sen!",
            profileUrl: "../character_designs/kitadani-fukuira.html",
            image: "../character_designs/fukuiraptor/Mugshot.png"
        },
        {
            name: "Sastrei Taurus",
            discipline: "Flow",
            innateSecretArt: "Sastrei Carnage",
            profileUrl: "../character_designs/sastrei-taurus.html",
            image: "../character_designs/carnotaurus/Mugshot.png"
        },
        {
            name: "Aegypt Spino",
            discipline: "Focus",
            innateSecretArt: "A Sight to behold!",
            profileUrl: "../character_designs/aegypt-spino.html",
            image: "../character_designs/spinosaurus/placeholder.png"
        }
    ];

    // --- DOM ELEMENTS ---
    const techniqueList = document.getElementById('technique-list');
    const paleoArtsSlots = document.getElementById('paleo-arts-slots');
    const secretArtsSlots = document.getElementById('secret-arts-slots');
    const hybridArtContainer = document.getElementById('hybrid-art-container');
    const detailsContent = document.getElementById('details-content');
    const characterListEl = document.getElementById('character-list');
    const BASE_PALEO_SLOTS = 5;
    const tacticalOrderButtons = document.querySelectorAll('.tactical-order-btn');
    const combatProwessPanel = document.getElementById('combat-prowess');
    const BASE_SECRET_SLOTS = 2;

    // By embedding the data directly, we avoid CORS errors when running the file locally.
    const PALEOARTS_DATA = [
        {
            "name": "Ram",
            "type": "Paleo Art",
            "discipline": "Brute",
            "tags": [
                "Attack",
                "Snapback"
            ],
            "cooldown": 10,
            "activation": "distance_to_opponent <= 0lengths",
            "description": "A straightforward, powerful blow that can push the opponent back",
            "effect": "Strikes the opponent for moderate damage and pushes them back 2 lengths."
        },
        {
            "name": "Rush",
            "type": "Paleo Art",
            "discipline": "Brute",
            "tags": [
                "Movement"
            ],
            "cooldown": 6,
            "activation": "distance_to_opponent > 2lengths",
            "description": "Rushes towards the opponent to close the gap quickly.",
            "effect": "Moderately increases movement speed for this turn."
        },
        {
            "name": "Pummel",
            "type": "Paleo Art",
            "discipline": "Brute",
            "tags": [
                "Attack",
                "Stun"
            ],
            "cooldown": 12,
            "activation": "distance_to_opponent <= 0lengths",
            "description": "Blunt strike that stuns the opponent for a short duration.",
            "effect": "Slightly stuns the opponent, leaving them wide open for follow-up attacks."
        },
        {
            "name": "Aura Farm",
            "type": "Paleo Art",
            "discipline": "Brute",
            "tags": [
                "Concentration",
                "Buff"
            ],
            "cooldown": 18,
            "activation": "distance_to_opponent > 2lengths OR tactical_order == 'Defensive' OR tactical_order == 'Balanced'",
            "description": "A state of intense concentration that riles up the crowd",
            "effect": "Next Paelo/Secret Art gains Significantly increased damage."
        },
        {
            "name": "Retaliation",
            "type": "Paleo Art",
            "discipline": "Brute",
            "tags": [
                "Concentration",
                "Defense",
                "Parry"
            ],
            "cooldown": 15,
            "activation": "activation_chance == 70% WHEN opponent_attacks",
            "description": "Tank a hit and retaliate with a powerful counterattack.",
            "effect": "Upon successfully blocking an attack, immediately counter with a strong strike that deals moderate damage."
        },
        {
            "name": "Tyrant Divider",
            "type": "Secret Art",
            "discipline": "Brute",
            "tags": [
                "Movement",
                "Attack",
                "Heavy"
            ],
            "cooldown": 40,
            "activation": "match_time > 10 seconds OR distance_to_opponent > 2 lengths",
            "activation_offensive": "match_time > 5 seconds OR distance_to_opponent > 1 length",
            "activation_defensive": "match_time > 20 seconds OR opponent_is_attacking",
            "description": "Tyran Rex's Signtaure Secret Art. Drags the sword and rush for a devasting upward slash.",
            "effect": "Greatly reduces opponent's health."
        },
        {
            "name": "Deinos Reaper",
            "type": "Ancient Art",
            "discipline": "Brute",
            "tags": [
                "Movement",
                "Attack",
                "Heavy"
            ],
            "jobRequirement": "Tyrant King",
            "cooldown": 50,
            "characterRequirement": "Tyran Rex",
            "activation": "Requires 'Tyrant King' Vocation. Activates when distance_to_opponent <= 0 lengths.",
            "description": "Tyrant King Exclusive. A devastating charge that culminates in a massive overhead slash, cleaving through defenses with overwhelming power.",
            "effect": "Greatly reduces opponent's health."
        },
        {
            "name": "Glory to the King",
            "type": "Ancient Art",
            "discipline": ["Brute", "Focus"],
            "tags": [
                "Movement",
                "Attack",
                "Heavy"
            ],
            "jobRequirement": "Mystic Spearhand",
            "cooldown": 55,
            "characterRequirement": "Tyran Rex",
            "activation": "Requires 'Mystic Spearhand' Vocation. Activates when distance_to_opponent >= 2 lengths AND match_time > 10 seconds.",
            "description": "Mystic Spearhand Exclusive. Channels P-Magic into a spear thrust that pierces through multiple dimensions, striking the opponent from afar with unerring accuracy and devastating force.",
        },
        {
            "name": "Energy Wave",
            "type": "Paleo Art",
            "discipline": "Focus",
            "tags": [
                "Projectile",
                "Attack"
            ],
            "cooldown": 9,
            "activation": "distance_to_opponent > 2lengths",
            "description": "Unleashes a focused energy blast towards the opponent.",
            "effect": "Deals moderate damage from a distance."
        },
        {
            "name": "Foresight Strike",
            "type": "Paleo Art",
            "discipline": "Focus",
            "tags": [
                "Parry",
                "Attack",
                "Snapback"
            ],
            "cooldown": 12,
            "activation": "opponent_attacks WITHIN 1lengths",
            "description": "A precise strike that anticipates and counters the opponent's move.",
            "effect": "If timed correctly, parries the incoming attack and counterattacks for moderate damage, pushing the opponent back 1 length."
        },
        {
            "name": "Guard",
            "type": "Paleo Art",
            "discipline": "Focus",
            "tags": [
                "Defense"
            ],
            "cooldown": 7,
            "activation": "always_available",
            "description": "A solid defensive stance to weather an incoming blow.",
            "effect": "Reduces incoming damage from the next hit."
        },
        {
            "name": "Arcane Shield",
            "type": "Paleo Art",
            "discipline": "Focus",
            "tags": [
                "Defense",
                "Buff"
            ],
            "cooldown": 20,
            "activation": "tactical_order == 'Defensive'",
            "description": "Summon a barrier of P-Magic to absorb damage.",
            "effect": "Grants a temporary shield that absorbs a moderate amount of damage. Lasts until broken."
        },
        {
            "name": "Meditate",
            "type": "Paleo Art",
            "discipline": "Focus",
            "tags": [
                "Buff",
                "Heal",
                "Concentration"
            ],
            "cooldown": 22,
            "activation": "distance_to_opponent > 3lengths",
            "description": "Center your mind to mend your focus.",
            "effect": "Recovers a small amount of P-Magic (Health) over a short duration and increases next Paleo/Secret Art damage slightly."
        },
        {
            "name": "A Sight to behold!",
            "type": "Secret Art",
            "discipline": "Focus",
            "tags": [
                "Movement",
                "Defense",
                "Attack"
            ],
            "cooldown": 45,
            "activation": "match_time > 10 seconds AND distance_to_opponent > 2 lengths OR (activation_chance == 80% AND (area_effect == 'Water' OR environment == 'Rainy'))",
            "activation_offensive": "distance_to_opponent > 1 length OR (activation_chance == 90% AND (area_effect == 'Water' OR environment == 'Rainy'))",
            "activation_defensive": "opponent_is_attacking AND distance_to_opponent > 2 lengths OR (activation_chance == 70% AND (area_effect == 'Water' OR environment == 'Rainy'))",
            "description": "Aegypt Spino's Signtaure Secret Art. Pierce the opponent with a swift strike from a distance.",
            "effect": "Greatly reduces opponent's health and Defense for a short duration."
        },
        {
            "name": "Kime-Dachi, Senkō Sen!",
            "type": "Secret Art",
            "discipline": "Focus",
            "tags": [
                "Attack",
                "Chain",
                "Heavy"
            ],
            "cooldown": 60,
            "chain_requirements": [
                "Concentration",
                "Heavy",
                "Defense"
            ],
            "activation": "Has a low chance to activate randomly when chain conditions are not met.",
            "activation_offensive": "Has a slightly higher chance to activate randomly when chain conditions are not met.",
            "activation_defensive": "Will not activate randomly. Only activates via chain requirements.",
            "description": "Kitadani Fukuira's Signature Secret Art. After achieving a state of perfect focus, unleash a flurry of 1000 slashes in a single, blindingly fast draw.",
            "effect": "Deals massive, unavoidable damage to the opponent."
        },
        {
            "name": "Strike",
            "type": "Paleo Art",
            "discipline": "Flow",
            "tags": [
                "Attack",
                "Crumple",
                "Fatal",
                "Chain"
            ],
            "chain_requirements": [
                "Dodge"
            ],
            "cooldown": 8,
            "activation": "distance_to_opponent <= 1lengths",
            "description": "A single forward advancing attack to close the distance.",
            "effect": "Closes the gap and deals slighlty more damage. Crumples the opponents if they whiffed an attack."
        },
        {
            "name": "Weave",
            "type": "Paleo Art",
            "discipline": "Flow",
            "tags": [
                "Swift",
                "Dodge",
                "Chain"
            ],
            "cooldown": 10,
            "activation": "50% chance when opponent is attacking within 1 length",
            "description": "Weave backwards to evade an incoming attack by 1 length.",
            "effect": "Chain: Has a 90% chance to immediately activate an 'Attack' technique from a Paleo Art slot after successful dodge."
        },
        {
            "name": "Pounce",
            "type": "Paleo Art",
            "discipline": "Flow",
            "tags": [
                "Attack",
                "Swift",
                "Movement",
            ],
            "cooldown": 9,
            "activation": "distance_to_opponent <= 1length",
            "description": "Jump forward swiftly to strike the opponent.",
            "effect": "Deals moderate damage with increased speed."
        },
        {
            "name": "Killrush",
            "type": "Paleo Art",
            "discipline": "Flow",
            "tags": [
                "Swift",
                "Movement",
                "Chain"
            ],
            "cooldown": 14,
            "activation": "distance_to_opponent > 2lengths",
            "description": "Rush forward swiftly to close the distance by 2 lengths.",
            "effect": "Chain: Has a 90% chance to immediately activate an 'Attack' technique from a Paleo Art slot after successful dodge."
        },
        {
            "name": "Quick Step",
            "type": "Paleo Art",
            "discipline": "Flow",
            "tags": [
                "Movement"
            ],
            "cooldown": 5,
            "activation": "always_available",
            "description": "A sudden dash to reposition or evade.",
            "effect": "Performs a short, quick dash. Briefly increases evasion chance."
        },
        {
            "name": "Sastrei Carnage",
            "type": "Secret Art",
            "discipline": "Flow",
            "tags": [
                "Attack",
                "Movement",
                "Swift",
                "Heavy"
            ],
            "cooldown": 35,
            "activation": "match_time > 10 seconds AND distance_to_opponent <= 0 lengths",
            "activation_offensive": "match_time > 5 seconds AND distance_to_opponent <= 1 length",
            "activation_defensive": "health < 50% AND distance_to_opponent <= 0 lengths",
            "description": "Sastrei Taurus's Signature Secret Art. A multi-hit flurry of punches culminating in a devastating uppercut.",
            "effect": "Deals devastatingly high damage."
        },
        {
            "name": "Diacera Hellion",
            "type": "Ancient Art",
            "discipline": ["Flow", "Focus"],
            "tags": [
                "Attack",
                "Movement",
                "Swift",
                "Heavy"
            ],
            "jobRequirement": "Boxing Magus",
            "cooldown": 50,
            "characterRequirement": "Sastrei Taurus",
            "activation": "Requires 'Boxing Magus' Vocation. Activates when distance_to_opponent <= 0 lengths.",
            "description": "Boxing Magus Exclusive. A catastrophic initial blow sends the opponent flying, then engages Light-Speed Pursuit, chasing them down from multiple vectors with impossible velocity, culminating in a powerful, screen-shattering uppercut.",
            "effect": "Deals a rapid series of moderate damage hits, then finishes with a single heavy damage strike."
        },
        {
            "name": "Stone Skin",
            "type": "Paleo Art",
            "discipline": "Control",
            "tags": [
                "Defense",
                "Buff"
            ],
            "cooldown": 25,
            "activation": "tactical_order == 'Defensive'",
            "description": "Harden the body to become as resilient as rock.",
            "effect": "Temporarily reduces all incoming damage by a small amount."
        },
        {
            "name": "Taunt",
            "type": "Paleo Art",
            "discipline": "Control",
            "tags": [
                "Buff"
            ],
            "cooldown": 16,
            "activation": "distance_to_opponent <= 2lengths",
            "description": "Goad the opponent into making a reckless move.",
            "effect": "Forces the opponent to use only attack-based moves on their next turn, lowering their defense."
        },
        {
            "name": "Shatter",
            "type": "Paleo Art",
            "discipline": "Control",
            "tags": [
                "Attack",
                "Heavy",
                "Crumple"
            ],
            "cooldown": 18,
            "activation": "distance_to_opponent <= 1length",
            "description": "A powerful strike aimed at breaking through defenses.",
            "effect": "Deals heavy damage and has a chance to crumple the opponent, leaving them vulnerable."
        },
        {
            "name": "Battlecry",
            "type": "Paleo Art",
            "discipline": "Control",
            "tags": [
                "Buff",
                "Stun"
            ],
            "cooldown": 15,
            "activation": "distance_to_opponent <= 1length",
            "description": "A deafening roar that disorients the foe.",
            "effect": "Chain: Has a 70% chance to immediately activate a 'Snapback' technique from any Art slot after successful use."
        },
        {
            "name": "Grounded Stance",
            "type": "Paleo Art",
            "discipline": "Control",
            "tags": [
                "Defense",
                "Parry",
            ],
            "cooldown": 14,
            "activation": "activation_chance == 60% WHEN opponent_attacks within 0 lengths",
            "description": "A sturdy, low stance designed to trip up and immobilize fast-moving attackers.",
            "effect": "Upon successful block, the opponent is briefly Bound (cannot use Movement skills) for their next turn."
        },
        {
            "name": "Dicrae Style - Twin Crest Fang",
            "type": "Secret Art",
            "discipline": "Control",
            "tags": [
                "Snapback",
                "Chain",
                "Parry",
                "Defense"
            ],
            "cooldown": 40,
            "activation": "match_time > 10 seconds AND activation_chance == 100% WHEN opponent_attacks",
            "activation_offensive": "match_time > 5 seconds AND activation_chance == 80% WHEN opponent_attacks",
            "activation_defensive": "activation_chance == 100% WHEN opponent_attacks",
            "description": "Caza Amarga's Signature Secret Art. A defensive maneuver that parries an incoming attack and retaliates with a crushing counterstrike.",
            "effect": "Greatly reduces opponent's health upon successful parry."
        }
    ];

    let techniques = [];
    let selectedCharacter = null;
    let draggedItem = null;
    let currentlyDisplayedTech = null; // To keep track of the tech in the details panel
    let characterLoadouts = {}; // To store loadouts for each character
    let currentTacticalOrder = 'Balanced'; // Default order

    // --- Create a single tooltip element to be reused ---
    const skillTooltip = document.createElement('div');
    skillTooltip.className = 'skill-tooltip';
    document.body.appendChild(skillTooltip);

    // Load techniques from the embedded data
    techniques = PALEOARTS_DATA;
    createCharacterList();
    createFilterBar();
    initializeTacticalOrders();
    createClearLoadoutButton();

    // Select the first character by default
    selectCharacter(CHARACTERS[0]);

    function initializeTacticalOrders() {
        tacticalOrderButtons.forEach(button => {
            button.addEventListener('click', () => {
                // Remove active class from all buttons
                tacticalOrderButtons.forEach(btn => btn.classList.remove('active'));
                // Add active class to the clicked one
                button.classList.add('active');
                // Update the state
                currentTacticalOrder = button.dataset.order;

                // If a technique's details are currently being shown, refresh them
                if (currentlyDisplayedTech) {
                    showDetails(currentlyDisplayedTech, false); // Pass true to skip animation
                    showDetails(currentlyDisplayedTech); // Refresh details with animation
                }
            });
        });
    }

    function createClearLoadoutButton() {
        const header = combatProwessPanel.querySelector('h2');
        const clearButton = document.createElement('button');
        clearButton.id = 'clear-loadout-btn';
        clearButton.textContent = 'Clear Loadout';
        clearButton.title = 'Return all equipped arts to the list';

        // Insert the button right after the 'Combat Prowess' heading
        header.insertAdjacentElement('afterend', clearButton);

        clearButton.addEventListener('click', () => {
            const paleoArtsItems = [...paleoArtsSlots.children];
            const secretArtsItems = [...secretArtsSlots.children].filter(item => !item.classList.contains('innate'));
            const itemsToClear = [...paleoArtsItems, ...secretArtsItems];

            if (itemsToClear.length === 0) return; // Do nothing if there's nothing to clear

            // Apply the disintegration animation to each item
            itemsToClear.forEach((item, index) => {
                item.classList.add('disintegrating');
                // Add a slight delay for a staggered, more chaotic effect
                item.style.animationDelay = `${index * 40}ms`;
            });

            // Wait for the last animation to finish before removing the elements
            const lastItem = itemsToClear[itemsToClear.length - 1];
            lastItem.addEventListener('animationend', () => {
                // Now, remove all the cleared items from the DOM
                itemsToClear.forEach(item => {
                    if (item.parentElement) {
                        item.parentElement.removeChild(item);
                    }
                });

                // Refresh the technique list and update the job/slot counts
                populateTechniqueList(techniques);
                updateJobEvolution();
            }, { once: true });
        });
    }

    function createFilterBar() {
        const listContainer = document.getElementById('technique-list-container');
        const filterContainer = document.createElement('div');
        filterContainer.id = 'filter-bar';
        filterContainer.style.marginBottom = '1rem';

        const disciplines = ['All', 'Brute', 'Focus', 'Flow', 'Control'];
        disciplines.forEach(discipline => {
            const button = document.createElement('button');
            button.textContent = discipline;
            button.dataset.filter = discipline;
            button.className = `filter-btn ${discipline}`;
            button.addEventListener('click', (e) => {
                // Remove active class from all filter buttons
                document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
                // Add active class to the clicked button
                e.currentTarget.classList.add('active');
                filterTechniques(discipline)
            });
            filterContainer.appendChild(button);
        });

        // Insert the filter bar before the technique list
        listContainer.insertBefore(filterContainer, techniqueList);
    }

    // Set 'All' as active by default
    document.querySelector('.filter-btn.All').classList.add('active');

    function filterTechniques(discipline) {
        // Start the fade-out animation
        techniqueList.classList.add('list-fade-out');

        techniqueList.addEventListener('animationend', function handleFadeOut() {
            // Clean up the listener
            techniqueList.removeEventListener('animationend', handleFadeOut);

            // Filter the techniques
            let filteredTechniques;
            if (discipline === 'All') {
                filteredTechniques = techniques;
            } else {
                filteredTechniques = techniques.filter(tech =>
                    tech.discipline === discipline || (Array.isArray(tech.discipline) && tech.discipline.includes(discipline))
                );
            }

            // Repopulate the list with new content
            populateTechniqueList(filteredTechniques);

            // Start the fade-in animation
            techniqueList.classList.replace('list-fade-out', 'list-fade-in');
        }, { once: true });
    }

    function populateTechniqueList(techsToDisplay) {
        techniqueList.innerHTML = ''; // Clear existing list

        // Get the names of all currently equipped techniques to prevent duplication
        const equippedItems = [
            ...paleoArtsSlots.children,
            ...secretArtsSlots.children,
            ...document.getElementById('hybrid-art-slot').children
        ];
        const equippedTechNames = new Set(Array.from(equippedItems).map(item => item.dataset.techName));

        // Filter out exclusive job skills that shouldn't be manually selectable
        const availableTechs = techsToDisplay.filter(tech => tech.type !== "Ancient Art" && !equippedTechNames.has(tech.name));

        availableTechs.forEach(tech => {
            const item = createTechniqueElement(tech);
            techniqueList.appendChild(item);
        });
    }

    function createTechniqueElement(tech) {
        const item = document.createElement('li');
        // Add a specific class for Secret Arts to style them differently
        const typeClass = tech.type.toLowerCase().replace(/\s+/g, '-'); // e.g., 'secret-art', 'hybrid-ancient-art'

        // Handle single or multiple disciplines for class names
        const disciplineClasses = Array.isArray(tech.discipline)
            ? tech.discipline.join(' ')
            : tech.discipline;

        item.className = `technique-item ${disciplineClasses} ${typeClass}`;
        item.textContent = tech.name;
        item.draggable = true;
        item.dataset.techName = tech.name;

        // Add stars for Secret and Ancient Arts
        if (tech.type === 'Secret Art' || tech.type === 'Ancient Art') {
            const starsContainer = document.createElement('div');
            starsContainer.className = 'art-stars';
            const starCount = tech.type === 'Ancient Art' ? 3 : 2;
            starsContainer.setAttribute('data-star-count', starCount);
            for (let i = 0; i < starCount; i++) {
                const star = document.createElement('span');
                star.textContent = '★';
                starsContainer.appendChild(star);
            }
            item.appendChild(starsContainer);
        }

        // Special styling for hybrid arts based on their disciplines
        if (Array.isArray(tech.discipline) && tech.discipline.length === 2) {
            // Sort to ensure class is consistent (e.g., flow-focus is same as focus-flow)
            const sortedDisciplines = [...tech.discipline].sort();
            const hybridClass = `hybrid-${sortedDisciplines[0].toLowerCase()}-${sortedDisciplines[1].toLowerCase()}`;
            item.classList.add(hybridClass);
        }

        // Event listeners for the item
        item.addEventListener('click', () => showDetails(tech));
        item.addEventListener('dragstart', handleDragStart);
        item.addEventListener('dragend', handleDragEnd);
        // --- Tooltip Listeners ---
        item.addEventListener('mouseenter', (e) => handleShowTooltip(e, tech));
        item.addEventListener('mousemove', handleMoveTooltip);
        item.addEventListener('mouseleave', handleHideTooltip);

        return item;
    }

    function createCharacterList() {
        CHARACTERS.forEach(char => {
            const charCard = document.createElement('div');
            charCard.className = 'character-card';
            charCard.dataset.charName = char.name;
            charCard.innerHTML = `
                <img src="${char.image}" alt="${char.name}">
                <strong class="character-name">${char.name}</strong>
                <p class="character-job-title"></p>
            `;
            charCard.addEventListener('click', () => selectCharacter(char));
            characterListEl.appendChild(charCard);
        });
    }

    function selectCharacter(character) {
        // --- 1. Save the current character's loadout before switching ---
        if (selectedCharacter) {
            // Don't save innate arts, they are added automatically.
            const currentPaleoArts = Array.from(paleoArtsSlots.children).map(item => item.dataset.techName);
            const currentSecretArts = Array.from(secretArtsSlots.children)
                .filter(item => !item.classList.contains('innate'))
                .map(item => item.dataset.techName);

            characterLoadouts[selectedCharacter.name] = {
                paleoArts: currentPaleoArts,
                secretArts: currentSecretArts,
            };
        }

        selectedCharacter = character;

        // Update visual selection
        document.querySelectorAll('.character-card').forEach(card => {
            const isSelected = card.dataset.charName === character.name;
            card.classList.toggle('selected', isSelected);

            // If a card is not the selected one, reset its job title to "Maiden"
            if (!isSelected) {
                const jobTitleEl = card.querySelector('.character-job-title');
                jobTitleEl.textContent = 'Maiden';
                jobTitleEl.classList.remove('job-active');
                jobTitleEl.style.backgroundImage = 'none';
            }
        });

        // Clear existing slots
        paleoArtsSlots.innerHTML = '';
        secretArtsSlots.innerHTML = '';
        hybridArtContainer.querySelector('ul').innerHTML = ''; // Clear the ancient art slot

        // --- 3. Load the new character's loadout ---
        const loadout = characterLoadouts[character.name] || { paleoArts: [], secretArts: [] };

        // Load Paleo Arts
        loadout.paleoArts.forEach(techName => {
            const tech = techniques.find(t => t.name === techName);
            if (tech) paleoArtsSlots.appendChild(createTechniqueElement(tech));
        });

        // Load Secret Arts
        loadout.secretArts.forEach(techName => {
            const tech = techniques.find(t => t.name === techName);
            if (tech) secretArtsSlots.appendChild(createTechniqueElement(tech));
        });

        // --- 4. Always add the character's innate Secret Art ---
        const innateArt = techniques.find(t => t.name === character.innateSecretArt);
        if (innateArt) {
            const item = createTechniqueElement(innateArt);
            item.draggable = false; // Innate art cannot be moved
            item.classList.add('innate');
            // Add to the start of the list for consistency
            secretArtsSlots.prepend(item);

            // --- Animate the newly added innate art ---
            const disciplineColor = `var(--color-${innateArt.discipline.toLowerCase()})`;
            item.style.setProperty('--glow-color', disciplineColor);
            item.style.animation = 'art-glow-pulse 0.8s ease-in-out';

            // Clean up the animation styles after it finishes
            item.addEventListener('animationend', () => {
                item.style.animation = '';
                item.style.removeProperty('--glow-color');
            }, { once: true });
        }

        populateTechniqueList(techniques);
        updateJobEvolution();
    }

    let isDetailsUpdating = false; // Flag to prevent animation conflicts
    function showDetails(tech, skipAnimation = false) {
        if (isDetailsUpdating && !skipAnimation) return; // Don't start a new animation if one is running
        if (isDetailsUpdating) return; // Don't start a new animation if one is running
        isDetailsUpdating = true;
        currentlyDisplayedTech = tech; // Store the currently displayed tech

        // 1. Start the fade-out animation
        detailsContent.classList.remove('details-fade-in');
        detailsContent.classList.remove('details-fade-in'); // Always remove fade-in
        detailsContent.classList.add('details-fade-out');

        // 2. Wait for the fade-out to finish, then update content and fade in
        detailsContent.addEventListener('animationend', function handleFadeOut() {
            // This listener should only run once
            detailsContent.removeEventListener('animationend', handleFadeOut);

            // Make content invisible while we update it
            detailsContent.classList.add('is-updating');

            const TAG_COLORS = {
                // Red/Brute Discipline
                'Attack': '#dc3545', 'Stun': '#dc3545', 'Heavy': '#dc3545',

                // Green/Flow Discipline
                'Movement': '#28a745', 'Dodge': '#28a745', 'Swift': '#28a745',

                // Blue/Focus Discipline
                'Buff': '#007bff', 'Concentration': '#007bff', 'Projectile': '#007bff',

                // Yellow/Control Discipline
                'Defense': '#ffc107', 'Heal': '#ffc107', 'Parry': '#ffc107',

                // Universal/Other Tags
                'Chain': '#17a2b8', 'Snapback': '#17a2b8', 'Crumple': '#17a2b8', 'Fatal': '#17a2b8'
            };

            // --- Tactical Order Logic ---
            let activationText = tech.activation; // Default to balanced
            if (currentTacticalOrder === 'Offensive' && tech.activation_offensive) {
                activationText = tech.activation_offensive;
            } else if (currentTacticalOrder === 'Defensive' && tech.activation_defensive) {
                activationText = tech.activation_defensive;
            }
            // Add a class to the activation block based on the current order
            const orderClass = `order-${currentTacticalOrder.toLowerCase()}`;

            // SVG Icons
            const stopwatchIcon = `<svg class="details-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 21C16.9706 21 21 16.9706 21 12C21 7.02944 16.9706 3 12 3C7.02944 3 3 7.02944 3 12C3 16.9706 7.02944 21 12 21Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M12 6V12L16 14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M10 1H14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
            const flagIcon = `<svg class="details-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4 15C4 15 5 14 8 14C11 14 13 16 16 16C19 16 20 15 20 15V3C20 3 19 4 16 4C13 4 11 2 8 2C5 2 4 3 4 3V15Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 22V15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>`;

            const activationHtml = activationText
                ? `<div class="activation-details ${orderClass}"><p><strong>${flagIcon} Activation (${currentTacticalOrder}):</strong><br> ${activationText}</p></div>`
                : '';

            // --- Title Glow for Rare Arts ---
            let titleClass = '';
            let titleStyle = '';
            if (tech.type === 'Secret Art' || tech.type === 'Ancient Art') {
                titleClass = 'glowing-title';
                // Use the first discipline for the glow color in case of hybrids
                const discipline = Array.isArray(tech.discipline) ? tech.discipline[0] : tech.discipline;
                const disciplineColor = `var(--color-${discipline.toLowerCase()})`;
                titleStyle = `style="--glow-color: ${disciplineColor}"`;
            }

            const chainActivationHtml = tech.chain_requirements && tech.chain_requirements.length > 0
                ? `<p><strong class="info-block">Guaranteed Activation:</strong> This technique is guaranteed to activate after using techniques with the following tags: ${tech.chain_requirements.map(tag =>
                    `<span style="color: ${TAG_COLORS[tag] || 'inherit'}; font-weight: bold;">${tag}</span>`
                ).join(', ')
                }.</p>`
                : '';

            const tagsHtml = tech.tags && tech.tags.length > 0
                ? `<p><strong>Tags:</strong> ${tech.tags.map(tag => `<span style="color: ${TAG_COLORS[tag] || 'inherit'}; font-weight: bold;">${tag}</span>`).join(', ')
                }</p>`
                : '';

            // --- Colored Discipline Text ---
            const disciplines = Array.isArray(tech.discipline) ? tech.discipline : [tech.discipline];
            const disciplineHtml = disciplines.map(d => {
                const colorVar = `var(--color-${d.toLowerCase()})`;
                return `<span style="color: ${colorVar}; font-weight: bold;">${d}</span>`;
            }).join(' / ');

            // Display as: [icon] 40s
            const cooldownHtml = tech.cooldown ? `<strong>Cooldown:</strong>\t${stopwatchIcon}${tech.cooldown}s` : '';

            // 3. Update the innerHTML with the new technique details
            detailsContent.innerHTML = `
            <h3 class="${titleClass}" ${titleStyle}>${tech.name}</h3>
            <p><strong>Type:</strong> ${tech.type}</p>
            <p><strong>Discipline:</strong> ${disciplineHtml}</p>
            ${cooldownHtml}
            ${tagsHtml}
            <p><strong class="info-block">Description:</strong> ${tech.description}</p>
            ${activationHtml}
            ${chainActivationHtml}
            <p><strong class="info-block">Effect:</strong> ${tech.effect}</p>
            `;

            // 4. Start the fade-in animation for the new content
            detailsContent.classList.remove('details-fade-out', 'is-updating');
            detailsContent.classList.add('details-fade-in');

            // Reset the flag after a short delay to allow the new animation to start
            setTimeout(() => { isDetailsUpdating = false; }, skipAnimation ? 0 : 50);

            // If skipping animation, immediately remove animation classes
            if (skipAnimation) {
                detailsContent.classList.remove('details-fade-in', 'details-fade-out');
            }
            setTimeout(() => { isDetailsUpdating = false; }, 300); // Match animation duration
        }, { once: true }); // {once: true} is a safer way to ensure the listener is auto-removed
    }

    // --- Tooltip Handlers ---
    function handleShowTooltip(e, tech) {
        const TAG_COLORS = {
            'Attack': '#dc3545', 'Stun': '#dc3545', 'Heavy': '#dc3545',
            'Movement': '#28a745', 'Dodge': '#28a745', 'Swift': '#28a745',
            'Buff': '#007bff', 'Concentration': '#007bff', 'Projectile': '#007bff',
            'Defense': '#ffc107', 'Heal': '#ffc107', 'Parry': '#ffc107',
            'Chain': '#17a2b8', 'Snapback': '#17a2b8', 'Crumple': '#17a2b8', 'Fatal': '#17a2b8'
        };

        const tagsHtml = tech.tags && tech.tags.length > 0
            ? `<div class="skill-tooltip-tags"><strong>Tags:</strong> ${tech.tags.map(tag =>
                `<span style="color: ${TAG_COLORS[tag] || 'inherit'}; font-weight: bold;">${tag}</span>`
            ).join(', ')}</div>`
            : '';

        const effectHtml = tech.effect
            ? `<div class="skill-tooltip-effect"><strong>Effect:</strong> ${tech.effect}</div>`
            : '';

        skillTooltip.innerHTML = `${tagsHtml}${effectHtml}`;

        // If there's no content, don't show the tooltip
        if (!tagsHtml && !effectHtml) return;

        handleMoveTooltip(e); // Position it initially
        skillTooltip.classList.add('visible');
    }

    function handleMoveTooltip(e) {
        // Use pageX/pageY to get coordinates relative to the document,
        // which accounts for page scrolling.
        const offsetX = 0;
        const offsetY = -1500;
        let x = e.pageX + offsetX;
        let y = e.pageY + offsetY;

        // Check if the tooltip goes off the right edge of the viewport.
        // window.innerWidth is the viewport width, window.scrollX is the horizontal scroll position.
        if (x + skillTooltip.offsetWidth > window.innerWidth + window.scrollX) {
            x = e.pageX - skillTooltip.offsetWidth - offsetX;
        }

        // Check if the tooltip goes off the bottom edge of the viewport.
        if (y + skillTooltip.offsetHeight > window.innerHeight + window.scrollY) {
            y = e.pageY - skillTooltip.offsetHeight - offsetY;
        }

        skillTooltip.style.transform = `translate(${x}px, ${y}px)`;
    }

    function handleHideTooltip() {
        skillTooltip.classList.remove('visible');
    }

    // Drag and Drop Handlers
    function handleDragStart(e) {
        draggedItem = e.target;
        setTimeout(() => {
            e.target.style.display = 'none';
        }, 0);
    }

    function handleDragEnd(e) {
        setTimeout(() => {
            if (draggedItem) {
                draggedItem.style.display = 'block';
                draggedItem = null;
            }
        }, 0);
    }

    function handleDragOver(e) {
        e.preventDefault();
    }

    function handleDragEnter(e) {
        if (e.target.classList.contains('slot-container')) {
            e.target.classList.add('drag-over');
        }
    }

    function handleDragLeave(e) {
        if (e.target.classList.contains('slot-container')) {
            e.target.classList.remove('drag-over');
        }
    }

    function handleDrop(e) {
        e.preventDefault();
        const dropZone = e.target.closest('.slot-container');
        if (!dropZone || !draggedItem) return;

        dropZone.classList.remove('drag-over');
        const techName = draggedItem.dataset.techName;
        const tech = techniques.find(t => t.name === techName);

        // Prevent innate arts from being dragged
        if (draggedItem.classList.contains('innate')) return;

        // Check if the skill is already equipped in any slot
        const isMovingFromSlot = draggedItem.parentElement.classList.contains('slot-container');
        if (!isMovingFromSlot) { // Only check for duplicates if adding a new skill from the list
            const allEquippedSlots = [...paleoArtsSlots.children, ...secretArtsSlots.children];
            const isAlreadyEquipped = allEquippedSlots.some(item => item.dataset.techName === techName);

            if (isAlreadyEquipped) {
                draggedItem.style.display = 'block'; // Make the original item visible again
                draggedItem = null;
                return; // Exit without adding the duplicate
            }
        }

        // Check if the drop is valid
        const isTargetingSlot = dropZone.classList.contains('slot-container');
        const isTargetingList = dropZone.id === 'technique-list-container';

        if (isTargetingSlot) {
            const slotType = dropZone.dataset.slotType;
            const maxSlots = parseInt(dropZone.dataset.maxSlots, 10);
            const currentSlots = dropZone.children.length;

            // A drop is valid if the tech type matches and there's space,
            // OR if we are just moving an item between slots (which doesn't add to the count).
            if (tech.type === slotType && currentSlots < maxSlots) {
                // Valid drop: Add the item to the new slot.
                if (draggedItem.parentElement !== techniqueList) {
                    draggedItem.parentElement.removeChild(draggedItem);
                }
                dropZone.appendChild(draggedItem);

                // Add a "pop" animation to the newly slotted item
                draggedItem.classList.add('item-slotted-animation');
                // Remove the class after the animation finishes to allow it to be re-triggered
                draggedItem.addEventListener('animationend', () => {
                    draggedItem.classList.remove('item-slotted-animation');
                }, { once: true });

                updateJobEvolution();
            } else {
                // Invalid drop: Flash the slot red to give feedback.
                dropZone.classList.add('invalid-drop');
                setTimeout(() => {
                    dropZone.classList.remove('invalid-drop');
                }, 400); // Duration must match the CSS animation
            }
        }
        // The handleDragEnd function will handle making the item visible again and clearing draggedItem.
    }

    function handleListDrop(e) {
        e.preventDefault();
        const dropZone = e.target.closest('#technique-list-container');
        if (!dropZone || !draggedItem) return;

        // If the item came from a slot, move it back to the list
        if (draggedItem.parentElement !== techniqueList) {
            draggedItem.parentElement.removeChild(draggedItem);
            // The list needs to be repopulated to ensure correct sorting and filtering
            populateTechniqueList(techniques);
            updateJobEvolution();

            // Find the returned item in the newly populated list and scroll to it
            const returnedItem = techniqueList.querySelector(`[data-tech-name="${draggedItem.dataset.techName}"]`);
            if (returnedItem) {
                returnedItem.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

                // Add a flash effect to make it easy to spot
                returnedItem.classList.add('item-returned-flash');
                setTimeout(() => {
                    returnedItem.classList.remove('item-returned-flash');
                }, 700); // Duration must match the CSS animation
            }
        }
    }

    // Add listeners to slot containers
    [paleoArtsSlots, secretArtsSlots].forEach(slot => {
        slot.addEventListener('dragover', handleDragOver);
        slot.addEventListener('dragenter', handleDragEnter);
        slot.addEventListener('dragleave', handleDragLeave);
        slot.addEventListener('drop', handleDrop);
    });

    // Add listeners to the main list container for returning items
    const listContainer = document.getElementById('technique-list-container');
    listContainer.addEventListener('dragover', handleDragOver);
    listContainer.addEventListener('dragenter', handleDragEnter);
    listContainer.addEventListener('dragleave', handleDragLeave);
    listContainer.addEventListener('drop', handleListDrop);

    function updateJobEvolution() {
        // --- JOB EVOLUTION LOGIC --- //
        // Paleo Arts and the character's Innate Secret Art contribute to job evolution.
        // Other manually-equipped Secret Arts and Ancient Arts do not.
        const equippedPaleoArts = [...paleoArtsSlots.children];
        const innateSecretArt = secretArtsSlots.querySelector('.innate');

        const contributingTechs = [...equippedPaleoArts];
        if (innateSecretArt) {
            contributingTechs.push(innateSecretArt);
        }

        const disciplineCounts = { Brute: 0, Focus: 0, Flow: 0, Control: 0 };

        contributingTechs.forEach(item => {
            const techName = item.dataset.techName;
            const tech = techniques.find(t => t.name === techName);
            if (tech) {
                const disciplines = Array.isArray(tech.discipline) ? tech.discipline : [tech.discipline];
                disciplines.forEach(d => {
                    if (disciplineCounts.hasOwnProperty(d)) {
                        disciplineCounts[d]++;
                    }
                });
            }
        }
        );

        // Job evolutions, with character-specific jobs listed before generic ones.
        const JOB_EVOLUTIONS = [
            // --- Character-Specific Hybrid Disciplines ---
            { name: "Boxing Magus", character: "Sastrei Taurus", req: { "Flow": 4, "Focus": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Mystic Spearhand", character: "Tyran Rex", req: { "Brute": 4, "Focus": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Shogunate Swordsman", character: "Kitadani Fukuira", req: { "Focus": 4, "Brute": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Hybrid Pirate", character: "Aegypt Spino", req: { "Focus": 4, "Control": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },

            // --- Character-Specific Single Disciplines ---
            { name: "Kinetic Boxer", character: "Sastrei Taurus", req: { "Flow": 5 }, bonusSlots: { "Paleo Art": 0, "Secret Art": 1 } },
            { name: "Tyrant King", character: "Tyran Rex", req: { "Brute": 5 }, bonusSlots: { "Paleo Art": 0, "Secret Art": 1 } },
            { name: "Iai Master", character: "Kitadani Fukuira", req: { "Focus": 5 }, bonusSlots: { "Paleo Art": 0, "Secret Art": 1 } },
            { name: "River Hunter", character: "Aegypt Spino", req: { "Focus": 5 }, bonusSlots: { "Paleo Art": 0, "Secret Art": 1 } },

            // --- Generic Hybrid Disciplines ---
            { name: "Rogue Hunter", req: { "Flow": 3, "Focus": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Geomancer", req: { "Brute": 3, "Focus": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Prowler", req: { "Flow": 3, "Control": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Spellblade", req: { "Flow": 3, "Brute": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Warden", req: { "Focus": 3, "Control": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Gladiator", req: { "Brute": 3, "Control": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Tactician", req: { "Control": 3, "Focus": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Chronomancer", req: { "Control": 3, "Flow": 2 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },

            // --- Generic Single Disciplines ---
            { name: "Barbarian", req: { "Brute": 5 }, bonusSlots: { "Paleo Art": 0, "Secret Art": 1 } },
            { name: "Guardian", req: { "Focus": 5 }, bonusSlots: { "Paleo Art": 0, "Secret Art": 1 } },
            { name: "Striker", req: { "Flow": 5 }, bonusSlots: { "Paleo Art": 0, "Secret Art": 1 } },
            { name: "Aegis", req: { "Control": 5 }, bonusSlots: { "Paleo Art": 0, "Secret Art": 1 } },
        ];

        let currentJob = { name: "Maiden", bonusSlots: { "Paleo Art": 0, "Secret Art": 0 } };

        // Find the first matching job evolution (can be prioritized by order in the array)
        for (const job of JOB_EVOLUTIONS) {
            // Check for character-specific requirement
            const characterMatch = !job.character || (selectedCharacter && job.character === selectedCharacter.name);

            const meetsReqs = Object.entries(job.req).every(([color, count]) => {
                return disciplineCounts[color] >= count;
            });

            if (meetsReqs && characterMatch) {
                currentJob = job;
                break; // Found the highest-priority job, stop checking
            }
        }

        // --- Dynamic Styling for Job Evolution Panel ---
        const DISCIPLINE_COLORS = {
            Brute: 'var(--color-brute)',
            Focus: 'var(--color-focus)',
            Flow: 'var(--color-flow)',
            Control: 'var(--color-control)'
        };

        // Update the character card with the job title
        const selectedCharacterCard = document.querySelector(`.character-card[data-char-name="${selectedCharacter.name}"]`);
        if (selectedCharacterCard) {
            const jobTitleP = selectedCharacterCard.querySelector('.character-job-title');
            // Get the previous job name to check for changes
            const previousJobName = jobTitleP.textContent;

            // Set the new job name
            jobTitleP.textContent = currentJob.name;

            // Apply dynamic gradient styling to the character card's job title
            const jobDisciplines = Object.keys(currentJob.req || {});
            const jobColors = jobDisciplines.map(disc => DISCIPLINE_COLORS[disc]);

            jobTitleP.classList.toggle('job-active', jobColors.length > 0);
            jobTitleP.style.backgroundImage = jobColors.length > 0 ? `linear-gradient(135deg, ${jobColors.join(', ')})` : 'none';

            // --- Animate the card if a new job is unlocked ---
            if (currentJob.name !== previousJobName && currentJob.name !== 'Maiden') {
                selectedCharacterCard.classList.add('job-unlocked-animation');

                // Remove the animation class after it finishes to allow it to be re-triggered
                selectedCharacterCard.addEventListener('animationend', () => {
                    selectedCharacterCard.classList.remove('job-unlocked-animation');
                }, { once: true });
            }


            // Create or update the custom tooltip element
            let tooltipEl = jobTitleP.querySelector('.job-tooltip');
            if (!tooltipEl) {
                tooltipEl = document.createElement('span');
                tooltipEl.className = 'job-tooltip';
                jobTitleP.appendChild(tooltipEl);
            }

            // A simple SVG for a "bonus" icon (a star)
            const bonusIconSvg = `<svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor" style="vertical-align: -0.125em; margin-right: 4px;"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>`;

            // Set tooltip text for bonus slots
            const paleoBonus = currentJob.bonusSlots['Paleo Art'] || 0;
            const secretBonus = currentJob.bonusSlots['Secret Art'] || 0;
            let bonusHtml = `${bonusIconSvg}Bonus: None`;

            if (paleoBonus > 0 || secretBonus > 0) {
                const parts = [];
                if (paleoBonus > 0) parts.push(`+${paleoBonus} Paleo Art`);
                if (secretBonus > 0) parts.push(`+${secretBonus} Secret Art`);
                bonusHtml = `${bonusIconSvg}Bonus: ${parts.join(', ')}`;
            }
            tooltipEl.innerHTML = bonusHtml;
            jobTitleP.removeAttribute('title'); // Remove the old browser tooltip
        }

        // Update slot counts based on job bonus
        const paleoBonus = currentJob.bonusSlots['Paleo Art'] || 0;
        const secretBonus = currentJob.bonusSlots['Secret Art'] || 0;

        // Update max slots
        const newPaleoMax = BASE_PALEO_SLOTS + paleoBonus;
        const newSecretMax = BASE_SECRET_SLOTS + secretBonus;
        paleoArtsSlots.dataset.maxSlots = newPaleoMax;
        secretArtsSlots.dataset.maxSlots = newSecretMax;

        // Handle adding/removing exclusive skills based on the new job
        handleExclusiveJobSkills(currentJob);

        // Update slot container headers (optional but good UX)
        paleoArtsSlots.previousElementSibling.textContent = `Paleo Arts (Active) - ${paleoArtsSlots.children.length}/${newPaleoMax}`;
        secretArtsSlots.previousElementSibling.textContent = `Secret Arts (Reserve) - ${secretArtsSlots.children.length}/${newSecretMax}`;
    }

    function handleExclusiveJobSkills(currentJob) {
        const hybridArtSlot = document.getElementById('hybrid-art-slot');
        // Find all techniques that are exclusive job arts
        const ancientArts = techniques.filter(tech => tech.type === "Ancient Art");
        let hasActiveAncientArt = false;

        ancientArts.forEach(skillData => {
            const { name, jobRequirement, characterRequirement } = skillData;

            // Check if the character and job requirements are met
            const jobMatch = !jobRequirement || currentJob.name === jobRequirement;
            const characterMatch = !characterRequirement || (selectedCharacter && selectedCharacter.name === characterRequirement);
            const shouldHaveSkill = jobMatch && characterMatch;

            // Check if the skill is already equipped
            const equippedSkillElement = hybridArtSlot.querySelector(`[data-tech-name="${name}"]`);

            // Case 1: Should have the skill but doesn't
            if (shouldHaveSkill && !equippedSkillElement) {
                // Add the skill to the dedicated hybrid art slot
                if (hybridArtSlot.children.length < parseInt(hybridArtSlot.dataset.maxSlots, 10)) {
                    const item = createTechniqueElement(skillData);
                    item.draggable = false; // Job-granted art cannot be moved
                    item.classList.add('innate'); // Style it like an innate art
                    hybridArtSlot.appendChild(item);

                    // --- Animate the newly added ancient art ---
                    const firstDiscipline = Array.isArray(skillData.discipline) ? skillData.discipline[0] : skillData.discipline;
                    const disciplineColor = `var(--color-${firstDiscipline.toLowerCase()})`;
                    item.style.setProperty('--glow-color', disciplineColor);
                    item.style.animation = 'art-glow-pulse 0.8s ease-in-out';
                    item.addEventListener('animationend', () => {
                        item.style.animation = '';
                        item.style.removeProperty('--glow-color');
                    }, { once: true });

                    hasActiveAncientArt = true;
                }
            }
            // Case 2: Has the skill but shouldn't (e.g., lost the job or changed character)
            else if (!shouldHaveSkill && equippedSkillElement) {
                equippedSkillElement.parentElement.removeChild(equippedSkillElement);
            } else if (shouldHaveSkill && equippedSkillElement) {
                // If they still have the skill, mark it as active
                hasActiveAncientArt = true;
            }
        });

        // Show or hide the container based on whether any Ancient Art is active
        hybridArtContainer.style.display = hasActiveAncientArt ? 'block' : 'none';
    }

    // Initial call to set the headers correctly
    updateJobEvolution();
});
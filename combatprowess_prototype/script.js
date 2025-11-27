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
            "activation": "match_time > 10 seconds OR distance_to_opponent > 2lengths",
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
                "Heal"
            ],
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
            "activation": "match_time > 10 seconds AND distance_to_opponent > 2lengths OR activation_chance == 80% AND area_effect == 'Water' || environment == 'Rainy'",
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
            "chain_requirements": [
                "Concentration",
                "Heavy",
                "Defense"
            ],
            "activation": "Has a low chance to activate randomly when conditions are not met.",
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
            "activation": "match_time > 10 seconds AND distance_to_opponent <= 0lengths",
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
            "activation": "match_time > 10 seconds AND activation_chance == 100% WHEN opponent_attacks",
            "description": "Caza Amarga's Signature Secret Art. A defensive maneuver that parries an incoming attack and retaliates with a crushing counterstrike.",
            "effect": "Greatly reduces opponent's health upon successful parry."
        }
    ];

    let techniques = [];
    let selectedCharacter = null;
    let draggedItem = null;
    let characterLoadouts = {}; // To store loadouts for each character
    let currentTacticalOrder = 'Balanced'; // Default order

    // Load techniques from the embedded data
    techniques = PALEOARTS_DATA;
    createCharacterList();
    createFilterBar();
    initializeTacticalOrders();
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
            });
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
            button.addEventListener('click', () => filterTechniques(discipline));
            filterContainer.appendChild(button);
        });

        // Insert the filter bar before the technique list
        listContainer.insertBefore(filterContainer, techniqueList);
    }

    function filterTechniques(discipline) {
        let filteredTechniques;
        if (discipline === 'All') {
            filteredTechniques = techniques;
        } else {
            // Filter works if the discipline is the only one OR is included in an array
            filteredTechniques = techniques.filter(tech =>
                tech.discipline === discipline || (Array.isArray(tech.discipline) && tech.discipline.includes(discipline)));
        }
        populateTechniqueList(filteredTechniques);
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
        }

        populateTechniqueList(techniques);
        updateJobEvolution();
    }

    let isDetailsUpdating = false; // Flag to prevent animation conflicts
    function showDetails(tech) {
        if (isDetailsUpdating) return; // Don't start a new animation if one is running
        isDetailsUpdating = true;

        // 1. Start the fade-out animation
        detailsContent.classList.remove('details-fade-in');
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

            const activationHtml = tech.activation
                ? `<div class="activation-details"><p><strong>Activation:</strong><br> ${tech.activation}</p></div>`
                : '';

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

            // 3. Update the innerHTML with the new technique details
            detailsContent.innerHTML = `
            <h3>${tech.name}</h3>
            <p><strong>Type:</strong> ${tech.type}</p>
            <p><strong>Discipline:</strong> ${Array.isArray(tech.discipline) ? tech.discipline.join(' / ') : tech.discipline}</p>
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
            setTimeout(() => { isDetailsUpdating = false; }, 50);
        }, { once: true }); // {once: true} is a safer way to ensure the listener is auto-removed
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

            if (tech.type === slotType && currentSlots < maxSlots) {
                // If item came from another slot, just move it
                if (draggedItem.parentElement !== techniqueList) {
                    draggedItem.parentElement.removeChild(draggedItem);
                }
                dropZone.appendChild(draggedItem);
                updateJobEvolution();
            } else {
                // Invalid drop (wrong type or full slot)
                draggedItem.style.display = 'block';
            }
        }
        draggedItem.style.display = 'block'; // Always show the item after drop attempt
        draggedItem = null;
    }

    function handleListDrop(e) {
        e.preventDefault();
        const dropZone = e.target.closest('#technique-list-container');
        if (!dropZone || !draggedItem) return;

        // If the item came from a slot, move it back to the list
        if (draggedItem.parentElement !== techniqueList) {
            draggedItem.parentElement.removeChild(draggedItem);
            techniqueList.appendChild(draggedItem);
            updateJobEvolution();
        }

        draggedItem.style.display = 'block';
        draggedItem = null;
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
        const equippedTechs = [...paleoArtsSlots.children, ...secretArtsSlots.children, ...hybridArtContainer.querySelector('ul').children];
        const disciplineCounts = { Brute: 0, Focus: 0, Flow: 0, Control: 0 };

        equippedTechs.forEach(item => {
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
            { name: "Kinetic Boxer", character: "Sastrei Taurus", req: { "Flow": 5 }, bonusSlots: { "Paleo Art": 2, "Secret Art": 0 } },
            { name: "Tyrant King", character: "Tyran Rex", req: { "Brute": 5 }, bonusSlots: { "Paleo Art": 2, "Secret Art": 0 } },
            { name: "Iai Master", character: "Kitadani Fukuira", req: { "Focus": 5 }, bonusSlots: { "Paleo Art": 2, "Secret Art": 0 } },
            { name: "River Hunter", character: "Aegypt Spino", req: { "Focus": 5 }, bonusSlots: { "Paleo Art": 2, "Secret Art": 0 } },

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
            { name: "Barbarian", req: { "Brute": 5 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Guardian", req: { "Focus": 5 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Striker", req: { "Flow": 5 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
            { name: "Aegis", req: { "Control": 5 }, bonusSlots: { "Paleo Art": 1, "Secret Art": 0 } },
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
            jobTitleP.textContent = currentJob.name;

            // Apply dynamic gradient styling to the character card's job title
            const jobDisciplines = Object.keys(currentJob.req || {});
            const jobColors = jobDisciplines.map(disc => DISCIPLINE_COLORS[disc]);

            jobTitleP.classList.toggle('job-active', jobColors.length > 0);
            jobTitleP.style.backgroundImage = jobColors.length > 0 ? `linear-gradient(135deg, ${jobColors.join(', ')})` : 'none';

            // Add tooltip for bonus slots
            const paleoBonus = currentJob.bonusSlots['Paleo Art'] || 0;
            const secretBonus = currentJob.bonusSlots['Secret Art'] || 0;
            let bonusText = "Bonus: None";
            if (paleoBonus > 0 || secretBonus > 0) {
                const parts = [];
                if (paleoBonus > 0) parts.push(`+${paleoBonus} Paleo Art Slot(s)`);
                if (secretBonus > 0) parts.push(`+${secretBonus} Secret Art Slot(s)`);
                bonusText = `Bonus: ${parts.join(', ')}`;
            }
            jobTitleP.title = bonusText;
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
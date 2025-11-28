# 🦖 Paleo-Maiden Championship: Game Design Documentation

## Table of Contents

1.  [Lore & World-Building](#i-lore--world-building)
2.  [Core Progression & High-Stakes Qualification](#ii-core-progression--high-stakes-qualification)
    -   [Final League Championship Structure (16 Competitors)](#-final-league-championship-structure-16-competitors)
    -   [Rival Arcs & Narrative Progression](#c-rival-arcs--narrative-progression)
    -   [Rival Spotlight System: Narrative Through Mechanics](#d-rival-spotlight-system-narrative-through-mechanics)
    -   [Job Evolution (Optional Mastery)](#job-evolution-optional-mastery)
    -   [Seasonal Title Matches: Unlocking Hybrid Vocations](#e-seasonal-title-matches-unlocking-hybrid-vocations)
3.  [World Map Spaces & Mechanics](#iii-world-map-spaces--mechanics)
    -   [Expedition Camp Actions (Wilderness Space)](#expedition-camp-actions-wilderness-space)
    -   [Title Matches Mechanic (Stadium Facilities Space)](#title-matches-mechanic-stadium-facilities-space)
4.  [Combat System](#iv-combat-system)
    -   [Technique Synergy & Combos](#a-technique-synergy--combos)
    -   [Arena Biomes & Affinities](#b-arena-biomes--affinities)
    -   [Technique Classification](#c-technique-classification-and-acquisition)
5.  [Finalized Class Disciplines](#v-finalized-class-disciplines)
6.  [Core Gameplay Loop & Player Agency](#vi-core-gameplay-loop--player-agency)
    -   [Turn Structure](#a-turn-structure-24-turns-per-year)
    -   [Game Variables](#b-game-variables)
    -   [Core Pillars of Fun](#c-core-pillars-of-fun)
7.  [Combat Philosophy & Design Inspiration](#vii-combat-philosophy--design-inspiration)
    -   [The "Coach/Trainer" Combat Model](#a-the-coach-trainer-combat-model)
    -   [Abstracted Training: "Capabilities over Stats"](#b-abstracted-training-capabilities-over-stats)
    -   [Alignment with Existing Game Design](#c-alignment-with-existing-game-design)
8.  [Design Evolution Summary (tl;dr)](#viii-design-evolution-summary-tldr)

## I. Lore & World-Building

| Aspect | Description |
| :--- | :--- |
| **Theme & Setting** | **Anthropomorphic Paleo Maidens University.** The game takes place on the **Primeval Continents**, vast, primordial landscapes that serve as sacred training grounds for the Stratum Institute. |
| **Primary Goal** | Win the **Paleo World Championship (World Cup)** at the end of the third-year Cretaceous League. |
| **Magic System** | **Paleo-Magic (P-Magic):** The manifestation of a Maiden's primal energy, serving as their **Health Pool**. Attacks deplete P-Magic by inflicting the intense neurological *sensation* of injury, leading to exhaustion and defeat without causing physical harm. |
| **Player Role** | The player is a **Lecturer** at the Stratum Institute, acting as a mentor who selects a Paleo Maiden Champion and guides them through their academic and competitive journey. |
| **Progression Basis** | The core gameplay is the **3-Year Great Expedition**, a "world tour" across the Primeval Continents. Each year is a 24-turn campaign that culminates in a high-stakes League Championship. |

---

## II. Core Progression & High-Stakes Qualification

The run structure is defined by three escalating leagues. **Failure to qualify ends the run immediately.**

| League (Year) | Geographic Scope | Qualification Requirement | Consequence of Failure |
| :--- | :--- | :--- | :--- |
| **Triassic League** (Year 1) | **Pangaea** (Initial Map) | **Win or Reach Top 8 out of 16 competitors** in the Final Tournament. | **Career Ends.** |
| **Jurassic League** (Year 2) | **Laurasia & Gondwana** (Map Expanded) | **Win or Reach Top 8 out of 16 competitors** in the Final Tournament. | **Career Ends.** |
| **Cretaceous League** (Year 3) | **Global Arena** (Full Map) | **Win the Paleo-Magic Championship** (Finals). | **Career Ends.** |

## 🏆 Final League Championship Structure (16 Competitors)

The end-of-year **League Championships** are high-stakes, **double-elimination tournaments**. The preparation rules enforce the strategic importance of sustained durability.

### A. Match Preparation Rules (Final P-Magic Condition)

| Match | P-Magic Condition Rule | Strategic Impact |
| :--- | :--- | :--- |
| **First Bout** (Round 1) | The Champion begins the first bout with their **P-Magic Pool exactly as it was** when the League Exam was triggered. | Maintains the tension of the **24-Turn Cycle**, forcing the player to spend final turns on healing to avoid starting the tournament at a massive disadvantage. |
| **Subsequent Bouts** (Rounds 2+) | The Champion's **P-Magic Pool is partially recovered**, setting it to **50% of Max P-Magic** before the start of the next match. | Forces the Champion to demonstrate sustained durability. Champions with low starting P-Magic (like Blue) must now use defensive/healing cards throughout the tournament to survive successive rounds. |

### B. Tournament Flow (Double Elimination)

The tournament utilizes a double-elimination bracket, rewarding a single loss recovery.

| Bracket Path | Goal | Consequence of Loss |
| :--- | :--- | :--- |
| **Winners Bracket** | The path to the Championship without a single loss. | **Drops to the Losers Bracket.** Still has one chance for qualification. |
| **Losers Bracket** | The path to securing Top 8 qualification after one previous loss. | **Career Ends.** The Paleo Maiden is immediately disqualified. |
| **Achievement** | **Comeback Specialist:** Winning the League after dropping into and winning through the Losers Bracket. | Unlocks a special achievement/reward. |

### C. Rival Arcs & Narrative Progression

The League Championships serve as the primary vehicle for narrative progression, framed as **Rival Arcs** that explore the personal stories of each Paleo Maiden.

| Feature | Description |
| :--- | :--- |
| **Rival Introductions** | During world map exploration, potential rivals are introduced through random events, setting the stage for the high-stakes encounters in the final tournament. |
| **Randomized Brackets** | The bracket seeding for the 16 competitors is **completely random** in each run. This ensures that each tournament playthrough is unique and unpredictable. |
| **Narrative Replayability** | Because players are not guaranteed to face specific rivals, multiple playthroughs are encouraged to experience a Champion's full character arc and unlock all unique story events. |
| **Rival Gifts & Bonds** | During map events, rivals may offer gifts (e.g., dice modifiers, ingredients) or trigger deeper conversations. Positive outcomes can strengthen the bond, unlocking unique dialogue and even special Paleo Arts. |

### D. Rival Spotlight System: Narrative Through Mechanics

To ensure that a single playthrough feels like part of a larger, interconnected world, rivals are spotlighted through two key systems. These mechanics make rivals feel like significant parts of your Maiden's journey, encouraging players to become invested in their stories and potentially play as them in the future.

| System | Description & Narrative Impact |
| :--- | :--- |
| **1. Crossroad Events** | By chance encountering a **Crossroad** space triggers a deep narrative event with a rival, revealing their motivations, fears, and backstory. Success in either sparring or interact wit them rewards with Paleo Arts corresponding from that rival's discipline; it can reward the player with a unique. This technique is a move inspired by the rival's philosophy, allowing your Maiden to adopt a piece of their style. For example, the aggressive Sastrei Taurus might learn the `Unyielding Stance` Paleo Art from the defensive Caza Amarga, a tangible representation of their friendship and Sastrei's growth. |
| **2. Sparring Sessions & Rival's Legacy Techniques** | Rivals are formidable opponents with full **Combat Prowess** loadouts and distinct strategies. Defeating them requires careful use of **Tactical Orders** and a well-planned build. The rewards for these high-stakes duels are significant:<br> * **On Victory:** The player is offered a choice of **three** Reward Techniques, with a guaranteed higher rarity and a small chance for the Rival's own **Secret Art** to appear as the ultimate prize. <br> * **On Defeat:** The player receives only **one** choice of a **lower-rarity** Technique as a consolation prize. <br> *This system makes fighting a Rival a high-risk, high-reward event that is core to building a powerful moveset.* |

### Job Evolution (Optional Mastery)

**Job Evolution** is an entirely optional system of specialization that expands a Maiden's **Combat Prowess**. It is divided into two tiers:

*   **Single-Discipline Jobs:** Achieved by equipping a sufficient number of techniques from a single discipline.
*   **Hybrid-Discipline Jobs:** The pinnacle of mastery. Achieved by both equipping a specific mix of techniques AND winning specific **Titles** from seasonal Title Matches.

| Job Type | Example Job | Requirement | Bonus |
| :--- | :--- | :--- | :--- |
| **Single Discipline (Character-Specific)** | Tyrant King (Tyran Rex) | 5 Brute Techniques | +1 Secret Art Slot, Unlocks **Ancient Art** |
| **Hybrid Discipline (Character-Specific)** | Mystic Spearhand (Tyran Rex) | 4 Brute + 2 Focus Techniques<br>**+ Win "The Stalwart" & "The Vanguard" Titles** | +1 Paleo Art Slot, Unlocks **Ancient Art** |
| **Single Discipline (Generic)** | Barbarian | 5 Brute Techniques | +1 Secret Art Slot |
| **Hybrid Discipline (Generic)** | Gladiator | 3 Brute + 2 Control Techniques<br>**+ Win "The Bulwark" Title** | +1 Paleo Art Slot |

*Note: Character-specific jobs take priority over generic ones if requirements for both are met. The job system is determined by the techniques equipped in the **Paleo Arts** slots plus the character's **innate Secret Art**.*

### E. Seasonal Title Matches: Unlocking Hybrid Vocations

To add a layer of prestige and challenge, certain map spaces will periodically host **Seasonal Title Matches**. These are optional, high-difficulty tournaments that appear on the calendar at specific times of the year (e.g., the "Spring Bloom Invitational" in early February). Winning these events is the only way to earn the **Titles** required for unlocking advanced Hybrid Vocations.

| Event Feature | Description |
| :--- | :--- |
| **Appearance** | Appears on a specific map space for a limited duration (e.g., for 4 turns). The player must travel to that space to participate. |
| **Entry Requirement** | Depends on the Title Match requirements that is running. |
| **Reward** | A unique, permanent **Title** for the champion (e.g., "The Stalwart"), and a choice of rare techniques. |

These matches are themed and offer unique titles that reflect the specific challenge they present. A Maiden can hold multiple titles, and collecting the correct combination is key to unlocking her full potential.

| Title Match Name | Appears | Challenge Focus | Title Awarded |
| :--- | :--- | :--- | :--- |
| **The Meat-Lover's Classic** | Early January | A tournament exclusively for carnivore-class Maidens. | "The Meat-Eater" |
| **Sprinter's Ace Invitational** | Mid-March | A high-speed tournament where only **Flow (Green)** techniques are allowed. | "Fast and Furious" |
| **The Stalwart Summit** | Late June | A defensive gauntlet where victory is earned by outlasting powerful opponents. | "The Stalwart" |
| **Vanguard's Valor** | Early September | An offensive free-for-all that rewards aggressive, high-damage strategies. | "The Vanguard" |

---

## III. World Map Spaces & Mechanics

Movement is governed by a **Dice Roll**. Each action costs a turn, and players are given **24 turns per year**.

Movement is governed by a **Dice Roll**, with players using **Paleo-Focus** to strategically control their landing spot. Each action costs a turn and players are given **24 turns per year**.

| Space Name | Core Function | Action/Event Triggered |
| :--- | :--- | :--- |
| **Wilderness** | **Resource Management, Recovery & Relationship Building** | Automatically triggers the **Expedition Camp**, where the player chooses from several actions. This costs **1 Turn**. |
| **Crossroads** | **Rival Encounter & Relationship Building** | A chance encounter with another Maiden and their Lecturer. The player chooses to either **Interact (Free Action)** for a brief narrative event that rewards a random Paleo Art related to the Rival, or **Challenge (Free Action)** to initiate a friendly Sparring Session. Winning the spar yields a choice of higher-rarity Paleo Arts. |
| **Academic Milestone** | **Mandatory Career Check** | A high-difficulty **Sparring Session** against a predetermined rival or powerful opponent. Must be won to qualify for the League Exam. |
| **Title Match** | **High-Stakes Combat & Reward** | Permanent **Stadium Facilities** on the map that occupy a large **2x2 grid area (4 spaces)**, making them easier to access. Landing on any of these spaces allows the player to challenge one of three **Title Aspirants** vying for that stadium's title. One of these will be the **Apex Aspirant**, the most difficult challenge. See the "Title Matches Mechanic" section for details. |
---

### Expedition Camp Actions (Wilderness Space)

| Action | Effect |
| :--- | :--- |
| **Train** | Guaranteed gain of a new common **Technique** and a smaller chance for an uncommon colored **Techniques**. |
| **Forage** | Primarily yields **Ingredients** and **Navigation Items** (e.g., dice modifiers), with a small chance to find a biome-specific **Technique**. Depletes P-Magic. |
| **Cook** | Use collected **Ingredients** to create recipes that restore P-Magic and build a stronger relationship with your Maiden. |
| **Barter** | **(Free Action)** Place an order by trading away unwanted ingredients. The requested ingredients will be delivered at the start of the player's next turn. |

|---

### Title Matches Mechanic (Stadium Facilities Space)

Each stadium features three **Title Aspirants** competing for that location's title. One is the **Apex Aspirant**—the thematic favorite and toughest challenge (e.g., **Tyran Rex** at the "Meat-Lover Stakes").

| Opponent Tier | Difficulty | Reward for Winning |
| :--- | :--- | :--- |
| **The Apex Aspirant** | Very High | Choose one of three rewards: a unique **Badge**, a prestigious **Title**, or a choice between that Maiden's unique **Secret Art** and two high-rarity **Paleo Arts** of their primary discipline. |
| **A Rival Aspirant** | High | Choose one of three high-rarity **Paleo Arts** of that Maiden's primary discipline with a small chance for that Maiden's unique **Secret Art** |

| Mechanic | Detail | 
| :--- | :--- |
| **Badges** | Prestigious trophies won from defeating an **Apex Aspirant** in a Title Match. During random map events, the player may encounter a Professor and their Paleo Maiden partner. Possessing a Badge prompts a **free Sparring Session** challenge. Winning this spar grants powerful Techniques, but accepting with low P-Magic is risky. |
| **Titles** | Prestigious, cosmetic honorifics won from defeating an **Apex Aspirant** in a Title Match. These are displayed next to a Maiden's name in tournaments and combat logs to signify their accomplishments. |
| **League Exam** | **Automatic Trigger** when **all Academic Milestones for the Year are cleared**. |

---

*__Deprecated Mechanics:__ The old `Campsite (Rest)`, `Hot Spring`, `Trading Post`, and `Dojo` spaces have been deprecated, along with the `Fossil Funds` currency. Their functions are now integrated into the `Expedition Camp` and `Title Match` systems.*

## IV. Combat System

The system is a **Hybrid Automated Real-Time** system designed to be fast, fluid, and driven by the player's strategic preparation. It is centered around a player-defined **Combat Prowess** rather than a traditional card deck.

| Mechanic | Detail |
| :--- | :--- |
| **Technique Collection** | The player collects **Paleo Arts** from map events. There is no limit to the number of techniques they can own. Defeating strong rivals grant Stronger Paleo Arts and also higher chance to get **Secret Arts** |
| **Combat Prowess** | Before a match, the player prepares their strategy by equipping techniques into their **Combat Prowess**. The base consists of **`BASE_PALEO_SLOTS = 5` (Active)** and **`BASE_SECRET_SLOTS = 2` (Reserve)**, with more slots unlockable via Job Evolution. |
| **Paleo Arts (Active)** | The core of the game plan. In real-time combat, the AI automatically uses these techniques as they come off their individual **cooldowns**. |
| **Secret Arts (Reserve)** | Holds techniques that are not used in the normal turn-by-turn rotation. Their purpose is to fulfill the requirements for **Catalyst Combos** and to be activated by **Chain Properties**, allowing for complex synergies without clogging the main loadout. |
| **Tactical Orders** | A high-level instruction (e.g., "All-Out Blitz," "Patient Counter") that influences the AI's selection priority when multiple Paleo Arts are off cooldown simultaneously. |
| **Technique Types** | **Discipline Techniques** (Generic utility/buffs) **AND Species-Specific Techniques** (Rare, powerful effects tied to specific defeated rivals). |
| **Arena Affinity** | The battle arena's biome can influence combat. Maidens with a natural affinity for the environment may have specific Paleo/Secret Arts boosted, increasing their effects and/or activation chance when fighting on their home turf. |
| **Perfect Victory** | Winning a spar without losing any P-Magic grants a bonus Technique choice. |
| **Commentated Combat Log** | A live combat log narrates the fight with the flavor and energy of a sports commentator. It uses fighting game terminology (e.g., "punish," "combo," "whiff") to make the automated action exciting and easy for players to follow and discuss. |

### A. Technique Synergy & Combos

To capture the feel of fighting game combos and reward deep strategic planning, certain techniques can interact with each other to produce powerful effects. This encourages players to think about their **Combat Prowess** not just as a list of moves, but as a potential engine for combos.

| Synergy Type | Description & Example |
| :--- | :--- |
| **Catalyst Combos** | **Strategic Preparation.** A "Catalyst" technique in a **Paleo Art** slot transforms into a powerful combo move if its required "ingredient" techniques are equipped in the **Secret Arts** slots. <br> *Example:* Placing `[Catalyst: Predator's Focus]` in a Paleo Art slot and `Claw Slash` + `Charging Pounce` in Secret Arts slots unlocks **`Raptor's Fury`**. |
| **Chain Properties** | **Dynamic Execution.** A technique in a **Paleo Art** slot with a "Chain" property has a chance to immediately trigger a compatible technique from either the Paleo Arts or **Secret Arts** slots. <br> *Example:* `Iai Stance` can now "Chain" into a powerful 'Strike' technique you've placed in a Secret Art slot specifically for this purpose. |

This system translates the "combo input" of a fighting game into the strategic preparation phase, creating deep satisfaction when a player's carefully crafted **Combat Prowess** unleashes a unique and powerful combo in the heat of battle.

### B. Arena Biomes & Affinities

The location of a battle is a critical strategic factor. Each tournament match takes place in a specific biome on the Primeval Continents, and Maidens whose ancestry is tied to that environment gain a significant "home field advantage."

| Arena Biome | Description & Affinity Effect |
| :--- | :--- |
| **Lush Floodplain** | A swampy delta crisscrossed by deep rivers. **Affinity:** Boosts the effects and activation chance of water-based or semi-aquatic Paleo/Secret Arts. For example, **Aegypt Spino's** "River Hunter" Secret Art becomes significantly more potent. |
| **Volcanic Field** | An unstable landscape of magma flows and ash clouds. **Affinity:** Boosts the damage of **Red (Power)** discipline techniques. Fire-based Secret Arts have their cooldowns moderately reduced. |
| **Dense Cycad Forest** | A tight, claustrophobic jungle limiting long sightlines. **Affinity:** Increases the activation chance of "Chain" properties for ambush-style Maidens (e.g., **Dromaeosauridae Clan**). |
| **Arid Desert** | A vast, sun-scorched wasteland with little cover. **Affinity:** Boosts the effectiveness of defensive and restorative **Yellow (Control)** discipline techniques. |
| **Open Fern Prairie** | A wide-open plain ideal for large-scale movement. **Affinity:** Reduces the cooldowns on movement-based and wide-arc Paleo Arts, benefiting large Maidens like sauropods. |

---

## V. Finalized Class Disciplines


| Color/Discipline | Combat Focus | Unique Passive Combat Ability | Unique Board/Flow Ability |
| :--- | :--- | :--- | :--- |
| **🔴 Red** | **Brute:** Raw Power & Scaling Damage. | **Power Surge:** Applies **+1 damage** to all attacks for each turn that passes in combat (resets after fight). | **Killing Streak:** After **3 consecutive wins**, gain a choice of one bonus "Spoils of Victory" common technique. |
| **🔵 Blue** | **Focus:** Defense, Precision & Consistency. | **Arcane Ward:** Starts every combat with a **+2 Arcane Shield**. | **Scholarly Insight:** Chooses from **4 Reward Techniques** instead of 3 after any spar win. |
| **🟢 Green** | **Flow:** Speed & Momentum. | **First Strike:** Applies a **+3 bonus** to their first attack technique used in combat. | **Double Time:** Can **reject the free technique** from the Campsite to gain an **extra dice roll** upon completion of the rest. |
| **🟡 Yellow** | **Control:** Durability & Damage Reduction. | **Natural Resilience:** Passive **-1 damage reduction** from all incoming attacks. | **Strategic Insight:** After any spar win, the player can **reshuffle the presented Reward Techniques** and draw a new set of 3/4 random techniques from the pool. |

---

## VI. Core Gameplay Loop & Player Agency

This section breaks down the turn-by-turn gameplay loop and distinguishes between fixed game elements, player choices, and random variables.

### A. Turn Structure (24 Turns per Year)

| Step | Action | Detail |
| :--- | :--- | :--- |
| **1. Roll Dice** | The player initiates a dice roll to determine movement range. | This action costs **1 Turn**. |
| **2. Choose Path** | The player moves their Champion token on the map. | Movement must equal the number rolled on the dice. The map is non-linear, but there are ways to return to the start. |
| **3. Land on Space** | The Champion lands on a map space, triggering an event. | Events can include **Wilderness**, **Crossroads**, **Academic Milestones**, or **Title Matches**. |

### B. Game Variables

| Element Type | Description | Examples |
| :--- | :--- | :--- |
| **Constants** | Core rules and structures that are fixed for every playthrough. | • Fixed World Map Layout<br>• 3-Year Course Structure<br>• Standard 24 Turns per Year<br>• Predetermined Starting **Loadouts** for each Champion |
| **Player Choices** | Key decisions the player makes to influence the outcome of the run. | • Selecting the starting Champion.<br>• Building the **Combat Prowess** by equipping Paleo & Secret Arts.<br>• Setting the **Tactical Order** (Offensive, Defensive, Balanced) before a match.<br>• Choosing a path on the world map after a dice roll.<br>• Selecting a Reward **Technique** after a sparring victory.<br>• Deciding when to use ingredients to Cook and rest. |
| **Random (RNG)** | Elements of chance that introduce unpredictability and replayability. | • Dice Roll result (1-6)<br>• **Technique** options presented in post-combat Rewards<br>• **Arena Biome** for tournament matches<br>• Specific events on certain map spaces (e.g., rival encounters, shops, sparring) |

### C. Core Pillars of Fun

| Pillar | Description |
| :--- | :--- |
| **1. Nurturing** | Supporting and developing a favorite character, similar to a virtual pet or raising simulator (e.g., *Tamagotchi*, *Uma Musume*). |
| **2. Risk/Reward** | Experiencing the thrill of chance through dice rolls and random card draws, embracing a "gambling" feel. |
| **3. Satisfaction** | The deep satisfaction that comes from seeing a well-planned strategy, deck synergy, or a lucky combo work out perfectly. |

### D. Deprecated Concepts

~~**Initial Card Game Concepts:** This section is deprecated in favor of the **Combat Prowess** system described in Section IV. The core ideas of collecting abilities and preparing for fights are retained, but the implementation is simplified to focus on a loadout of equipped techniques rather than a deck of cards.~~

*   ~~**Starting Loadout (Red Example):** A Red discipline champion might start with the techniques: `Basic Strike` (3 Dmg), `Guard` (2 Block), and `Power Up` (+1 power this turn).~~
*   ~~**AI Logic:** The AI's logic is now much simpler: on its turn, it activates one of its equipped techniques based on a straightforward priority (e.g., use a healing move if HP is low, otherwise use a random damage move).~~
*   ~~**Combat Resolution:** Combat is simulated automatically turn-by-turn until one combatant's P-Magic is depleted.~~

---

## VII. Combat Philosophy & Design Inspiration

To ensure a cohesive experience, the combat system's design is guided by a clear philosophical model inspired by games like ***Digimon World Championship***. This approach emphasizes the player's role as a mentor and strategist, making preparation the core gameplay and the battle its thrilling, automated payoff.

### A. The "Coach/Trainer" Combat Model

The combat system is intentionally hands-off during the fight itself. The player's interaction is focused entirely on the strategic decisions made *before* the battle begins.

| Phase | Player Role & Action |
| :--- | :--- |
| **1. Preparation Phase** | **The Lecturer's Core Gameplay.** The player guides their Maiden through the 24-turn expedition, making critical choices about which **Techniques** to acquire, when to rest, and which rivals to interact with. This culminates in setting the **Combat Prowess** before a tournament. |
| **2. Combat Phase** | **The Automated Spectacle.** The battle unfolds automatically based on the Maiden's preparation, her equipped techniques, and a degree of RNG. The player becomes an invested spectator, watching to see if their strategy was successful. |

### B. Abstracted Training: "Capabilities over Stats"

Following the "train -> compete" loop of its inspirations, this game abstracts the concept of "training stats." Instead of increasing numerical values (e.g., STR, DEF), the player "trains" their Maiden by expanding her **strategic capabilities**.

| Traditional Training Sim | Paleo-Maiden Championship Equivalent |
| :--- | :--- |
| **Training Stats (e.g., +10 Speed)** | **Acquiring Techniques.** Landing on a "Sparring Session" space and gaining a new `Flowing Strikes` technique makes the Maiden qualitatively faster and better at maintaining tempo. |
| **Reaching Stat Thresholds** | **Achieving Job Evolution.** Collecting a specific number of colored techniques (e.g., 5 Red, 5 Blue) unlocks a new "Job" with powerful passive buffs, serving as a long-term training goal. |
| **Equipping Support Cards** | **Building Rival Bonds.** Engaging in "Crossroads" events and strengthening relationships rewards the player with unique and powerful Paleo Arts. |

This approach ensures the feeling of growth and progression is central to the experience, but keeps the focus on strategic choices and narrative development rather than numerical micromanagement.

### C. Alignment with Existing Game Design

This combat philosophy is not a new direction but rather a formalization of the game's existing strengths, creating perfect synergy between the lore, mechanics, and desired "fun factors."

| Core Design Element | How the "Coach/Trainer" Model Aligns |
| :--- | :--- |
| **Player Role as Lecturer** | This model is the ultimate expression of being a mentor. The player's skill is tested through their teaching and preparation (the Expedition), not their reflexes. The battle is the Maiden's "final exam." |
| **Pillar 1: Nurturing** | By making combat automated, the gameplay focus shifts entirely to the **Great Expedition** phase. The joy comes from carefully developing your Maiden over time, making this pillar the central activity. |
| **Pillar 2: Risk/Reward** | The moment the automated battle begins is the ultimate "gambling" moment. The player has placed their strategic "bet" through 24 turns of training; the fight is the thrilling spin of the wheel to see the outcome. |
| **Pillar 3: Satisfaction** | Victory feels deeply earned, as it validates the player's long-term strategy and coaching ability. Seeing a specific technique you chose turn the tide of battle provides immense satisfaction. |
| **Combat Prowess System** | This system becomes the player's primary tool for expressing strategy. The choice of which techniques to equip in the **Paleo Arts** and **Secret Arts** is the most critical decision, acting as the "playbook" for the upcoming automated fight. |
| **"Shonen Tournament" Theme** | This model perfectly captures the feeling of a coach watching anxiously from the stands. The **Commentated Combat Log** enhances this by turning the automated fight into an exciting spectator sport. |

---

## VIII. Design Evolution Summary (tl;dr)

This section provides a quick summary of the key changes from the initial "Card Game" concept to the current "Combat Prowess" system, clarifying the design's evolution.

| Feature | Initial Card Game Concept | Current "Combat Prowess" System |
| :--- | :--- | :--- |
| **Core Collectible** | Cards in a deck. | **Techniques** (Paleo Arts & Secret Arts). |
| **Player Preparation** | Building a 15-card deck. | Equipping a **Combat Prowess** (5 Paleo Arts + 2-3 Secret Arts). |
| **Combat Interaction** | Intended manual card play or complex AI choosing from a hand. | Fully **automated real-time simulation** based on the prepared Combat Prowess. |
| **Resource System** | Mana costs for cards. | **No in-combat resource costs** for techniques. |
| **Core RNG** | Drawing cards from the deck each turn. | The slight variations in **cooldown timers** and AI priority choices. |
| **Strategic Focus** | Deck consistency and cycling. | Crafting a synergistic **loadout with combos** and adapting the strategy to the opponent and the **arena**. |

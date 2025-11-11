# 🦖 Paleo-Maiden Championship: Game Design Documentation

## I. Lore & World-Building

| Aspect | Description |
| :--- | :--- |
| **Theme & Setting** | **Anthropomorphic Paleo Maidens University.** The game takes place across a single World Map that represents all three prehistoric eras (Triassic, Jurassic, Cretaceous) combined into an academic timeline. |
| **Primary Goal** | Win the **Paleo-Maiden Championship (PMC)** at the end of the Cretaceous Year (Year 3). |
| **Magic System** | **Paleo-Magic (P-Magic):** The source of power and literally the Champion's **Health Pool** in combat. When P-Magic reaches zero, the run ends. |
| **Player Role** | The player is a **Mentor/Coach** who selects a Paleo Maiden Champion (e.g., Tyran Rex, Abeli Taurus) and guides them through the **3-Year Course**. |
| **Progression Basis** | **3-Year University Course (6 Semesters/72 weeks).** Each year ends with a high-stakes **League Championship** that dictates qualification for the next year. |

---

## II. Core Progression & High-Stakes Qualification

The run structure is defined by three escalating leagues. **Failure to qualify ends the run immediately.**

| League (Year) | Geographic Scope | Qualification Requirement | Consequence of Failure |
| :--- | :--- | :--- | :--- |
| **Triassic League** (Year 1) | **Pangaea** (Initial Map) | **Win or Reach Top 8 out of 16 competitors** in the Final Tournament. | **Career Ends.** |
| **Jurassic League** (Year 2) | **Laurasia & Gondwana** (Map Expanded) | **Win or Reach Top 8 out of 16 competitors** in the Final Tournament. | **Career Ends.** |
| **Cretaceous League** (Year 3) | **Global Arena** (Full Map) | **Win the Paleo-Magic Championship** (Finals). | **Career Ends.** |

## 🏆 Final League Championship Structure (16 Competitors)

The end-of-year **League Championships** are high-stakes, **double-elimination tournaments** featuring 16 competitors. The preparation rules enforce the strategic importance of sustained durability.

### 1. Match Preparation Rules (Final P-Magic Condition)

| Match | P-Magic Condition Rule | Strategic Impact |
| :--- | :--- | :--- |
| **First Bout** (Round 1) | The Champion begins the first bout with their **P-Magic Pool exactly as it was** when the League Exam was triggered. | Maintains the tension of the **24-Turn Cycle**, forcing the player to spend final turns on healing to avoid starting the tournament at a massive disadvantage. |
| **Subsequent Bouts** (Rounds 2+) | The Champion's **P-Magic Pool is partially recovered**, setting it to **50% of Max P-Magic** before the start of the next match. | Forces the Champion to demonstrate sustained durability. Champions with low starting P-Magic (like Blue) must now use defensive/healing cards throughout the tournament to survive successive rounds. |

### 2. Tournament Flow (Double Elimination)

The tournament utilizes a double-elimination bracket, rewarding a single loss recovery.

| Bracket Path | Goal | Consequence of Loss |
| :--- | :--- | :--- |
| **Winners Bracket** | The path to the Championship without a single loss. | **Drops to the Losers Bracket.** Still has one chance for qualification. |
| **Losers Bracket** | The path to securing Top 8 qualification after one previous loss. | **Career Ends.** The Paleo Maiden is immediately disqualified. |
| **Achievement** | **Comeback Specialist:** Winning the League after dropping into and winning through the Losers Bracket. | Unlocks a special achievement/reward. |

### Job Evolution (Optional Mastery)

**Job Evolution** is an entirely optional system of specialization that provides powerful **passive stat buffs** (e.g., +Max P-Magic, +Damage Multiplier). It is achieved by meeting specific card counts for color combinations.

| Example Path | Discipline Focus | Resulting Job Title |
| :--- | :--- | :--- |
| **Single-Discipline** (e.g., Full Red Deck) | Raw Power | **Barbarian Tyran Rex** |
| **Hybrid Discipline** (e.g., Red + Blue Deck) | Power & Defense | **Mystic Spearhand Tyran Rex** |
| **Hybrid Discipline** (e.g., Green + Blue Deck) | Speed & Magic | **Boxing Magus Abeli Taurus** |

---

## III. World Map Spaces & Mechanics

Movement is governed by a **Dice Roll**, with players using **Paleo-Focus** to strategically control their landing spot. Each action costs a turn and players are given **24 turns per year**.

| Space Name | Core Function | Action/Event Triggered |
| :--- | :--- | :--- |
| **Sparring Session** | **Combat & Primary Card Gain** | Win to gain **Fossil Funds** and a choice of **Reward Cards** (weighted by the opponent's class/species). |
| **Dojo** | **Guaranteed Card Acquisition** | Spend **Fossil Funds** to purchase specific, color-coded **Discipline Cards** or expensive **Specialized Species Cards**. |
| **Hot Spring** | **P-Magic Maintenance** | Spend **Fossil Funds** to buy **species-specific Curative Food Items** (with expiration timers) for small, immediate P-Magic recovery. |
| **Academic Milestone** | **Mandatory Career Check** | **Permanent, high-difficulty Sparring Session** (must be won to qualify for the League Exam). |

---

| Mechanic | Detail | **Unique Green Class Integration** |
| :--- | :--- | :--- |
| **Campsite (Rest)** | Available via **Menu/UI** on any turn. **Cost:** 1 Turn. **Benefit:** Major P-Magic Recovery (75% HP) **PLUS** one random Discipline Card of the Champion's base color. | **Double Time:** Green can **reject the random card gain** to receive an **extra dice roll** for immediate movement after resting, sacrificing passive learning for aggressive flow. |
| **League Exam** | **Automatic Trigger** when **all Academic Milestones for the Year are cleared**. | The final boss tournament for the Year, required for qualification. |

---

## IV. Combat System

The system is a **Hybrid Automated Turn-Based** system designed to be quick, decisive, and driven by player-built deck synergy.

| Mechanic | Detail |
| :--- | :--- |
| **Deck Size** | **15-Card Maximum** (Base deck starts at 5-7 cards). A small size ensures high consistency and fast cycling. |
| **Turn Flow** | **Draw 5 Cards.** AI automatically selects and plays **1 to 3** cards (prioritizing synergy/defense). Played cards are discarded; **unplayed cards are retained** for the next turn's strategy. |
| **Card Types** | **Discipline Cards** (Generic utility/buffs, for Job Evolution count) **AND Species-Specific Cards** (Rare, powerful effects tied to specific defeated rivals). |
| **Perfect Victory** | Winning a spar without losing any P-Magic grants a bonus (e.g., Red Class gets an extra card). |

---

## V. Finalized Class Disciplines


| Color/Discipline | Combat Focus | Unique Passive Combat Ability | Unique Board/Flow Ability |
| :--- | :--- | :--- | :--- |
| **🔴 Red** | **Raw Power & Scaling Damage.** | **Power Surge:** Applies **+1 damage** to all attacks for each turn that passes in combat (resets after fight). | **Killing Streak:** Draw an extra card after **3 consecutive wins** in Sparring/Milestones. |
| **🔵 Blue** | **Defense & Consistency.** | **Arcane Ward:** Starts every combat with a **+2 Arcane Shield**. | **Scholarly Insight:** Chooses from **4 Reward Cards** instead of 3 after any spar win. |
| **🟢 Green** | **Speed & Precision.** | **First Strike:** Applies a **+3 bonus** to their first attack card played in combat. | **Double Time:** Can **reject the free card** from the Campsite to gain an **extra dice roll** upon completion of the rest. |
| **🟡 Yellow** | **Durability & Damage Reduction.** | **Natural Resilience:** Passive **-1 damage reduction** from all incoming attacks. | **Strategic Insight:** After any spar win, the player can **reshuffle the presented Reward Cards** and draw a new set of 3/4 random cards from the pool. |

---

## VI. Core Gameplay Loop & Player Agency

This section breaks down the turn-by-turn gameplay loop and distinguishes between fixed game elements, player choices, and random variables.

### A. Turn Structure (24 Turns per Year)

| Step | Action | Detail |
| :--- | :--- | :--- |
| **1. Roll Dice** | The player initiates a dice roll to determine movement range. | This action costs **1 Turn**. |
| **2. Choose Path** | The player moves their Champion token on the map. | Movement must equal the number rolled on the dice. The map is non-linear, but there are ways to return to the start. |
| **3. Land on Space** | The Champion lands on a map space, triggering an event. | Events can include Sparring Sessions, Dojos, Hot Springs, etc. |

### B. Game Variables

| Element Type | Description | Examples |
| :--- | :--- | :--- |
| **Constants** | Core rules and structures that are fixed for every playthrough. | • Fixed World Map Layout<br>• 3-Year Course Structure<br>• Standard 24 Turns per Year<br>• Predetermined Starting Decks for each Champion |
| **Player Choices** | Key decisions the player makes to influence the outcome of the run. | • Selecting the starting Champion<br>• Choosing a path after a dice roll<br>• Purchasing items from the Dojo/Hot Spring<br>• Selecting a Reward Card after a victory<br>• Deciding when to use the Campsite to rest (limited uses) |
| **Random (RNG)** | Elements of chance that introduce unpredictability and replayability. | • Dice Roll result (1-6)<br>• Card options presented in post-combat Rewards<br>• Card draw order during combat<br>• Specific events on certain map spaces (e.g., rival encounters, shops, sparring) |

### C. Initial Card Game Concepts

| Mechanic | Initial Concept |
| :--- | :--- |
| **Deck Size** | Start with a 9-card deck; maximum deck size of 15. |
| **Starting Deck (Red Example)** | **3x** Attack (3 Dmg), **3x** Guard (2 Block), **1x** Power Up (+1 power this turn), **1x** Damage Over Time, **1x** Heavy Hit (5 Dmg). |
| **Turn Order** | A dice roll at the start of each combat turn determines who acts first. A higher roll goes first. |
| **AI Logic** | The AI prioritizes playing cards based on a hierarchy: highest mana cost first, then by color, with generic cards being the lowest priority. |
| **Combat Resolution** | Combat is simulated automatically turn-by-turn until one combatant's P-Magic is depleted. |

### D. Core Pillars of Fun

| Pillar | Description |
| :--- | :--- |
| **1. Nurturing** | Supporting and developing a favorite character, similar to a virtual pet or raising simulator (e.g., *Tamagotchi*, *Uma Musume*). |
| **2. Risk/Reward** | Experiencing the thrill of chance through dice rolls and random card draws, embracing a "gambling" feel. |
| **3. Satisfaction** | The deep satisfaction that comes from seeing a well-planned strategy, deck synergy, or a lucky combo work out perfectly. |

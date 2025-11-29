document.addEventListener('DOMContentLoaded', () => {
    const board = document.getElementById('game-board');
    const playerToken = document.getElementById('player-token');
    const rollDiceBtn = document.getElementById('roll-dice-btn');
    const diceResultDisplay = document.getElementById('dice-result');
    const turnDisplay = document.getElementById('turn-display');
    const yearDisplay = document.getElementById('year-display');
    const expeditionCampModal = document.getElementById('expedition-camp-modal');
    const titleMatchModal = document.getElementById('title-match-modal');
    const crossroadsModal = document.getElementById('crossroads-modal');
    const notificationContainer = document.getElementById('notification-container');
    let tooltipElement;

    // Based on readme.md
    const GRID_SIZE = 64;
    const MAX_TURNS = 24;
    let currentTurn = 1;
    let currentYear = 1;
    const COOK_INGREDIENT_COST = 2;

    // --- PALEO MAIDEN CHARACTER DATA (from combatprowess/script.js) ---
    const PALEO_MAIDENS = [
        {
            name: "Tyran Rex",
            discipline: "Brute",
            image: "../character_designs/tyrannosaurus_rex/Mugshot.png"
        },
        {
            name: "Kitadani Fukuira",
            discipline: "Focus",
            image: "../character_designs/fukuiraptor/Mugshot.png"
        },
        // {
        //     name: "Sastrei Taurus",
        //     discipline: "Flow",
        //     image: "../character_designs/carnotaurus/Mugshot.png"
        // },
        {
            name: "Aegypt Spino",
            discipline: "Focus",
            image: "../character_designs/spinosaurus/placeholder.png"
        },
        // Add other characters here if needed. For now, we need at least 3 for the selection.
        // {
        //     name: "Caza Amarga", // Assuming a name for the control discipline character
        //     discipline: "Control",
        //     image: "../character_designs/placeholder.png" // Placeholder image
        // }
    ];

    // --- PALEO ARTS DATA (from combatprowess/script.js) ---
    // This is needed to grant a random Paleo Art on interaction.
    const PALEOARTS_DATA = [
        { "name": "Ram", "type": "Paleo Art", "discipline": "Brute" },
        { "name": "Rush", "type": "Paleo Art", "discipline": "Brute" },
        { "name": "Pummel", "type": "Paleo Art", "discipline": "Brute" },
        { "name": "Aura Farm", "type": "Paleo Art", "discipline": "Brute" },
        { "name": "Retaliation", "type": "Paleo Art", "discipline": "Brute" },
        { "name": "Tyrant Divider", "type": "Secret Art", "discipline": "Brute" },
        // { "name": "Deinos Reaper", "type": "Ancient Art", "discipline": "Brute" },
        // { "name": "Glory to the King", "type": "Ancient Art", "discipline": ["Brute", "Focus"] },
        { "name": "Energy Wave", "type": "Paleo Art", "discipline": "Focus" },
        { "name": "Foresight Strike", "type": "Paleo Art", "discipline": "Focus" },
        { "name": "Guard", "type": "Paleo Art", "discipline": "Focus" },
        { "name": "Arcane Shield", "type": "Paleo Art", "discipline": "Focus" },
        { "name": "Meditate", "type": "Paleo Art", "discipline": "Focus" },
        // { "name": "A Sight to behold!", "type": "Secret Art", "discipline": "Focus" },
        // { "name": "Kime-Dachi, Senkō Sen!", "type": "Secret Art", "discipline": "Focus" },
        { "name": "Strike", "type": "Paleo Art", "discipline": "Flow" },
        { "name": "Weave", "type": "Paleo Art", "discipline": "Flow" },
        { "name": "Pounce", "type": "Paleo Art", "discipline": "Flow" },
        { "name": "Killrush", "type": "Paleo Art", "discipline": "Flow" },
        { "name": "Quick Step", "type": "Paleo Art", "discipline": "Flow" },
        // { "name": "Sastrei Carnage", "type": "Secret Art", "discipline": "Flow" },
        // { "name": "Diacera Hellion", "type": "Ancient Art", "discipline": ["Flow", "Focus"] },
        { "name": "Stone Skin", "type": "Paleo Art", "discipline": "Control" },
        { "name": "Taunt", "type": "Paleo Art", "discipline": "Control" },
        { "name": "Shatter", "type": "Paleo Art", "discipline": "Control" },
        { "name": "Battlecry", "type": "Paleo Art", "discipline": "Control" },
        { "name": "Grounded Stance", "type": "Paleo Art", "discipline": "Control" },
        // { "name": "Dicrae Style - Twin Crest Fang", "type": "Secret Art", "discipline": "Control" }
    ];

    // --- Player State ---
    let playerState = {
        maxPMagic: 100,
        currentPMagic: 100,
        maxAffinity: 100,
        currentAffinity: 0,
        techniques: {
            brute: 0,
            focus: 0,
            flow: 0,
            control: 0
        },
        mainDiscipline: 'flow', // Player's main discipline (brute, focus, flow, control)
        barterDeliveryPending: false,
        ingredients: 0, // Simplified to a single count for the prototype
    };

    let currentPlayerPosition = 'start'; // The ID of the current space
    let movablePaths = new Map(); // Stores destinationId -> path array

    // Define spaces as a graph. `connections` are the IDs of spaces you can move to.
    // Coordinates are based on the 64x64 grid.
    const SPACES = [
        { id: 'start', type: 'Start', biome: 'Coastal', coords: { x: 16, y: 59 }, connections: ['r56', 'n56', 'p53'] },
        // { id: 'path1', type: 'Wilderness', coords: { x: 13, y: 52 }, connections: ['path2'] },
        // { id: 'path2', type: 'Wilderness', coords: { x: 11, y: 48 }, connections: [''] },
        // { id: 'i2', type: 'Wilderness', coords: { x: 8, y: 2 }, connections: [''] },
        // { id: 'i8', type: 'Wilderness', coords: { x: 8, y: 8 }, connections: [''] },
        // { id: 'i14', type: 'Wilderness', coords: { x: 8, y: 14 }, connections: [''] },
        // { id: 'i20', type: 'Wilderness', coords: { x: 8, y: 20 }, connections: [''] },
        // { id: 'i26', type: 'Wilderness', coords: { x: 8, y: 26 }, connections: [''] },
        // { id: 'i32', type: 'Wilderness', coords: { x: 8, y: 32 }, connections: [''] },
        // { id: 'i38', type: 'Wilderness', coords: { x: 8, y: 38 }, connections: [''] },
        // { id: 'i44', type: 'Wilderness', coords: { x: 8, y: 44 }, connections: [''] },
        // { id: 'i50', type: 'Wilderness', coords: { x: 8, y: 50 }, connections: [''] },
        // { id: 'i56', type: 'Wilderness', coords: { x: 8, y: 56 }, connections: [''] },
        // { id: 'g5', type: 'Wilderness', coords: { x: 6, y: 5 }, connections: [''] },
        // { id: 'g11', type: 'Wilderness', coords: { x: 6, y: 11 }, connections: [''] },
        // { id: 'g17', type: 'Wilderness', coords: { x: 6, y: 17 }, connections: [''] },
        // { id: 'g23', type: 'Wilderness', coords: { x: 6, y: 23 }, connections: [''] },
        // { id: 'g29', type: 'Wilderness', coords: { x: 6, y: 29 }, connections: [''] },
        // { id: 'g35', type: 'Wilderness', coords: { x: 6, y: 35 }, connections: [''] },
        // { id: 'g41', type: 'Wilderness', coords: { x: 6, y: 41 }, connections: [''] },
        // { id: 'g47', type: 'Wilderness', coords: { x: 6, y: 47 }, connections: [''] },
        // { id: 'g53', type: 'Wilderness', coords: { x: 6, y: 53 }, connections: [''] },
        // Generated Columns from B to Z, skipping one column
        // { id: 'b2', type: 'Wilderness', coords: { x: 2, y: 2 }, connections: [''] },
        // { id: 'b8', type: 'Wilderness', coords: { x: 2, y: 8 }, connections: [''] },
        // { id: 'b14', type: 'Wilderness', coords: { x: 2, y: 14 }, connections: [''] },
        // { id: 'b20', type: 'Wilderness', coords: { x: 2, y: 20 }, connections: [''] },
        // { id: 'b26', type: 'Wilderness', coords: { x: 2, y: 26 }, connections: [''] },
        { id: 'b32', type: 'Title Match', biome: 'Volcanic', coords: { x: 2, y: 32 }, connections: [''] },
        { id: 'b38', type: 'Title Match', biome: 'Coastal', coords: { x: 2, y: 38 }, connections: [''] },
        // { id: 'b44', type: 'Wilderness', coords: { x: 2, y: 44 }, connections: [''] },
        // { id: 'b50', type: 'Wilderness', coords: { x: 2, y: 50 }, connections: [''] },
        // { id: 'b56', type: 'Wilderness', coords: { x: 2, y: 56 }, connections: [''] },
        // { id: 'd5', type: 'Wilderness', coords: { x: 4, y: 5 }, connections: [''] },
        // { id: 'd11', type: 'Wilderness', coords: { x: 4, y: 11 }, connections: [''] },
        // { id: 'd17', type: 'Wilderness', coords: { x: 4, y: 17 }, connections: [''] },
        { id: 'd23', type: 'Wilderness', biome: 'Desert', coords: { x: 4, y: 23 }, connections: ['f20'] },
        { id: 'd29', type: 'Wilderness', biome: 'Volcanic', coords: { x: 4, y: 29 }, connections: ['b32'] },
        // { id: 'd35', type: 'Wilderness', coords: { x: 4, y: 35 }, connections: [''] },
        { id: 'd41', type: 'Wilderness', biome: 'Coastal', coords: { x: 4, y: 41 }, connections: ['b38'] },
        // { id: 'd47', type: 'Wilderness', coords: { x: 4, y: 47 }, connections: [''] },
        // { id: 'd53', type: 'Wilderness', coords: { x: 4, y: 53 }, connections: [''] },
        { id: 'f2', type: 'Title Match', biome: 'Mountain', coords: { x: 6, y: 2 }, connections: [''] },
        // { id: 'f8', type: 'Wilderness', coords: { x: 6, y: 8 }, connections: [''] },
        // { id: 'f14', type: 'Wilderness', coords: { x: 6, y: 14 }, connections: [''] },
        { id: 'f20', type: 'Title Match', biome: 'Desert', coords: { x: 6, y: 20 }, connections: [''] },
        { id: 'f26', type: 'Wilderness', biome: 'Desert', coords: { x: 6, y: 26 }, connections: ['d29', 'd23'] },
        // { id: 'f32', type: 'Wilderness', coords: { x: 6, y: 32 }, connections: [''] },
        { id: 'f38', type: 'Wilderness', biome: 'Desert', coords: { x: 6, y: 38 }, connections: ['d41', 'h35'] },
        { id: 'f44', type: 'Wilderness', biome: 'Mountain', coords: { x: 6, y: 44 }, connections: ['f38'] },
        { id: 'f50', type: 'Title Match', biome: 'Coastal', coords: { x: 6, y: 50 }, connections: [''] },
        // { id: 'f56', type: 'Wilderness', coords: { x: 6, y: 56 }, connections: [''] },
        { id: 'h5', type: 'Wilderness', biome: 'Mountain', coords: { x: 8, y: 5 }, connections: ['f2'] },
        { id: 'h11', type: 'Wilderness', biome: 'Mountain', coords: { x: 8, y: 11 }, connections: ['j8'] },
        // { id: 'h17', type: 'Wilderness', coords: { x: 8, y: 17 }, connections: [''] },
        { id: 'h23', type: 'Wilderness', biome: 'Desert', coords: { x: 8, y: 23 }, connections: ['j20'] },
        { id: 'h29', type: 'Wilderness', biome: 'Desert', coords: { x: 8, y: 29 }, connections: ['f26'] },
        { id: 'h35', type: 'Wilderness', biome: 'Desert', coords: { x: 8, y: 35 }, connections: ['h29'] },
        // { id: 'h41', type: 'Wilderness', coords: { x: 8, y: 41 }, connections: [''] },
        { id: 'h47', type: 'Wilderness', biome: 'Desert', coords: { x: 8, y: 47 }, connections: ['f44'] },
        { id: 'h53', type: 'Wilderness', biome: 'Coastal', coords: { x: 8, y: 53 }, connections: ['f50', 'h47'] },
        { id: 'j2', type: 'Wilderness', biome: 'Mountain', coords: { x: 10, y: 2 }, connections: ['h5'] },
        { id: 'j8', type: 'Wilderness', biome: 'Mountain', coords: { x: 10, y: 8 }, connections: ['j2'] },
        { id: 'j14', type: 'Wilderness', biome: 'Desert', coords: { x: 10, y: 14 }, connections: ['h11'] },
        { id: 'j20', type: 'Wilderness', biome: 'Mountain', coords: { x: 10, y: 20 }, connections: ['l17'] },
        { id: 'j26', type: 'Wilderness', biome: 'Plains', coords: { x: 10, y: 26 }, connections: ['l23', 'h23'] },
        { id: 'j32', type: 'Wilderness', biome: 'Plains', coords: { x: 10, y: 32 }, connections: ['l29', 'h35'] },
        { id: 'j38', type: 'Wilderness', biome: 'Plains', coords: { x: 10, y: 38 }, connections: ['l35'] },
        { id: 'j44', type: 'Wilderness', biome: 'Desert', coords: { x: 10, y: 44 }, connections: ['h47', 'j38'] },
        // { id: 'j50', type: 'Wilderness', coords: { x: 10, y: 50 }, connections: [''] },
        { id: 'j56', type: 'Wilderness', biome: 'Mountain', coords: { x: 10, y: 56 }, connections: ['h53'] },
        // { id: 'l5', type: 'Wilderness', coords: { x: 12, y: 5 }, connections: [''] },
        { id: 'l11', type: 'Title Match', biome: 'Desert', coords: { x: 12, y: 11 }, connections: [''] },
        { id: 'l17', type: 'Wilderness', biome: 'Desert', coords: { x: 12, y: 17 }, connections: ['j14', 'n14', 'l11'] },
        { id: 'l23', type: 'Title Match', biome: 'Plains', coords: { x: 12, y: 23 }, connections: [''] },
        { id: 'l29', type: 'Wilderness', biome: 'Plains', coords: { x: 12, y: 29 }, connections: ['j26'] },
        { id: 'l35', type: 'Wilderness', biome: 'Plains', coords: { x: 12, y: 35 }, connections: ['j32'] },
        // { id: 'l41', type: 'Wilderness', coords: { x: 12, y: 41 }, connections: [''] },
        { id: 'l47', type: 'Wilderness', biome: 'Forest', coords: { x: 12, y: 47 }, connections: ['j44', 'n44'] },
        { id: 'l53', type: 'Wilderness', biome: 'Mountain', coords: { x: 12, y: 53 }, connections: ['l47'] },
        { id: 'l59', type: 'Wilderness', biome: 'Coastal', coords: { x: 12, y: 59 }, connections: ['j56'] },
        { id: 'n2', type: 'Title Match', biome: 'Tundra', coords: { x: 14, y: 2 }, connections: [''] },
        { id: 'n8', type: 'Wilderness', biome: 'Mountain', coords: { x: 14, y: 8 }, connections: ['p11'] },
        { id: 'n14', type: 'Wilderness', biome: 'Plains', coords: { x: 14, y: 14 }, connections: ['n8', 'n20'] },
        { id: 'n20', type: 'Wilderness', biome: 'Plains', coords: { x: 14, y: 20 }, connections: [''] },
        // { id: 'n26', type: 'Wilderness', coords: { x: 14, y: 26 }, connections: [''] },
        // { id: 'n32', type: 'Wilderness', coords: { x: 14, y: 32 }, connections: [''] },
        { id: 'n38', type: 'Title Match', biome: 'Forest', coords: { x: 14, y: 38 }, connections: [''] },
        { id: 'n44', type: 'Wilderness', biome: 'Forest', coords: { x: 14, y: 44 }, connections: ['n38'] },
        { id: 'n50', type: 'Wilderness', biome: 'Plains', coords: { x: 14, y: 50 }, connections: ['l53', 'p47'] },
        { id: 'n56', type: 'Wilderness', biome: 'Coastal', coords: { x: 14, y: 56 }, connections: ['l59'] },
        { id: 'p5', type: 'Wilderness', biome: 'Tundra', coords: { x: 16, y: 5 }, connections: ['n2', 'r2'] },
        { id: 'p11', type: 'Wilderness', biome: 'Tundra', coords: { x: 16, y: 11 }, connections: ['r8'] },
        // { id: 'p17', type: 'Wilderness', coords: { x: 16, y: 17 }, connections: [''] },
        { id: 'p23', type: 'Title Match', biome: 'Plains', coords: { x: 16, y: 23 }, connections: [''] },
        // { id: 'p29', type: 'Wilderness', coords: { x: 16, y: 29 }, connections: [''] },
        // { id: 'p35', type: 'Wilderness', coords: { x: 16, y: 35 }, connections: [''] },
        // { id: 'p41', type: 'Wilderness', coords: { x: 16, y: 41 }, connections: [''] },
        { id: 'p47', type: 'Title Match', biome: 'Plains', coords: { x: 16, y: 47 }, connections: [''] },
        { id: 'p53', type: 'Wilderness', biome: 'Plains', coords: { x: 16, y: 53 }, connections: ['n50'] },
        { id: 'r2', type: 'Wilderness', biome: 'Tundra', coords: { x: 18, y: 2 }, connections: [''] },
        { id: 'r8', type: 'Wilderness', biome: 'Tundra', coords: { x: 18, y: 8 }, connections: ['t11', 't5', 'p5'] },
        // { id: 'r14', type: 'Wilderness', coords: { x: 18, y: 14 }, connections: [''] },
        { id: 'r20', type: 'Wilderness', biome: 'Plains', coords: { x: 18, y: 20 }, connections: ['p23'] },
        // { id: 'r26', type: 'Wilderness', coords: { x: 18, y: 26 }, connections: [''] },
        // { id: 'r32', type: 'Wilderness', coords: { x: 18, y: 32 }, connections: [''] },
        // { id: 'r38', type: 'Wilderness', coords: { x: 18, y: 38 }, connections: [''] },
        // { id: 'r44', type: 'Wilderness', coords: { x: 18, y: 44 }, connections: [''] },
        // { id: 'r50', type: 'Wilderness', coords: { x: 18, y: 50 }, connections: [''] },
        { id: 'r56', type: 'Wilderness', biome: 'Tundra', coords: { x: 18, y: 56 }, connections: ['t53'] },
        { id: 't5', type: 'Wilderness', biome: 'Tundra', coords: { x: 20, y: 5 }, connections: ['v2'] },
        { id: 't11', type: 'Wilderness', biome: 'Plains', coords: { x: 20, y: 11 }, connections: ['t17'] },
        { id: 't17', type: 'Wilderness', biome: 'Plains', coords: { x: 20, y: 17 }, connections: ['r20'] },
        // { id: 't23', type: 'Wilderness', coords: { x: 20, y: 23 }, connections: [''] },
        // { id: 't29', type: 'Wilderness', coords: { x: 20, y: 29 }, connections: [''] },
        // { id: 't35', type: 'Wilderness', coords: { x: 20, y: 35 }, connections: [''] },
        // { id: 't41', type: 'Wilderness', coords: { x: 20, y: 41 }, connections: [''] },
        { id: 't47', type: 'Title Match', biome: 'Tundra', coords: { x: 20, y: 47 }, connections: [''] },
        { id: 't53', type: 'Wilderness', biome: 'Tundra', coords: { x: 20, y: 53 }, connections: ['v50'] },
        { id: 'v2', type: 'Wilderness', biome: 'Tundra', coords: { x: 22, y: 2 }, connections: ['x5', 'v8'] },
        { id: 'v8', type: 'Wilderness', biome: 'Tundra', coords: { x: 22, y: 8 }, connections: ['x11'] },
        // { id: 'v14', type: 'Wilderness', coords: { x: 22, y: 14 }, connections: [''] },
        // { id: 'v20', type: 'Wilderness', coords: { x: 22, y: 20 }, connections: [''] },
        // { id: 'v26', type: 'Wilderness', coords: { x: 22, y: 26 }, connections: [''] },
        // { id: 'v32', type: 'Wilderness', coords: { x: 22, y: 32 }, connections: [''] },
        // { id: 'v38', type: 'Wilderness', coords: { x: 22, y: 38 }, connections: [''] },
        // { id: 'v44', type: 'Wilderness', coords: { x: 22, y: 44 }, connections: [''] },
        { id: 'v50', type: 'Wilderness', biome: 'Tundra', coords: { x: 22, y: 50 }, connections: ['t47'] },
        // { id: 'v56', type: 'Wilderness', coords: { x: 22, y: 56 }, connections: [''] },
        { id: 'x5', type: 'Title Match', biome: 'Tundra', coords: { x: 24, y: 5 }, connections: [''] },
        { id: 'x11', type: 'Wilderness', biome: 'Mountain', coords: { x: 24, y: 11 }, connections: ['z14'] },
        // { id: 'x17', type: 'Wilderness', coords: { x: 24, y: 17 }, connections: [''] },
        // { id: 'x23', type: 'Wilderness', coords: { x: 24, y: 23 }, connections: [''] },
        // { id: 'x29', type: 'Wilderness', coords: { x: 24, y: 29 }, connections: [''] },
        // { id: 'x35', type: 'Wilderness', coords: { x: 24, y: 35 }, connections: [''] },
        // { id: 'x41', type: 'Wilderness', coords: { x: 24, y: 41 }, connections: [''] },
        // { id: 'x47', type: 'Wilderness', coords: { x: 24, y: 47 }, connections: [''] },
        // { id: 'x53', type: 'Wilderness', coords: { x: 24, y: 53 }, connections: [''] },
        // { id: 'z2', type: 'Wilderness', coords: { x: 26, y: 2 }, connections: [''] },
        // { id: 'z8', type: 'Wilderness', coords: { x: 26, y: 8 }, connections: [''] },
        { id: 'z14', type: 'Wilderness', biome: 'Mountain', coords: { x: 26, y: 14 }, connections: ['aa11'] },
        // { id: 'z20', type: 'Wilderness', coords: { x: 26, y: 20 }, connections: [''] },
        // { id: 'z26', type: 'Wilderness', coords: { x: 26, y: 26 }, connections: [''] },
        { id: 'z32', type: 'Title Match', biome: 'Coastal', coords: { x: 26, y: 32 }, connections: [''] },
        { id: 'z38', type: 'Title Match', biome: 'Forest', coords: { x: 26, y: 38 }, connections: [''] },
        // { id: 'z44', type: 'Wilderness', coords: { x: 26, y: 44 }, connections: [''] },
        // { id: 'z50', type: 'Wilderness', coords: { x: 26, y: 50 }, connections: [''] },
        // { id: 'z56', type: 'Wilderness', coords: { x: 26, y: 56 }, connections: [''] },
        // { id: 'aa5', type: 'Wilderness', coords: { x: 28, y: 5 }, connections: [''] },
        { id: 'aa11', type: 'Wilderness', biome: 'Mountain', coords: { x: 28, y: 11 }, connections: ['aa17'] },
        { id: 'aa17', type: 'Wilderness', biome: 'Mountain', coords: { x: 28, y: 17 }, connections: ['ab14'] },
        // { id: 'aa23', type: 'Wilderness', coords: { x: 28, y: 23 }, connections: [''] },
        // { id: 'aa29', type: 'Wilderness', coords: { x: 28, y: 29 }, connections: [''] },
        { id: 'aa35', type: 'Wilderness', biome: 'Forest', coords: { x: 28, y: 35 }, connections: ['z32', 'ab38'] },
        { id: 'aa41', type: 'Wilderness', biome: 'Forest', coords: { x: 28, y: 41 }, connections: ['z38'] },
        // { id: 'aa47', type: 'Wilderness', coords: { x: 28, y: 47 }, connections: [''] },
        // { id: 'aa53', type: 'Wilderness', coords: { x: 28, y: 53 }, connections: [''] },
        // { id: 'ab2', type: 'Wilderness', coords: { x: 30, y: 2 }, connections: [''] },
        // { id: 'ab8', type: 'Wilderness', coords: { x: 30, y: 8 }, connections: [''] },
        { id: 'ab14', type: 'Wilderness', biome: 'Mountain', coords: { x: 30, y: 14 }, connections: ['ac17', 'ab20'] },
        { id: 'ab20', type: 'Wilderness', biome: 'Mountain', coords: { x: 30, y: 20 }, connections: ['ab26'] },
        { id: 'ab26', type: 'Wilderness', biome: 'Forest', coords: { x: 30, y: 26 }, connections: ['ab32'] },
        { id: 'ab32', type: 'Wilderness', biome: 'Forest', coords: { x: 30, y: 32 }, connections: ['aa35', 'ab38'] },
        { id: 'ab38', type: 'Wilderness', biome: 'Forest', coords: { x: 30, y: 38 }, connections: ['aa41'] },
        // { id: 'ab44', type: 'Wilderness', coords: { x: 30, y: 44 }, connections: [''] },
        // { id: 'ab50', type: 'Wilderness', coords: { x: 30, y: 50 }, connections: [''] },
        // { id: 'ab56', type: 'Wilderness', coords: { x: 30, y: 56 }, connections: [''] },
        // { id: 'ac5', type: 'Wilderness', coords: { x: 32, y: 5 }, connections: [''] },
        // { id: 'ac11', type: 'Wilderness', coords: { x: 32, y: 11 }, connections: [''] },
        { id: 'ac17', type: 'Title Match', biome: 'Mountain', coords: { x: 32, y: 17 }, connections: [''] },




        // { id: 'cross1', type: 'Crossroads', coords: { x: 13, y: 42 }, connections: ['path2a', ''] },
        // { id: 'facility1', type: 'Title Match', coords: { x: 10, y: 38 }, connections: [''] },


        // // Branch A
        // { id: 'path2a', type: 'Wilderness', coords: { x: 15, y: 32 }, connections: ['milestone1'] },
        // { id: 'milestone1', type: 'Academic Milestone', coords: { x: 12, y: 25 }, connections: ['path3a'] },
        // { id: 'path3a', type: 'Wilderness', coords: { x: 18, y: 20 }, connections: ['cross2'] },

        // // Branch B
        // { id: 'path2b', type: 'Wilderness', coords: { x: 8, y: 32 }, connections: ['path3b'] },
        // { id: 'path3b', type: 'Wilderness', coords: { x: 13, y: 20 }, connections: ['cross2'] },

        // // Paths merge
        // { id: 'cross2', type: 'Crossroads', coords: { x: 22, y: 14 }, connections: ['title1'] },
        // // { id: 'title1', type: 'Title Match', coords: { x: 27, y: 27 }, connections: ['path4'] },
        // { id: 'path4', type: 'Wilderness', coords: { x: 31, y_NEVER_USE: 31, y: 31 }, connections: ['path5'] },
        // { id: 'path5', type: 'Wilderness', coords: { x: 31, y: 40 }, connections: ['cross3'] },
        // { id: 'cross3', type: 'Crossroads', coords: { x: 35, y: 48 }, connections: ['path6a', 'path6b'] },

        // // Branch A2
        // { id: 'path6a', type: 'Wilderness', coords: { x: 32, y: 55 }, connections: ['milestone2'] },
        // { id: 'milestone2', type: 'Academic Milestone', coords: { x: 38, y: 51 }, connections: ['path7'] },

        // // Branch B2
        // { id: 'path6b', type: 'Wilderness', coords: { x: 40, y: 45 }, connections: ['path7'] },

        // // Final path back to start
        // { id: 'path7', type: 'Wilderness', coords: { x: 25, y: 55 }, connections: ['start'] },
    ];
    function createGridAndCoords(gridSize = 10) {
        const gridOverlay = document.getElementById('grid-overlay');
        if (!gridOverlay) return;

        // Create Grid Lines
        for (let i = 1; i < gridSize; i++) {
            const verticalLine = document.createElement('div');
            verticalLine.className = 'grid-line vertical';
            verticalLine.style.left = `${i * (100 / gridSize)}%`;
            gridOverlay.appendChild(verticalLine);

            const horizontalLine = document.createElement('div');
            horizontalLine.className = 'grid-line horizontal';
            horizontalLine.style.top = `${i * (100 / gridSize)}%`;
            gridOverlay.appendChild(horizontalLine);
        }
    }

    function logMessage(message, type = 'info') {
        // This function now creates a visual notification pop-up.
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.innerHTML = message; // Use innerHTML to allow for styled spans

        notificationContainer.appendChild(notification);

        // The fade-out animation is 0.5s, and it starts after 3.5s.
        // We remove the element after 4s total to let the animation finish.
        setTimeout(() => {
            notification.remove();
        }, 4000);
    }
    function gridToPercentage(coords) {
        return {
            left: `${(coords.x + 0.5) / GRID_SIZE * 100}%`,
            top: `${(coords.y + 0.5) / GRID_SIZE * 100}%`,
        };
    }

    function createSpaces() {
        SPACES.forEach((spaceData) => {
            const spaceEl = document.createElement('div');
            const typeClass = spaceData.type.toLowerCase().replace(/ /g, '-');
            let classes = ['space', typeClass];
            if (spaceData.biome) {
                classes.push(`biome-${spaceData.biome.toLowerCase()}`);
            }
            spaceEl.className = classes.join(' ');

            const pos = gridToPercentage(spaceData.coords);
            spaceEl.style.top = pos.top;
            spaceEl.style.left = pos.left;
            spaceEl.dataset.spaceId = spaceData.id;

            const idLabel = document.createElement('span');
            idLabel.className = 'space-id-label';
            idLabel.textContent = spaceData.id;
            idLabel.style.pointerEvents = 'none'; // Make label click-through
            spaceEl.appendChild(idLabel);

            // Add tooltip events
            spaceEl.addEventListener('mouseenter', (e) => showTooltip(e, spaceData));
            spaceEl.addEventListener('mouseleave', hideTooltip);

            board.appendChild(spaceEl);
        });
    }

    function drawConnections() {
        const svgLayer = document.getElementById('connections-layer');
        const defs = svgLayer.querySelector('defs');

        // Create an arrowhead marker
        const marker = document.createElementNS('http://www.w3.org/2000/svg', 'marker');
        marker.setAttribute('id', 'arrowhead');
        marker.setAttribute('viewBox', '0 0 10 10');
        marker.setAttribute('refX', '8');
        marker.setAttribute('refY', '5');
        marker.setAttribute('markerWidth', '6');
        marker.setAttribute('markerHeight', '6');
        marker.setAttribute('orient', 'auto-start-reverse');
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', 'M 0 0 L 10 5 L 0 10 z');
        path.setAttribute('fill', 'rgba(229, 255, 0, 0.5)');
        marker.appendChild(path);
        defs.appendChild(marker);

        SPACES.forEach(startSpace => {
            if (!startSpace.connections) return;
            const startPos = gridToPercentage(startSpace.coords);

            startSpace.connections.forEach(endSpaceId => {
                const endSpace = SPACES.find(s => s.id === endSpaceId);
                if (!endSpace) return;
                const endPos = gridToPercentage(endSpace.coords);

                const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                line.setAttribute('x1', startPos.left);
                line.setAttribute('y1', startPos.top);
                line.setAttribute('x2', endPos.left);
                line.setAttribute('y2', endPos.top);
                line.setAttribute('stroke', 'rgba(255, 255, 255, 0.91)');
                line.setAttribute('stroke-width', '2');
                line.setAttribute('marker-end', 'url(#arrowhead)');
                svgLayer.appendChild(line);
            });
        });
    }

    /**
     * Moves the player token along a given path of space IDs.
     * @param {string[]} path - An array of space IDs, e.g., ['start', 'p53', 'n50']
     */
    async function animateTokenAlongPath(path) {
        if (!path || path.length < 2) return;

        // Disable dice button during movement
        rollDiceBtn.disabled = true;
        playerToken.style.animationPlayState = 'paused'; // Pause breathing during movement

        // The first element is the start, so we iterate from the second
        for (let i = 1; i < path.length; i++) {
            const spaceId = path[i];
            const targetSpaceData = SPACES.find(s => s.id === spaceId);
            if (targetSpaceData) {
                const pos = gridToPercentage(targetSpaceData.coords);
                playerToken.style.top = pos.top;
                playerToken.style.left = pos.left;

                // Wait for the CSS transition to finish (duration is 0.4s)
                await new Promise(resolve => setTimeout(resolve, 400));
            }
        }

        // After the final move, update the game state
        const finalDestinationId = path[path.length - 1];
        updatePlayerPosition(finalDestinationId, false); // Update state without animating

        // Trigger the landing bounce animation
        playerToken.classList.add('landing');
        playerToken.addEventListener('animationend', () => {
            playerToken.classList.remove('landing');
        }, { once: true });

        endTurn();
        rollDiceBtn.disabled = false;
        playerToken.style.animationPlayState = 'running'; // Resume breathing
    }

    function updatePlayerPosition(spaceId, shouldAnimate = true, triggerEvents = true) {
        currentPlayerPosition = spaceId;
        const targetSpaceData = SPACES.find(s => s.id === spaceId);
        if (!targetSpaceData) return;

        // This part now just handles the visual state update (current class, etc.)
        // The movement animation is handled by animateTokenAlongPath
        // The animation is handled by animateTokenAlongPath
        const pos = gridToPercentage(targetSpaceData.coords);
        playerToken.style.transition = shouldAnimate ? 'top 0.4s ease-in-out, left 0.4s ease-in-out' : 'none';
        playerToken.style.top = pos.top;
        playerToken.style.left = pos.left;
        playerToken.style.pointerEvents = 'none'; // Make token click-through

        // Use a short delay to allow the transition property to be set before moving
        setTimeout(() => {
            playerToken.style.transition = 'top 0.4s ease-in-out, left 0.4s ease-in-out';

            document.querySelectorAll('.space.current').forEach(el => el.classList.remove('current'));
            const spaceEl = document.querySelector(`[data-space-id="${spaceId}"]`);
            if (spaceEl) {
                spaceEl.classList.add('current');
            }

            if (triggerEvents) { // Only trigger event on a real move
                triggerSpaceEvent(targetSpaceData);
            }
        }, 20);
    }

    function showTooltip(event, spaceData) {
        const distance = findShortestPathDistance(currentPlayerPosition, spaceData.id);
        let tooltipText = `Type: ${spaceData.type}\nBiome: ${spaceData.biome || 'N/A'}`;

        if (distance === 0) {
            tooltipText += "\n(Current Location)";
        } else if (distance > 0) {
            tooltipText += `\nDistance: ${distance} moves`;
        } else {
            tooltipText += "\n(Unreachable)";
        }

        tooltipElement.innerText = tooltipText; // Use innerText to respect newlines
        tooltipElement.style.display = 'block';

        // Position tooltip near the cursor
        // The offsets (e.g., +15) prevent the tooltip from flickering by being under the cursor
        let x = event.clientX + 15;
        let y = event.clientY + 15;

        // Prevent tooltip from going off-screen
        if (x + tooltipElement.offsetWidth > window.innerWidth) {
            x = event.clientX - tooltipElement.offsetWidth - 15;
        }
        if (y + tooltipElement.offsetHeight > window.innerHeight) {
            y = event.clientY - tooltipElement.offsetHeight - 15;
        }

        tooltipElement.style.left = `${x}px`;
        tooltipElement.style.top = `${y}px`;
    }

    function hideTooltip() {
        tooltipElement.style.display = 'none';
    }

    function findShortestPathDistance(startId, endId) {
        if (startId === endId) {
            return 0;
        }

        const spaceMap = new Map(SPACES.map(space => [space.id, space]));
        let queue = [{ id: startId, distance: 0 }];
        let visited = new Set([startId]);

        while (queue.length > 0) {
            const { id: currentId, distance } = queue.shift();

            const currentSpace = spaceMap.get(currentId);
            if (currentSpace && currentSpace.connections) {
                for (const neighborId of currentSpace.connections) {
                    if (neighborId === endId) {
                        return distance + 1;
                    }
                    if (!visited.has(neighborId)) {
                        visited.add(neighborId);
                        queue.push({ id: neighborId, distance: distance + 1 });
                    }
                }
            }
        }
        return -1; // Indicates no path found
    }

    function triggerSpaceEvent(spaceData) {
        logMessage(`Landed on: ${spaceData.type}`, 'event');
        switch (spaceData.type) {
            case 'Start':
                logMessage("Time to begin your journey!", 'info');
                break;
            case 'Wilderness':
                if (Math.random() < 0.15) {
                    logMessage("A chance encounter on the trail!", 'event');
                    triggerCrossroadsEvent();
                } else {
                    showExpeditionCamp();
                }
                break;
            case 'Crossroads':
                triggerCrossroadsEvent();
                break;
            case 'Academic Milestone':
                logMessage("An Academic Milestone! A tough spar awaits to qualify for the League Exam.", 'warning');
                break;
            case 'Title Match':
                showTitleMatch(spaceData);
                break;
        }
    }

    function triggerCrossroadsEvent() {
        const rivalDisplay = crossroadsModal.querySelector('#crossroads-rival-display');
        rivalDisplay.innerHTML = ''; // Clear previous rival

        // --- Select a Random Rival ---
        const rival = PALEO_MAIDENS[Math.floor(Math.random() * PALEO_MAIDENS.length)];

        rivalDisplay.innerHTML = `
            <img src="${rival.image}" alt="${rival.name}">
            <div class="rival-name">${rival.name}</div>
        `;

        // Store the rival's data on the modal for the action handlers to use
        crossroadsModal.dataset.rivalName = rival.name;
        crossroadsModal.dataset.rivalDiscipline = rival.discipline;

        logMessage(`You've encountered ${rival.name} on the road!`, 'event');
        crossroadsModal.classList.add('visible');
    }

    function hideCrossroadsModal() {
        crossroadsModal.classList.remove('visible');
    }

    function handleCrossroadsAction(action) {
        const rivalName = crossroadsModal.dataset.rivalName;
        hideCrossroadsModal();

        if (action === 'interact') {
            const rivalDiscipline = crossroadsModal.dataset.rivalDiscipline;
            const rivalDisciplineLower = rivalDiscipline.toLowerCase();
            const possibleArts = PALEOARTS_DATA.filter(art => art.type === 'Paleo Art' && art.discipline.toLowerCase() === rivalDisciplineLower);

            if (possibleArts.length > 0) {
                const learnedArt = possibleArts[Math.floor(Math.random() * possibleArts.length)];
                playerState.techniques[rivalDisciplineLower]++;
                logMessage(`Inspired by ${rivalName}, you learned the <span class="text-${rivalDiscipline}">${learnedArt.name}</span> technique!`, 'reward');
                updateStatusUI(); // This was missing
            } else {
                logMessage(`You share a moment with ${rivalName}. A new bond is formed.`, 'reward');
            }

            // Per the GDD, this is a free action, so the player can continue their turn.
            showExpeditionCamp();
        } else if (action === 'challenge') {
            logMessage(`You challenge ${rivalName} to a friendly spar! Redirecting to combat...`, 'action');
            // Redirect to the combat screen after a short delay for the message to be read.
            setTimeout(() => {
                window.location.href = '../combatprowess_prototype/index.html';
            }, 1500);
        } else { // 'leave'
            logMessage(`You wave goodbye to ${rivalName} and continue on your way.`, 'info');
            // Per the GDD, this is a free action, so the player can continue their turn.
            showExpeditionCamp();
        }
    }

    function showExpeditionCamp() {
        // Disable buttons based on player state
        const cookButton = expeditionCampModal.querySelector('button[data-action="cook"]');
        const barterButton = expeditionCampModal.querySelector('button[data-action="barter"]');

        cookButton.disabled = playerState.ingredients < COOK_INGREDIENT_COST;
        barterButton.disabled = playerState.ingredients < 1;

        // Only show the initial message if the modal isn't already visible
        if (!expeditionCampModal.classList.contains('visible')) {
            logMessage("Made camp in the wilderness. Choose an action.", 'info');
        }
        expeditionCampModal.classList.add('visible');
    }

    function hideExpeditionCamp() {
        expeditionCampModal.classList.remove('visible');
    }

    function showTitleMatch(spaceData) {
        const titleNameEl = titleMatchModal.querySelector('#title-match-name');
        const aspirantsContainer = titleMatchModal.querySelector('#title-match-aspirants');
        aspirantsContainer.innerHTML = ''; // Clear previous aspirants

        // --- Generate Title Name based on Biome ---
        const biomeTitles = {
            'Volcanic': 'The Infernal Gauntlet',
            'Coastal': 'The Shoreline Scuffle',
            'Mountain': 'The Summit Scramble',
            'Desert': 'The Sun-Scorched Duel',
            'Plains': 'The Grassland Grapple',
            'Forest': 'The Verdant Clash',
            'Tundra': 'The Frostbitten Feud',
            'Default': 'Grand Title Match'
        };
        const titleName = biomeTitles[spaceData.biome] || biomeTitles['Default'];
        titleNameEl.textContent = titleName;

        // --- Select 3 Random Aspirants ---
        const shuffledMaidens = [...PALEO_MAIDENS].sort(() => 0.5 - Math.random());
        const selectedAspirants = shuffledMaidens.slice(0, 3);

        selectedAspirants.forEach(aspirant => {
            const card = document.createElement('div');
            card.className = 'aspirant-card';
            card.dataset.aspirantName = aspirant.name;
            card.innerHTML = `
                <img src="${aspirant.image}" alt="${aspirant.name}">
                <div class="aspirant-name">${aspirant.name}</div>
            `;
            card.addEventListener('click', () => handleAspirantSelection(aspirant));
            aspirantsContainer.appendChild(card);
        });

        logMessage(`Arrived at ${titleName}. Choose an opponent!`, 'event');
        titleMatchModal.classList.add('visible');
    }

    function hideTitleMatch() {
        titleMatchModal.classList.remove('visible');
    }

    function handleAspirantSelection(aspirant) {
        logMessage(`You chose to fight ${aspirant.name}! Redirecting to combat...`, 'action');
        hideTitleMatch();

        // Add a small delay to allow the player to read the message before redirecting
        setTimeout(() => {
            // Redirect to the combat prowess prototype page
            window.location.href = '../combatprowess_prototype/index.html';
        }, 1500);
    }

    function handleTitleMatchLeave() {
        hideTitleMatch();
        enableDiceRoll(); // Allow the player to roll again if they leave
    }

    function enableDiceRoll() {
        rollDiceBtn.disabled = false;
        triggerUIAnimation(rollDiceBtn);
    }

    function triggerUIAnimation(element) {
        if (!element) return;
        // Remove the class if it's already there to restart the animation
        element.classList.remove('highlight-update');
        // A tiny delay is needed for the browser to recognize the class removal before adding it again
        void element.offsetWidth; // This forces a browser reflow
        element.classList.add('highlight-update');
    }

    function updateStatusUI() {
        // Update P-Magic
        playerState.currentPMagic = Math.max(0, Math.min(playerState.currentPMagic, playerState.maxPMagic));
        const pMagicPercentage = (playerState.currentPMagic / playerState.maxPMagic) * 100;
        document.getElementById('pmagic-bar').style.width = `${pMagicPercentage}%`;
        document.getElementById('pmagic-value').textContent = `${playerState.currentPMagic} / ${playerState.maxPMagic}`;

        // Update Affinity
        playerState.currentAffinity = Math.max(0, Math.min(playerState.currentAffinity, playerState.maxAffinity));
        const affinityPercentage = (playerState.currentAffinity / playerState.maxAffinity) * 100;
        const affinityBar = document.getElementById('affinity-bar');
        affinityBar.style.width = `${affinityPercentage}%`;
        document.getElementById('affinity-value').textContent = `${playerState.currentAffinity} / ${playerState.maxAffinity}`;

        // Update Technique Counts
        ['brute', 'focus', 'flow', 'control'].forEach(tech => {
            const countEl = document.getElementById(`${tech}-count`);
            const newValue = playerState.techniques[tech];
            const oldValue = parseInt(countEl.textContent, 10);

            if (newValue > oldValue) {
                triggerUIAnimation(countEl.closest('.tech-count'));
            }
            countEl.textContent = newValue;
        });

        // Update Main Discipline
        const disciplineNameEl = document.getElementById('discipline-name');
        if (disciplineNameEl) {
            const discipline = playerState.mainDiscipline;
            disciplineNameEl.textContent = discipline;
            disciplineNameEl.className = `tech-count ${discipline}`;
        }

        // Update Inventory
        const ingredientCountEl = document.getElementById('ingredient-count');
        const newIngredients = playerState.ingredients;
        const oldIngredients = parseInt(ingredientCountEl.textContent, 10);

        if (newIngredients > oldIngredients) {
            triggerUIAnimation(ingredientCountEl.closest('#inventory-display'));
        }
        ingredientCountEl.textContent = newIngredients;
    }

    function handleCampAction(action) {
        let endsTurn = false; // Camp actions no longer end the turn by default.

        switch (action) {
            case 'train':
                {
                    logMessage("You chose to Train.", 'action');
                    const currentSpaceData = SPACES.find(s => s.id === currentPlayerPosition);
                    hideExpeditionCamp();
                    const currentBiome = currentSpaceData ? currentSpaceData.biome : 'Wilderness';
                    const discipline = playerState.mainDiscipline;

                    const biomeAffinities = {
                        brute: { advantage: ['Volcanic', 'Mountain'], disadvantage: ['Tundra', 'Coastal'] },
                        focus: { advantage: ['Coastal', 'Tundra'], disadvantage: ['Volcanic', 'Desert'] },
                        flow: { advantage: ['Plains', 'Forest'], disadvantage: ['Mountain', 'Volcanic'] },
                        control: { advantage: ['Desert', 'Mountain'], disadvantage: ['Forest', 'Plains'] }
                    };

                    const affinity = biomeAffinities[discipline];
                    let pMagicCost = 7; // Standard cost
                    let costMessage = `Training in the ${currentBiome}`;

                    if (affinity.advantage.includes(currentBiome)) {
                        pMagicCost = 3; // Advantage cost
                        costMessage = `Training in your element (${currentBiome}) was efficient`;
                    } else if (affinity.disadvantage.includes(currentBiome)) {
                        pMagicCost = 12; // Disadvantage cost
                        costMessage = `Training in a harsh biome (${currentBiome}) was draining`;
                    }

                    if (playerState.currentPMagic > pMagicCost) {
                        playerState.currentPMagic -= pMagicCost;
                        const learnedDiscipline = playerState.mainDiscipline; // Always learn the main discipline
                        playerState.techniques[learnedDiscipline]++;
                        logMessage(`${costMessage}, costing ${pMagicCost} P-Magic. Learned a <span class="text-${learnedDiscipline}">${learnedDiscipline}</span> technique!`, 'reward');
                    } else {
                        let errorMsg = `Not enough P-Magic to train in the ${currentBiome}. You need ${pMagicCost}.`;
                        if (affinity.advantage.includes(currentBiome)) {
                            errorMsg = `Even with an advantage, you lack the ${pMagicCost} P-Magic to train.`;
                        } else if (affinity.disadvantage.includes(currentBiome)) {
                            errorMsg = `This biome is too harsh. You need ${pMagicCost} P-Magic to train here.`;
                        }
                        logMessage(errorMsg, 'error');
                    }
                    break;
                }
            case 'forage':
                {
                    logMessage("You chose to Forage.", 'action');
                    const currentSpaceData = SPACES.find(s => s.id === currentPlayerPosition);
                    hideExpeditionCamp();
                    const currentBiome = currentSpaceData ? currentSpaceData.biome : 'Wilderness';

                    let pMagicCost = 10; // Standard cost
                    let techniqueFindChance = 0.20; // Standard 20% chance

                    const harshBiomes = ['Volcanic', 'Mountain', 'Tundra', 'Desert'];
                    if (harshBiomes.includes(currentBiome)) {
                        pMagicCost = 20; // High risk
                        techniqueFindChance = 0.50; // High reward (50% chance)
                    }

                    playerState.currentPMagic -= pMagicCost;

                    let ingredientsFound;
                    switch (currentBiome) {
                        case 'Forest':
                        case 'Coastal':
                        case 'Plains':
                            ingredientsFound = Math.floor(Math.random() * 3) + 2; // Bountiful: 2-4 ingredients
                            break;
                        case 'Desert':
                        case 'Tundra':
                        case 'Volcanic':
                        case 'Mountain':
                            ingredientsFound = Math.floor(Math.random() * 2) + 1; // Sparse: 1-2 ingredients
                            break;
                        default:
                            ingredientsFound = Math.floor(Math.random() * 3) + 1; // Standard: 1-3 ingredients
                    }

                    playerState.ingredients += ingredientsFound;
                    let forageMessage = `Foraging in the ${currentBiome} cost ${pMagicCost} P-Magic and yielded ${ingredientsFound} ingredients.`;

                    // Add a 20% chance to find a biome-specific technique
                    if (Math.random() < techniqueFindChance) {
                        const biomeTechniqueMap = {
                            'Volcanic': 'brute',
                            'Mountain': 'brute',
                            'Coastal': 'focus',
                            'Tundra': 'focus',
                            'Plains': 'flow',
                            'Forest': 'flow',
                            'Desert': 'control',
                        };

                        const foundTechnique = biomeTechniqueMap[currentBiome];
                        if (foundTechnique) {
                            playerState.techniques[foundTechnique]++;
                            forageMessage += `\nYou also learned a <span class="text-${foundTechnique}">${foundTechnique}</span> technique!`;
                        }
                    }

                    logMessage(forageMessage, 'reward');
                    break;
                }
            case 'cook':
                {
                    logMessage("You chose to Cook.", 'action');
                    hideExpeditionCamp();
                    if (playerState.ingredients >= COOK_INGREDIENT_COST) {
                        playerState.ingredients -= COOK_INGREDIENT_COST;
                        const pMagicHealed = 25;
                        const affinityGained = 5;
                        playerState.currentPMagic = Math.min(playerState.maxPMagic, playerState.currentPMagic + pMagicHealed);
                        playerState.currentAffinity = Math.min(playerState.maxAffinity, playerState.currentAffinity + affinityGained);
                        logMessage(`Cooked a meal. Recovered ${pMagicHealed} P-Magic and gained ${affinityGained} Affinity.`, 'reward');
                        triggerUIAnimation(document.getElementById('affinity-bar').parentElement);
                    } else {
                        logMessage("Not enough Ingredients to cook a meal.", 'error');
                    }
                    break;
                }
            case 'barter':
                {
                    logMessage("You chose to Barter.", 'action');
                    if (playerState.ingredients >= 1) {
                        playerState.ingredients -= 1;
                        playerState.barterDeliveryPending = true;
                        logMessage("Traded 1 Ingredient for a future delivery. It will arrive next turn.", 'reward');

                        // Disable the barter button for this camp session
                        expeditionCampModal.querySelector('button[data-action="barter"]').disabled = true;
                    } else {
                        logMessage("Not enough ingredients to barter.", 'error');
                    }
                    // This is a free action within the camp; it does not end the turn or close the modal.
                    endsTurn = false;
                    break;
                }
        }

        updateStatusUI();

        // Re-enable dice roll after a camp action is completed.
        enableDiceRoll();
    }

    function highlightPath(start, count) {
        // This function is now used to find and highlight possible moves
        // We use a queue to store objects with the space ID and its current path
        let queue = [{ spaceId: start, path: [start] }];
        let finalDestinations = new Set(); // Use a Set to store unique destination IDs

        movablePaths.clear(); // Clear old paths before calculating new ones
        while (queue.length > 0) {
            const { spaceId, path } = queue.shift();

            // If the path length equals the dice roll, we've found a valid destination
            if (path.length - 1 === count) {
                finalDestinations.add(spaceId);
                movablePaths.set(spaceId, path); // Store the full path
                continue; // Don't explore further from this path
            }

            const spaceData = SPACES.find(s => s.id === spaceId);
            if (spaceData && spaceData.connections) {
                for (const neighborId of spaceData.connections) {
                    // Only add the neighbor to the queue if it's not already in the current path
                    if (!path.includes(neighborId)) {
                        queue.push({ spaceId: neighborId, path: [...path, neighborId] });
                    }
                }
            }
        }

        document.querySelectorAll('.space.selectable').forEach(el => el.classList.remove('selectable'));

        finalDestinations.forEach(spaceId => {
            const spaceEl = document.querySelector(`[data-space-id="${spaceId}"]`);
            if (spaceEl) {
                spaceEl.classList.add('selectable');
                spaceEl.onclick = () => handleMoveSelection(spaceId);
            }
        });

        if (finalDestinations.size === 0) {
            logMessage("No valid moves from this location.", "error");
            enableDiceRoll();
        }
    }

    function rollDice() {
        if (currentTurn > MAX_TURNS) {
            logMessage("Year has ended. Cannot move.", "error");
            return;
        }

        rollDiceBtn.disabled = true;
        diceResultDisplay.classList.add('rolling');

        let rollCount = 0;
        const rollAnimation = setInterval(() => {
            diceResultDisplay.textContent = Math.floor(Math.random() * 6) + 1;
            rollCount++;
            if (rollCount > 10) {
                clearInterval(rollAnimation);
                const finalRoll = Math.floor(Math.random() * 6) + 1;
                diceResultDisplay.textContent = finalRoll;
                diceResultDisplay.classList.remove('rolling');
                logMessage(`Rolled a ${finalRoll}.`, 'roll');
                logMessage(`Select a destination.`, 'info');

                highlightPath(currentPlayerPosition, finalRoll);
            }
        }, 100);
    }

    function handleMoveSelection(destinationId) {
        // Clean up selectable spaces and their click handlers
        document.querySelectorAll('.space.selectable').forEach(el => {
            el.classList.remove('selectable');
            el.onclick = null;
        });

        const pathToTake = movablePaths.get(destinationId);
        animateTokenAlongPath(pathToTake);
    }

    function endTurn() {
        if (playerState.barterDeliveryPending) {
            playerState.ingredients += 1;
            logMessage("Your bartered ingredient has arrived!", 'reward');
            playerState.barterDeliveryPending = false;
            updateStatusUI();
        }
        currentTurn++;
        if (currentTurn > MAX_TURNS) {
            turnDisplay.textContent = MAX_TURNS;
            logMessage(`Year ${currentYear} finished! Prepare for the League Championship.`, 'milestone');
            // Here you would trigger the end-of-year tournament
            // For prototype, we can just reset for the next year after a delay
            setTimeout(startNewYear, 5000);
        } else {
            turnDisplay.textContent = currentTurn;
            triggerUIAnimation(turnDisplay.parentElement);
        }
    }

    function startNewYear() {
        currentYear++;
        currentTurn = 1;
        yearDisplay.textContent = currentYear;
        turnDisplay.textContent = currentTurn;
        logMessage(`Starting Year ${currentYear}! The journey continues.`, 'milestone');
        enableDiceRoll();
        updatePlayerPosition('start');
    }

    function makeConnectionsBidirectional() {
        const spaceMap = new Map(SPACES.map(space => [space.id, space]));

        SPACES.forEach(space => {
            if (space.connections) {
                space.connections.forEach(connectedId => {
                    const connectedSpace = spaceMap.get(connectedId);
                    if (connectedSpace) {
                        if (!connectedSpace.connections) {
                            connectedSpace.connections = [];
                        }
                        if (!connectedSpace.connections.includes(space.id)) {
                            connectedSpace.connections.push(space.id);
                        }
                    }
                });
            }
        });
    }

    function updateMechanicsGuide() {
        const trainCostList = document.getElementById('train-cost-list');
        if (!trainCostList) return;

        const biomeAffinities = {
            brute: { advantage: ['Volcanic', 'Mountain'], disadvantage: ['Tundra', 'Coastal'] },
            focus: { advantage: ['Coastal', 'Tundra'], disadvantage: ['Volcanic', 'Desert'] },
            flow: { advantage: ['Plains', 'Forest'], disadvantage: ['Mountain', 'Volcanic'] },
            control: { advantage: ['Desert', 'Mountain'], disadvantage: ['Forest', 'Plains'] }
        };

        const playerAffinities = biomeAffinities[playerState.mainDiscipline];

        trainCostList.innerHTML = `
            <li><strong class="text-${playerState.mainDiscipline}">Advantage Biomes:</strong> 3 P-Magic
                <br><small>(${playerAffinities.advantage.join(', ')})</small>
            </li>
            <li><strong>Neutral Biomes:</strong> 7 P-Magic</li>
            <li><strong class="text-brute">Disadvantage Biomes:</strong> 12 P-Magic
                <br><small>(${playerAffinities.disadvantage.join(', ')})</small>
            </li>
        `;


    }

    function init() {
        // Create and append tooltip element
        tooltipElement = document.createElement('div');
        tooltipElement.id = 'game-tooltip';
        tooltipElement.style.display = 'none';
        document.body.appendChild(tooltipElement);

        makeConnectionsBidirectional();
        createSpaces();
        drawConnections();
        createGridAndCoords(GRID_SIZE);
        updateStatusUI();
        updateMechanicsGuide();
        updatePlayerPosition('start');
        logMessage(`Year ${currentYear}, Turn ${currentTurn}. The Great Expedition begins!`);
        enableDiceRoll();
        rollDiceBtn.addEventListener('click', rollDice); // Add event listener for dice roll

        // Add event listener for the camp modal buttons
        const toggleIdsBtn = document.getElementById('toggle-ids-btn');
        if (toggleIdsBtn) {
            toggleIdsBtn.addEventListener('click', () => {
                board.classList.toggle('hide-space-ids');
                if (board.classList.contains('hide-space-ids')) {
                    toggleIdsBtn.textContent = 'Show IDs';
                } else {
                    toggleIdsBtn.textContent = 'Hide IDs';
                }
            });
        }

        // Add event listener for the camp modal buttons
        if (expeditionCampModal) {
            expeditionCampModal.addEventListener('click', (e) => {
                if (e.target.matches('.modal-actions button')) {
                    handleCampAction(e.target.dataset.action);
                }
            });
        }

        // Add event listener for the title match modal buttons
        if (titleMatchModal) {
            titleMatchModal.addEventListener('click', (e) => {
                // Use a general leave button handler
                if (e.target.matches('button[data-action="leave"]')) {
                    handleTitleMatchLeave();
                }
            });
        }

        // Add event listener for the crossroads modal buttons
        if (crossroadsModal) {
            crossroadsModal.addEventListener('click', (e) => {
                if (e.target.matches('.modal-actions button')) {
                    handleCrossroadsAction(e.target.dataset.action);
                }
            });
        }
    }

    init();
});

document.addEventListener('DOMContentLoaded', () => {
    // --- Floating UI Panel Toggle ---
    const uiContainer = document.getElementById('status-menu-container');
    const uiToggleBtn = document.getElementById('ui-toggle-btn');

    if (!uiContainer || !uiToggleBtn) return;

    let isDragging = false;
    let hasDragged = false;
    let offsetX, offsetY;

    // --- Drag Logic ---
    const startDrag = (e) => {
        isDragging = true;
        hasDragged = false;
        uiToggleBtn.classList.add('grabbing');
        uiContainer.classList.add('dragging'); // Add dragging class
        document.body.style.userSelect = 'none'; // Prevent text selection

        // Use pageX/Y for coordinates relative to the whole document
        offsetX = e.pageX - uiContainer.offsetLeft;
        offsetY = e.pageY - uiContainer.offsetTop;

        document.addEventListener('mousemove', onDrag);
        document.addEventListener('mouseup', stopDrag);
    };

    const onDrag = (e) => {
        if (!isDragging) return;
        hasDragged = true; // Flag that a drag has occurred

        // Calculate new position
        let newLeft = e.pageX - offsetX;
        let newTop = e.pageY - offsetY;

        // Constrain to viewport
        const containerRect = uiContainer.getBoundingClientRect();
        newLeft = Math.max(0, Math.min(newLeft, window.innerWidth - containerRect.width));
        newTop = Math.max(0, Math.min(newTop, window.innerHeight - containerRect.height));

        uiContainer.style.left = `${newLeft}px`;
        uiContainer.style.top = `${newTop}px`;
        // The panel is positioned relative to the container, so we don't need to move it separately.
    };

    const stopDrag = () => {
        isDragging = false;
        uiToggleBtn.classList.remove('grabbing');
        uiContainer.classList.remove('dragging'); // Remove dragging class
        document.body.style.userSelect = ''; // Re-enable text selection

        document.removeEventListener('mousemove', onDrag);
        document.removeEventListener('mouseup', stopDrag);
    };

    uiToggleBtn.addEventListener('mousedown', startDrag);

    // --- Toggle Logic ---
    uiToggleBtn.addEventListener('click', (e) => {
        // Only toggle if the mouse hasn't been dragged
        if (!hasDragged) {
            e.stopPropagation();
            uiContainer.classList.toggle('active');
        }
    });
});

// --- Mechanics Guide Toggle ---
const mechanicsPanel = document.getElementById('mechanics-panel');
const mechanicsHeader = mechanicsPanel ? mechanicsPanel.querySelector('.panel-header') : null;


if (mechanicsPanel && mechanicsHeader) {
    mechanicsHeader.addEventListener('click', (e) => {
        e.stopPropagation();
        mechanicsPanel.classList.toggle('active');
    });
}

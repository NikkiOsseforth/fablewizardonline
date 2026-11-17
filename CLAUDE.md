# Starvale

Een 3D-spelletje in één bestand (`index.html`, Three.js). Ideeën staan in `IDEAS.md`.

## Wegwijzer in `index.html`

Lees niet het hele bestand (bijna 5000 regels). Het script is opgedeeld in secties met een kop als `// ================= spells =================`. Zoek met Grep op de kop en lees alleen die sectie. Regelnummers verschuiven steeds, de koppen niet.

| Kop | Wat staat er |
| --- | --- |
| `helpers` | `rand`/`R`/`pick`, `rr`/`rpick`, `clamp`, `lerp`, `damp`, `PASTELS` |
| `hand-drawn icon set` | `ICON` (SVG-icoontjes voor de interface), `iconHTML` |
| `renderer / scene` | renderer, camera, `toon`, `mk`, `ball`, `Box`, de zachte vormen, `canvasTex`, `glow` |
| `sky, lights` | lucht, sterren, zon, maan, `hemi`, `sun` |
| `world layout / colliders` | waar alles staat (`ISLAND_R`, `HOUSE`, `POND`, `PIER`, `PORTAL`, `FRIENDS`, `PATHS`), `isFree`, `findSpot`, `collide` |
| `island` | grond, graspollen, vijver, steiger, boot, bomen, paddenstoelen, kristallen, lantaarns, wolken |
| `the house` | Nikki's huisje, buiten en binnen |
| `friends' houses` | `buildHouse`, daarna per huis een blok: `Kevin's mancave`, `Ryan's Japanese house`, `Dusty's red house` |
| `particles`, `fireflies` | `emit`, `burst`, `hearts` |
| `wizards (player + NPCs)` | `CHARACTERS`, `makeWizard`, `animateWizard`, NPC-gedrag, `talkTo`, eigen tovenaar maken (`MAKER`) |
| `creatures` | `CREATURE_DEFS`, `makeBunny`/`makeSpirit`/`makeDragon`/`makeCorgi`/`makeCat`, `updateCreature` |
| `spells` | `SPELLS`, `castSpell` en één `cast…`-functie per spreuk, dag/nacht (`DAY`, `NIGHT`, `applyTime`) |
| `audio` | `tone`, `seq`, `sfx(naam)` |
| `UI helpers` | `toast`, startscherm, karakter kiezen |
| `sky islands` | `SKY_DEFS`, regenboogbruggen, schatkist |
| `input` | toetsen, `onTap` (tikken om te lopen, aaien, praten) |
| `update` | `updatePlayer`, `updateCamera`, `updateWorld`, `updateUI` |
| `quests, stars & star shop` | `QUESTS`, `SHOP`, opslaan (`loadSave`, `storeSave`), `startQuest`, `questEvent` |
| `daily things` | `DAILY_TASKS`, cadeautje, reeks, `WISPS` |
| `potions & brewing` | `INGREDIENTS`, `RECIPES`, brouwen, drankeffecten |
| `multiplayer` | `SUPABASE`, aanwezigheid, andere spelers tekenen, spreuken doorsturen |
| `christmas` | kerstboom, lichtjes, sneeuwpop, sneeuw |
| `pond life & fishing` | golfjes, `FISH`, het vis-spelletje, visboek |
| `loop` | `frame()`: roept alle `update…`-functies aan |

De HTML en CSS van de interface staan bovenaan het bestand, vóór het script.

## Iets nieuws toevoegen

- **Ding in de wereld:** bouw het in de passende sectie met `mk`/`ball`. Staat het in de weg, voeg dan een botsvorm toe: `circles.push({ x, z, r })` voor iets ronds, `playerBoxes` voor een rechthoek. Vaste plekken komen in `placed`, zodat er geen bomen doorheen groeien.
- **Iets dat beweegt:** schrijf een `update…(dt, time)` en roep die aan in `frame()`.
- **Iets dat 's nachts gloeit:** maak het materiaal met `glow(toon(...), dag, nacht)`.
- **Spreuk, quest, recept, vis, winkelartikel, dagtaak:** voeg een regel toe aan de bijbehorende lijst (`SPELLS`, `QUESTS`, `RECIPES`, `FISH`, `SHOP`, `DAILY_TASKS`) en volg het patroon van de bestaande regels.
- **Melding of geluid:** `toast(tekst, ms, icoon)` en `sfx(naam)`.
- **Tikbaar oppervlak:** `onTap` raakt alleen de vlakken in zijn eigen lijst (eiland, vloeren, zwevende eilanden). Voeg een nieuwe loopvloer daar toe.

## Afspraken

- **Taal:** alle tekst in het spel is Engels. `IDEAS.md` en dit bestand zijn Nederlands. Commentaar in de code is Engels.
- **Opslag:** voortgang staat in `localStorage` onder sleutels die met `starvale-` beginnen, per karakter (`saveKey`). Voeg je een veld toe aan de opslag, geef het dan een standaardwaarde in `loadSave`, zodat oude opslag blijft werken.
- **Multiplayer:** iedereen die het spel open heeft, deelt één eiland via Supabase. Wat alleen bij jezelf gebeurt, zien anderen niet; stuur het mee in de aanwezigheid of als bericht als het zichtbaar moet zijn. Vertrouw nooit op wat binnenkomt: maak waarden schoon zoals `num` en `cleanNick` dat doen.
- **Ideeën:** vink in `IDEAS.md` af wat gebouwd is. Dat bestand staat in `.gitignore` en wordt dus niet gecommit.
- **Commits:** rechtstreeks op `main`, met een bericht dat begint met `Starvale: `.

## Draaien en testen

- Start de preview met de configuratie `starvale` uit `.claude/launch.json` (poort 8791). Is die poort bezet, dan draait er meestal al een server voor deze map: open dan gewoon `http://localhost:8791/index.html`.
- Er is geen build en er zijn geen tests. Controleren is: laden, een karakter kiezen, kijken en de console op fouten nalopen.
- Bij het testen verschijn je als extra speler in de gedeelde wereld. Kies daarom niet steeds een andere naam en sluit het tabblad als je klaar bent.

## Stijl van de wereld

De wereld lijkt op Animal Crossing: rond, mollig en zacht. Houd alles wat je toevoegt in die stijl.

- **Geen scherpe randen of punten.** Daken, bomen, stenen, meubels en dieren zijn afgerond. Uitzondering: kristallen en sterretjes mogen facetten hebben.
- **Gebruik de hulpfuncties bovenaan het script**, geen kale Three.js-vormen:
  - `Box(w, h, d)` voor blokken (afgeronde randen)
  - `ball(...)` voor bollen, ook platgedrukt (stapstenen, wolken, bladerkronen)
  - `CylGeo`, `SphGeo`, `TorGeo`, `CircGeo`, `RingGeo` in plaats van de `THREE.*Geometry`-varianten (genoeg segmenten voor gladde rondingen)
  - `ConeGeo` of `softConeGeo` voor kegels (ronde voet en ronde punt)
  - `softRoofGeo(R, h)` voor daken (ronde hoeken, zachte dakrand)
  - `softEdge(parent, r, topY, tube)` voor de afgeronde rand van een eiland
- **Materiaal:** altijd `toon(kleur)`. Geen `flatShading`, behalve bij kristallen.
- **Kleuren:** pastel. Gebruik `PASTELS` en de bestaande materialen (`trunkMat`, `leafMats`, `blossomMats`, `snowMat`, `grassMat`, `dirtMat`) voordat je een nieuwe kleur verzint.
- **Licht en schaduw:** warme zon, koel omgevingslicht, zachte schaduwen. Dag- en nachtkleuren staan in `DAY` en `NIGHT`.

## Vaste plaatsing

De wereld wordt opgebouwd met een willekeurgenerator met vaste startwaarde (`rand`, `R`, `pick`), zodat bomen en paddenstoelen bij iedereen op dezelfde plek staan.

- Voeg nieuwe `rand()`-aanroepen alleen toe **na** de bestaande wereldopbouw, anders verspringt alles wat erna komt.
- Vervang je een vorm die `R(...)` gebruikt, houd dan hetzelfde aantal aanroepen in dezelfde volgorde.
- Voor dingen die niet gelijk hoeven te lopen (deeltjes, effecten) gebruik je `rr` en `rpick`.

<!-- Ver 2026-06-26 17:36, by Claude Opus 4.8 -->

# Album Creation Guide v3.5 (condensed)

> An overall guide to distilling any source material (voice/video/text/photos — biography, story, project history, team growth, romantic memories…) into its essence and designing and producing an album from it. Covers the four layers of lyrics/music/voice/production, AI creation best practices, and the Suno prompt framework. Subject-agnostic, Mandarin-first; supports "one signature track per album," album-level consistency, and single-person scalable QC. Based on Pattison's *Writing Better Lyrics* / Berklee songwriting theory + Suno official docs and community evidence. **Platform capabilities change by version — verify Part IV against the current Suno version before hands-on work (re-check every 3–6 months).**

---

# Part I — Theoretical foundation

## 1. A song = four layers stacked, serving one emotion
**Lyrics** (what is said) → **Music** (melody/harmony/rhythm/form, how it moves) → **Voice** (vocal timbre and delivery + instrumentation, who is speaking) → **Production** (dynamics/space/texture/loudness, in what space it's said). The four layers support each other; any layer at odds with the intent makes it "fall apart." Example: "bitterness released" = minor to major, dynamics soft to strong, voice breathy to opened-up, production dry to wide.

## 2. The three principles
- **① Prosody, form matches meaning** (the first principle): form serves content. To express "stability/certainty," use stable tools (even line counts/ABAB/landing on strong beats); to express "instability/longing/brokenness," use unstable tools (odd line counts/uneven lengths/ABBA distant rhyme/not landing on strong beats). **There are no rules, only tools.** Every decision asks back: does it support this song's intent?
- **② Signal over noise** (how to convey it to the AI): every character written into Style/Lyrics is either parsed into sound (signal) or it's noise — and noise dilutes signal. Two iron rules: (a) write only what the model can parse, deleting artist names / `[Reverb:30%]` numbers / in-line bare spaces / ornate diction / filler sections; (b) put the strongest signal in the most prominent, most-repeated place (the chorus gets the most anchored image, Style puts the voice first). **When unsure about a detail, return to this principle first — you usually don't need to add a new rule.**
- **③ Layered control** (put the same intent on the most reliable layer):

  | Control target | Which layer (most reliable) | Don't put it |
  |---|---|---|
  | Global sound identity: gender/timbre/delivery baseline/production/genre/key/BPM | **the Style field** | don't carry it in the lyrics |
  | Section-level change: delivery switch/dynamics/instruments in and out | **lyric metatags** `[Chorus: full band, belted]` | don't change the global Style |
  | In-line rhythm: breath points/pauses/drawn-out/phrasing | **lyric punctuation and line breaks** | **don't use in-line bare spaces** (often swallowed in connected reading) |
  | Unreliable items: precise numbers/complex chords/artist names | **don't write them, or downgrade to a directional description** ("warm slow minor," not a chord chart) | don't treat as a hard instruction |

> **Throughout the book: the tables are a toolbox, not a recipe.** All the mappings/lexicons/formulas/Tiers/symptom tables are starting points and defaults, not checklists to copy wholesale. Pick, mix, and deviate freely per the actual material and the **album's overall character** — the standard for deviation is to return to Prosody: "does it support this song's / this album's intent?" An album that is "consistent yet has personality" often comes from deliberately breaking a few of these tables to reinforce a unified style, rather than filling in every cell.

## 3. Emotion → musical-lever mapping (core know-how)
| Emotion | Mode | Tempo/meter | Instrumentation | Dynamics | Voice | Lyric tools |
|---|---|---|---|---|---|---|
| Warm nostalgia | major | 70–85/4/4 | acoustic guitar+piano+soft strings | light verse, fuller chorus | warm breathy, restrained | concrete sensory, 1st/2nd person |
| Quiet sorrow | minor | 60–72/4/4 or 6/8 | piano+cello | repressed throughout | near-whisper breathy | unstable structure |
| Proud, inspiring | major | 90–120/4/4 | full band+drums+strings | crescendo to burst | belt, power | stable structure, high-wattage verbs |
| Tender lullaby | major | 60–75/**6/8** | piano/harp/music box | very light, steady | soft, low register | short lines, repetition, light rhyme |
| Release, farewell | minor→major | 70–85/4/4 | acoustic guitar+strings fading in | repressed→released | from held to opened | turning structure, bridge reveals |
| Solemn remembrance | major/Dorian | 60–80/4/4 | piano+strings+choir pad | broad, with space | grand harmony | 3rd person, negative space |
| Longing, attachment | minor⇄major | 65–80/4/4 or 6/8 | piano+airy synth/soft strings | mid-soft, no burst | breathy, line-ends trailing off | distant rhyme/ellipsis/unfinished lines, odd line counts |
| Romantic devotion | major (may borrow minor chords) | 70–95/4/4 or slow swing | piano/EP+soft drums+strings | gentle, warming | crooning sultry, close-mic | 2nd person/dialogue, sensory detail |
| Joyful celebration | major | 110–130/4/4 | full band+drums+brass/synth+claps | high-energy throughout | bright open, group-sung harmony | short repeating hook, call-and-response, singable in unison |
| Hope, aspiration | major (sus/Lydian) | 85–110/4/4 | piano+layering synth/strings build | gradual build (needn't burst) | clear, from held to opened | forward-looking imagery, ascending, "we" |
| Defiant struggle | minor (Dorian/Phrygian) | 90–140/4/4 | distorted guitar+drums+bass, raw | repressed buildup→burst | raspy belt, forceful diction | high-wattage verbs, short impactful lines, confrontation imagery |
| Calm healing | major/modal (Lydian) | 60–80/4/4 or rubato | piano/acoustic guitar+pad+ambient | steady throughout, with space | soft breathy near-whisper | present-moment sensory, negative space, light rhyme |

> Major = bright/happy, minor = dark/sad. The emotional arc = these columns (mode/dynamics, etc.) changing within the song. **Complex emotions are rarely a single row** — usually two or three rows mixed ("release with a trace of defiance" ≈ release × struggle) or migrating within a song (verse longing → chorus hope). Treat each row as one color on a palette, blend as needed, don't apply a single row (see the usage notes throughout the book).

## 4. Element relationships (who constrains whom)
Lyric syllable count/phrasing → strongly constrains melodic rhythm and singability; lyric tones (Chinese) → melodic contour (倒字 — tonal mismatch); emotional intent → mode/tempo/dynamics/voice; mode → bright/dark; form/dynamic arc → each section's instrumental energy; vocal timbre → recognizability/emotional distance; genre → instrumentation/rhythm/production conventions. **The two strongest couplings (always watch them for a Chinese emotional song): ① tone ↔ melodic contour (倒字); ② emotional intent ↔ mode + dynamics.**

---

# Part II — Lyrics (50%+ of the emotional load)

> **Lyrics are not poetry**: a poem is read and re-read; a lyric is *heard once, in time, and must be sung* — so it has to land on the first listen at singing speed (linear, plain-clear, repetition-tolerant). Every discipline below serves that one test. And **word leads, music serves** (§4): write the lyric first (its syllables and phrasing constrain the melody), then arrange the music to it — base tracks word-first; only the catchiness-first second lead may go melody-first.

## 5. Sourcing and concept: making the song "be about the listener"
The more specific and sense-bound, the more it activates the listener's memory and turns them from bystander into participant. **Object Writing**: 10–20 minutes a day, free-writing around one object using the seven senses (sight/sound/smell/taste/touch/organic sense/kinesthetic). Catch personal anchors from the material — specific objects, smells, catchphrases, key scenes, signature details (irreplaceable). **Avoid clichés**: the language can be simple and fresh, but it can't be prefab.

> **The album's spine = the subject's arc (the change), not a list of events**: distill *how the subject changed* (what they wanted vs. needed, the turning point) as the throughline, and draw the **emotional curve** — a valence-over-time line of the key beats. This curve is a first-class artifact: it later drives track order and tempo (§34). **Golden-line restraint**: capture catchphrases verbatim, but you needn't use them all — a beat may hold five quotable lines, and landing the one or two that hit hardest is usually enough (pick by most sense-bound + shortest/most singable + most universal; the rest stay as texture). Don't stack quotes just to use them up (mechanical stacking is noise, §2 ②) — keep more only when they genuinely earn their place.

## 6. Perspective (choose by the emotional distance you want)
- **First person (I)**: autobiography/looking back, the most intimate, but it must mean something to the world.
- **Second person (you, narrator outside)**: telling you something you don't know, an onlooker's reminder.
- **Third person (he/she)**: omniscient, epic/restrained remembrance.
- **Direct dialogue (I/you)**: pop's main course, but easily static; cloying if overused.

> Use perspective changes within an album to create "breath," don't use one person throughout.

## 7. Structure: one function per section (add/cut as needed, not fill-in-the-blank)
| Section | Function | Writing points |
|---|---|---|
| Verse | setup | high information density, concrete detail, private anchors |
| Pre-Chorus | lift the tension | turn, question, energy lifting |
| Chorus | payoff, hit the point | low information density, big emotion, hook, repeatable |
| Bridge | contrast, reveal | one new image/angle, then back to the chorus |
| Outro | resolve | release/negative space, don't add more |

> **Density**: Verse many words → Chorus few words big emotion → Bridge one new image back to the hook. The chorus is simpler than the verse, not denser. The classic template `Intro→V1→PreC→Chorus→V2→PreC→Chorus→Bridge→Chorus→Outro` is reference only — if 3 sections say it clearly, don't write 5; for each extra section ask "what did it do for this song," and if you can't answer, cut it.

## 8. Meter and rhythm
- Put important characters on the beat accents (in Chinese, via tone + pauses).
- **Even line length (in pocket)**: lines in a section have similar character/syllable counts, so the AI sings it stably; uneven lengths = an unstable tool (use deliberately).
- **Negative space**: place an important line where "there's room after it."
- **Align phrases to grammatical units**: break lines at meaning seams, or the "meaning evaporates."

## 9. Rhyme = a continuum of stability
Perfect rhyme (most stable, certainty/resolution) → Family rhyme (same consonant class, gentle) → Additive/Subtractive (medium, slightly unfinished) → Assonance (open, unresolved) → Consonance (least stable, unease). **Rhyme schemes**: ABAB stable / ABBA · odd line counts unstable. For certainty and reunion use perfect rhyme + ABAB; for longing and brokenness use distant rhyme + ABBA/odd line counts.

## 9.1 Chinese tidiness in practice: lock the rhyme · parallel couplets · even line length (the default baseline)
> The most fatal failure = "colloquial prose with line breaks" (lines lurching long and short, a non-rhyming chorus, plain talk, no couplets). Three disciplines press it into a "song":
> **But tidiness is a means in service of "catchy and pleasant," not an end**: when the rhyme-lock/couplets force something stiff and tongue-twisting, or say everything for the listener, return to Prosody — being pleasant is itself an emotional carrier, so loosen a notch and favor negative space (especially on the signature track's anchor lines).
- **Lock the rhyme (锁辙)**: the thirteen rhyme categories of New Chinese Rhyme — 中华新韵十三辙 (characters in the same category, 同辙, rhyme). **Each chorus locks one rhyme category to the end**; the verse rhymes on even lines; spoken-word/bridge sections may go unrhymed. Common categories: 发花(a/ia/ua) · 江阳(ang) · 一七(i/ü) · 由求(ou/iu) · 言前(an/ian/uan) · 人辰(en/in/un) · 中东(eng/ing/ong) · 怀来(ai/uai) · 灰堆(ei/ui) · 遥条(ao/iao) · 梭波(o/e/uo) · 姑苏(u) · 也斜(ie/üe).
- **Parallel couplets (对仗)**: paired lines with matching structure and opposed imagery — the strongest tool for Chinese to "sound like a song." Bury at least one couplet in each chorus ("锅里有米／灯下有衣").
- **Even line length**: lines in a section have similar character counts (mostly 4+3 / 4+4), no 10+-character long lines in the chorus; cut colloquial prose phrases (e.g. "你们都知道" / "我自己扛"), refine narration into imagery.
- **Recurring motif (题眼复现)**: the core character/image recurs at the end of multiple choruses, threading the album's motif line.

## 10. Stable / unstable
Line count: even = stable, odd = suspended. Line length: equal = stable, shrinking/stretching a line = unstable. Match stable content with stable structure, unstable emotion with unstable structure.

## 11. Hook (the signature track's crux)
- **Chorus = the strongest signal spot**: the chorus repeats most, so put the most anchored (sense-bound), most impactful words in the chorus, don't bury them in a verse sung only once. After writing, look back: is the most piercing image in the chorus?
- **Three kinds of hook**: ① repetition (one line repeated 2× + one line that lands the point); ② call-and-response (short question + short answer); ③ signature phrase (a recurring signature phrase + one line of emotion).
- The hook should be short, repeatable, easy to sing; the longer and denser the chorus, the more the AI tends to "sing it differently each time / robotic."
- Combine the personal image + universal emotion ("take me back, country road").

## 12. Rhetoric and imagery
The verb is the "power amp" — use high-wattage action verbs, use few be-verbs (but don't make the whole thing high-intensity or it blows the speakers). Use the concrete to figure the abstract; "unexpected collisions" generate fresh expressions. Leave room to breathe, don't cram.

## 13. Chinese specifics (hard constraints)
- **倒字 (the most fatal — tonal mismatch)**: the tone contour runs opposite to the melody → heard as a different word ("想你" → "向你"). **Zero 倒字 on chorus keywords + names**: put 上声/去声 (rising/falling-tone) characters on flat or matching melody spots, or swap a near-synonym. The first discipline.
- Rhyme by the thirteen rhyme categories of New Chinese Rhyme (don't keep to old rhyme tables); similar character counts per line for smooth reading; long lines need breath points, avoid runs of closed-mouth sounds or stacked retroflexes; mark vowel extension for opera melisma.
- Imagery tradition: depict emotion through scene, with 起承转合 (the classical setup-develop-turn-resolve progression, isomorphic with §7).
- Polyphones/rare characters/alphanumerics: swap the word, phoneticize, write numbers as Chinese characters.

## 13.7 Tidy vs. free-verse (an album-level overall control, not a ratio rule)
- **Baseline**: tidiness (§9.1) is the default, ensuring it sounds like a song and is catchy.
- **Colloquial exception**: interludes/spoken-word/Pre-Chorus/Bridge/insert sections may go colloquial, marked with metatags (`[Pre-Chorus: half-spoken]`, `[Bridge: spoken word]`).
- **Free-verse exception (optional)**: an album allows 0–2 tracks to go free-verse (loose language, free structure, mood-first), **and 0 is fine** — the creator judges by subject. If a whole track goes free-verse, pick the most inward/repressed one (grievance, numbness, mourning), which is most natural.

## 14. Rewriting = the gold standard (the three-stage drafting protocol)
"You write it down so you have something to change." Don't believe in inspiration-supremacy / writer's block — write a bad draft first (the best fertilizer). Run rewriting as **three deliberate stages, in order** — don't attempt all three at once, that's what produces stiff, tongue-twisting lines:
- **Stage 1 — narrative first (rules off)**: tell this song's emotional truth and its scenes plainly, prose-like; get the *story* right. **Ignore rhyme, meter, and tidiness entirely at this stage.**
- **Stage 2 — make it a lyric (prosodic shaping)**: impose song-form on the prose-truth — section function (verse = show/setup, chorus = the felt point/hook), lock one rhyme category to the end, even line length, bury a parallel couplet where it serves, compress the hook, write every chorus out in full. Use unstable tools in the verse to pull toward the chorus (§10).
- **Stage 3 — polish + gate (word level)**: **plain-reading first** (read cold, as a native listener who doesn't know the intent — every line and adjacent pair must read through in plain language: a question and its answer on the same axis, no construction opened-but-never-closed, no word forced into two senses, no dangling fragment; this is a meaning gate, prior to and distinct from killing tongue-twisters, which is a *sound* gate); then open vowels on held/high notes, kill tongue-twisters, **zero 倒字 on hook words and names**; apply the delete-the-adjective / negative-space / sing-along tests; then a **fresh-eyes pass** (ideally a different context, not the writer's own) confirms it reads through, is singable, and that golden lines weren't over-stacked (§5). **Any rhyme/character fix is itself a re-write** — re-run the plain-reading on whatever you touched, never assume "form-only."

In the AI era, each stage's revision = revise the brief/seven dimensions/lyrics + roll generations + local fine-fixes, not repeatedly regenerating the same take.

---

# Part III — Music (self-contained vocabulary)

## 15. The seven-dimension model
Dimension 1 (lyrics) is in Part II, dimension 2 (emotion→lever) is in §3/§18, dimensions 3–7:

| Dimension | How to fill (example) |
|---|---|
| 3 Style | main+sub+era (10-year precision)+region: "Mandopop folk/2000s/Taiwan" |
| 4 Form & dynamic arc | see §17 |
| 5 Rhythm | "76 BPM/4/4/Straight/Laid-back" |
| 6 Voice | "baritone/warm breathy/belt in chorus/lead" |
| 7 Instrumentation | core 3–4 pieces + section change |

**15.1 Style**: main(1)+sub/fusion+era+region. Families: Pop/Rock/Hip-Hop/EDM/R&B-Soul/Country-Folk/Jazz/Latin/Classical/guofeng neo-folk/opera (low confidence). **Fusion formula** `[main style],[main core element],[sub style],[sub characteristic element]`, must echo at the element layer. Valid: Mandopop+HipHop (Jay Chou), Jazz+HipHop (NeoSoul), Folk+Electronic, Classical+Trap; invalid: Opera+Trap, Gregorian+Dubstep. **Era anchor words** (stack 1–2; era is one way a track can evoke a moment — but the deeper move is to match the sound the listener *associates* with that moment, an association that may run through its era, place, event, or a shared cultural touchstone, never a hard-coded era→genre rule): 60s tape saturation/analog warmth; 70s phaser/disco strings/funky bass; 80s gated reverb/LinnDrum/DX7; 90s TR-909/MPC/lo-fi vinyl/grunge; 2000s Auto-Tune/snap/emo; 2010s lo-fi hip hop/bedroom pop/tropical house; 2020s hyperpop/glitch/drill.

**15.2 Rhythm**: BPM (integer, approximate) lyrical 60–85 / mid 90–120 / fast 120–168. Terms: Adagio(66–76) · Andante(76–108) · Allegro(120–168) · Presto(168–200) · Rubato (free, opera/lyrical). Meter (a core emotional variable): 4/4 square · 3/4 waltz · **6/8 lullaby/lyrical sway** · 2/4 march. Fill **subdivision** (Straight/Swing/Shuffle) and **groove** (Laid-back behind / Pushed ahead / Bouncy) as two separate layers. Rhythm patterns: four-on-the-floor · boom bap · trap hi-hat rolls · shuffle · bossa clave · waltz · dembow · breakbeat · straight 16ths.

**15.3 Instrumentation**: core 3–4 pieces (more = muddy) + one line of section change. Strings/plucked: guitar/12-string/bass/violin/cello. Keys/synth: piano/EP/synth/organ/strings section. Winds: sax/trumpet/flute/clarinet/French horn. Percussion: drums/brushed drums/808/TR-909/hand perc/timpani. **Chinese folk instruments** (naming in English is more accurate than vague description): erhu/京胡 jinghu/古筝 guzheng/琵琶 pipa/笛子 dizi/古琴 guqin/扬琴 yangqin/月琴 yueqin/三弦 sanxian/笙 sheng/唢呐 suona/板鼓锣 bangu-luo. **Build**: uniform / light verse heavy chorus / gradual / bridge drops to instrumental / two-section contrast / final chorus adds strings and choir. **Texture**: sparse↔dense; mono/homo/polyphonic; layering.

**15.4 Voice (the #1 recognizability point, put first in Style) — the three vocal layers**:
1. **Character, timbre texture** (Tier-1 reliable): warm/breathy/raspy/smoky/husky/velvety/gravelly/sultry/bright/dark/thin/clear/nasal/frayed
2. **Delivery**: intimate/belted/whispered/conversational/near-spoken/soaring/crooning/laid-back/behind-the-beat/declarative
3. **Effects, production**: close-mic/dry/reverb-drenched/compressed/tape-saturated/lo-fi

Stack gender + register + age feel, e.g. `warm aged mezzo, breathy and intimate, close-mic`.
**Reliability**: gender/delivery tags `[Whispered][Belting][Rap]`/texture/BPM are most stable; character adjectives/age/mid-song voice switch are medium (need Style to back them up); `[Reverb:30%]` numbers = a placebo, not parsed.
**Artist name = a placebo that must be translated**: a singer's name never enters a prompt — break it into the three layers of descriptors. The "recognizability triangle" = register + texture + delivery + era. Examples: smoky low voice → `warm low contralto, smooth unhurried, slow vibrato, close-mic vintage analog`; ethereal → `airy ethereal soprano, breathy detached, spacious reverb`; soaring → `powerful bright mezzo, soaring belt, big open dynamics`.
**Section differences** push down to metatags ("breathy in verse, belted in chorus"). Roles: lead/lead+harmony/duet/rap lead+sung chorus. Harmony: choir/gospel/stack harmonies/backing/call and response/counter melody. Ornaments: ooh/aah/humming/ad-libs/crowd chant/riff.

**15.5 Harmony and mode**: major = bright happy / minor = dark sad (one of the strongest levers). The emotional arc = minor verse → major chorus or Key Change. **A specific key (`in A minor`) is recommended in Style** — it locks the harmonic neighborhood and lowers randomness, the highest-value-for-money music-theory consistency item, especially setting 1–2 keys for the whole album to rein in drift (a directional constraint, still needs rolls). **Chord progressions = unreliable and banned from the lyric body** (writing them in Lyrics gets them sung as lyrics); only put them at the end of Style in Tier 3 with no expectation: pop I–V–vi–IV / jazz ii–V–I / R&B I–vi–IV–V / folk I–V–IV / rock I–♭VII–IV / Latin minor i–♭VII–♭VI–V / Korean-ballad vi–iii–IV–V. A key change (modulation up) pushes the emotion (chorus/final chorus).

**15.6 Production texture**: overall lo-fi/polished/raw/warm analog/digital clean/tape saturation/vinyl crackle/8-bit; space reverb-heavy/dry/wide stereo/mono; distortion-modulation overdrive/distortion/fuzz/phaser/chorus/flanger. Pro mixing terms (sidechain) aren't parsed; to remove an instrument use the Exclude field.

**15.7 Ambient sound** (Tier 3 as needed): rain/thunder/wind/ocean/birds/forest/city traffic/cafe/fire/wind chimes/temple bell/church bell. Must match the genre.

## 16. Influence Tier (not a measured value)
- **T1 makes or breaks it**: lyrics and hook, voice (gender + timbre + delivery), mode, main style, emotional intent.
- **T2 sets the texture**: BPM, meter, key, core instrumentation, form dynamic arc, era, production style.
- **T3 the icing (unstable response)**: chord progression, melodic line, ambient sound, special effects.

## 17. Form and dynamic arc
Section arrangement functions: Intro establishes the key (sparse/pure instrumental) · Verse mid-energy steady pocket · Pre-Chorus lifts · Chorus peak full-band repeating · Post-Chorus sustains/falls back · Bridge contrast reset (change harmony/drop drums/new perspective) · Breakdown pulls energy out · Build→Drop coils then bursts · Solo/Interlude instrumental spotlight · Outro resolve (`[End]` hard stop to prevent a trailing tail).
**The dynamic arc (a decisive factor for the signature track)** is written as one line of the energy curve, e.g. "sparse acoustic guitar start → strings fade in → chorus full-band burst → bridge drops to voice + piano → final chorus fullest + erhu accent → fade out." Curve words: building/fading out/sudden drop/sustained/dynamic contrast. Dynamics: crescendo/decrescendo · forte/piano · ff/pp · staccato/legato · ranges "pp to ff"/"whisper to belt".
**Meter emotion**: 4/4 certainty · 3/4 circling · 6/8 lullaby · 2/4 brisk. **Sweet-spot runtime 2:30–3:30**; an album (8 tracks) ≈ 26–30 minutes.

## 18. Emotion → music levers (§3 expanded)
The two strongest levers = mode (the master bright/dark switch) + dynamic arc. The rest: tempo (warm slow 60–76 / bright mid-fast 90–168), meter (6/8 · 3/4 / 4/4), instrumentation (few and warm / many and bright), texture (sparse / dense), dynamics (repressed / crescendo), voice (breathy near-whisper low register / belt with stacked harmony), production (warm analog dry close / polished wide). Procedure: look up the direction in §3 → take values lever by lever from this table → fill back into §15.

---

# Part IV — AI creation (the Suno V5.5 era)

## 19. The creative mindset
The task is **composition (original), not reproduction (copying)** (the platform bans reproducing famous songs; using original lyrics/lifting structure wholesale gets blocked or even banned — only evocative likeness + original lyrics). Generation is random: **a good song = good input × rolls × fine-fixing**. The loop: seven dimensions + lyrics → write input → batch-roll → QC filter → local fine-fix → if it doesn't reach the bar, change a dimension and re-roll.

## 20. Architecture: three fields + three systems
Fields: **Style** (the musical worldview) · **Lyrics** (words + structure tags + local cues) · **Title** (almost no impact). Systems: ① the Prompt text ② Metatags (square brackets) ③ Creative Sliders. Only using all three makes it "usable."

## 21. Style: voice-first + the 4–7-descriptor golden formula
`[three vocal layers: timbre+delivery+production],[genre][subgenre],[tempo/energy],[core instruments],[production],[mood],(optional in X major/minor)`
- **The voice-first iron rule**: put the voice at the head of the sentence, or about 30% of the time you get a "generic AI voice" (Suno responds most strongly to the opening).
- **Stack the three vocal layers** (Character+Delivery+Effects) — leave one out and it fills the blank with a statistical average = AI flavor.
- **The 4–7 iron rule**: <4 too vague, >7 competing descriptors produce "mud" (e.g. "1960s Detroit" clashing with "145 BPM," "reverb" clashing with "lo-fi").
- **What to put**: three vocal layers (first), genre, tempo, core instruments (name folk instruments), production, mood, era, key.
- **Pitfalls**: ① don't write fighting descriptors (`soft powerful belting`); ② parameters/percentages = a placebo (`[Reverb:30%]`), use words not numbers; ③ translate artist names into the three layers; ④ chord progressions; ⑤ use Exclude for negatives.

## 22. Lyrics + Metatags + singability
**A. Always use structure tags**: `[Intro][Verse 1][Pre-Chorus][Chorus][Post-Chorus][Bridge][Breakdown][Build][Drop][Hook][Interlude][Outro][End]`. Case-insensitive; `[End]` prevents a trailing tail; `[Verse 1][Verse 2]` make the AI understand the verses have different melodies while the chorus repeats.
**B. Parameterized metatags (the strongest)**: colon syntax controls each section without changing the global — `[Verse: whispered, acoustic guitar only]`, `[Chorus: full band, erhu accent, powerful vocals]`, `[Bridge: piano only, vulnerable]`, `[Outro: fade out]`.
**C. Voice/dynamics tags**: `[Whisper][Humming][Spoken Word][Duet][Choir][Harmony][Ad-lib][Fade In/Out][Crescendo][Key Change]`. At most one cue per section. **Dual anchoring**: restate the voice-texture word from the head of Style in the section metatag (`[Verse: husky near-spoken]`) for higher compliance. Use `[…: half-spoken]`/`[Spoken Word]` for spoken sections.
**D. Singability (treat the lyrics as the score for the vocal engine)**:
- **Punctuation is rhythm, bare spaces are unreliable**: period = a full stop, breath, reset; comma = a short in-line pause; ellipsis = drifting, lingering hold; hyphen = drawn-out (`Lo-o-ove` / Chinese "暖——"); line break = a longer pause; blank line = instrument continues while vocals stop a beat; exclamation = adds energy (don't overuse). **In-line bare spaces are often swallowed in connected reading — break breath points with punctuation or line breaks.**
- **Keep lines short** (≤10–12 chars/words), split long lines across multiple lines. Lay it out as a lyric sheet (sections + blank lines between sections), not a wall of text.
- **Even line length** (syllable pocket): if reading it aloud leaves you breathless = too long; if empty = add a repeated word/filler word.
- **Repetition is deliberate**: a short hook is easier to sing than a long chorus; a chorus sung differently each time = too long/dense/novel → shorten and repeat.
- **Anchor line**: the same line at each section's end steadies the vocal engine. **Density**: write dense in the verse, leave the chorus with space.
- **Pronunciation correction**: for English, change the spelling (read→reed); for Chinese, swap the character/adjust phrasing/write numbers as Chinese/avoid rare characters; if one word keeps failing, don't fight it — swap a synonym.
**E. Duet**: `[male vocal]…[female vocal]…[both]…`, keep that section simple.

## 23. Sliders/Exclude/Helper
- **Sliders** (V4.5+): Weirdness leans Safe for emotional songs; Style Influence leans Strong when the Style is precise; Audio Influence only when uploading a reference audio.
- **Exclude field**: use it for "without a certain instrument," don't write negatives in Style.
- **Prompt Helper**: auto-expands (non-deterministic) — use it as a learning tool (copy out the useful descriptors), turn it off for production / when you need consistency.

## 24. The album-consistency tech stack
- **Persona Voice locks the timbre**: with a vocal you're happy with, Create Persona → name it → reuse (keeps timbre and basic delivery, not melody/diction). Build it on a genre-specific track, not on a heavily-processed song.
- **Custom Models** (V5.5 up to 3): train a "voice fingerprint" on ≥6 stylistically consistent songs as the album's base model. The material must be stylistically uniform (mixing genres teaches mud).
- **Voice Cloning** (V5.5): cloning a real person's voice requires verified authorization; valuable for "the firsthand person's original voice," with ethics-authorization as a hard constraint — proceed with care.
- **My Taste**: an adaptive bias; an explicit Style still overrides it.
- **Stacking order — separate the invariant binder from the per-track variable**: an album's coherence comes from the **invariant binder** — Persona (voice) + thematic motif + a unified key — held identical across every track. **Genre / era-color / instrumentation are per-track variables**: they may shift by narrative beat (a faster, harder genre at a turning point; or the sound the listener *associates* with a moment — through its era, place, event, or a shared cultural touchstone, §15.1) and the album still sounds whole, because the voice and motif never move. **State the tradeoff honestly**: training one Custom Model needs ≥6 *stylistically uniform* tracks (mixing genres teaches mud, above) — so heavy per-track genre diversity means leaning on **Persona (genre-tolerant) instead of a Custom Model**. When you *do* want one uniform sound, the stacking is: Custom Model (base) > Persona (voice) > the style-family trio (era + genre + production) + a unified key.

## 25. Song Editor fine-fixing
**Inpainting/Replace Section** redoes a section (weak chorus / good verse / bridge in the wrong key); **Extend** continues 30–60 seconds (put structure tags at the start); **Crop** trims a trailing tail; **Fade In/Out** for head and tail. Inpainting is iterative — budget 2–5 passes for the seam to feel natural.

## 26. Genre confidence (an honest warning)
Training data is ~86% Global North, local instruments <3%. **High (stable)**: Pop/Rock/Hip-Hop/EDM/R&B/Country/Folk/Jazz. **Medium (needs guidance)**: Metal/Classical/Latin/Afrobeats/K-Pop-J-Pop. **Low (repeated rolls, only approximate)**: avant-garde experimental, non-Western traditions (Chinese opera and folk instruments/gamelan/raga/throat singing), pure sound effects. **Chinese folk instruments**: Suno recognizes specific instrument names (erhu/guzheng/pipa/dizi/guqin) more accurately than vague description; for subgenre use `Chinese folk ballad/Mandopop/C-pop`; orthodox opera in dialect is still the lowest confidence. **Language**: Mandarin is one of the best-supported (write Chinese with confidence), dialects (Cantonese/Suzhou vernacular) are weaker. **Business**: leading with pop/folk/lyrical/soul produces stable results; for opera and folk instruments only promise "approximate flavor," or use "Mandarin + folk-instrument accents" guofeng in place of orthodox opera.

## 27. Copyright & ethics compliance
**Copyright**: don't reproduce famous songs (do only evocative likeness + original lyrics); artist names are filtered (translate into the three vocal layers); commercial use requires the Pro tier (about $10/month, V5.5+ commercial rights) and checking the current terms — the free tier is non-commercial, credits don't roll over.
**Ethics & sensitivity (real subjects)**: when the subject is a real person, handle them with dignity — abstract away or cut sensitive content (politics rewritten as personal sensory imagery / overly dark plot points cut / illness, the deceased, and privacy handled with care, the deceased possibly requiring heir authorization); don't rely on a recognizable likeness without authorization; have the family confirm before delivering the finished work.

---

# Part V — The prompt framework and worked examples

## 28. The end-to-end framework
① Brief (for whom / what material / occasion / emotion / references) → ② emotion→lever (set the direction with §3) → ③ write lyrics (sourcing via object writing → perspective → structure → meter/rhyme/tidiness → hook → 倒字 self-check) → ④ write Style (voice-first three layers + 4–7 descriptors + key) → ⑤ Lyrics+Metatags (structure tags + parameterized + singability) → ⑥ Sliders (low Weirdness + strong Style Influence, Helper off) → ⑦ roll N → QC filter → ⑧ local fine-fix (Replace/Inpainting 2–5× / Extend) → ⑨ consistency (lock Persona / train Custom Model + unified key) → ⑩ deliver.

## 29. Templates
**Style**: `[voice: era+register+timbre, delivery+production],[genre][subgenre],[tempo/energy],[core instruments],[mood],(optional in X major/minor)`
**Lyrics**:
```
[Intro: piano only]
[Verse 1: breathy intimate, sparse] (private details, even line length 8–12 chars, punctuation controls breath, last line = anchor line)
[Pre-Chorus: strings enter, rising]
[Chorus: full band, opened-up vocals] (short hook, repeatable, zero 倒字, lock the rhyme + couplets)
[Bridge: piano only, vulnerable] (one new image, back to the hook)
[Final Chorus: biggest, harmonies]
[Outro: fade out]
[End]
```
**Sliders**: Weirdness=Safe; Style Influence=Strong; Helper=Off.

## 30. Worked walkthrough ("a person looking back," general workflow)
**Brief**: a signature track for an elder; the release of bitterness with warmth, deep family love; played to an audience on a memorial occasion.
**② Levers**: minor verse → major chorus; 66 BPM; 6/8 verse → 4/4 chorus; piano start → strings fade in → chorus full band + erhu; weak start bursting, drops at the bridge; warm aged mezzo, breathy verse, opened-up chorus with a catch.
**③ Lyrics**: sourcing catches objects/actions/catchphrases; first person; verse writes dense detail / chorus hits the point and leaves space; hook is repetition + personal image + locked rhyme; zero 倒字 on chorus motif words and names.
**④ Style**: `warm aged mezzo, breathy to opened-up, close-mic, Mandarin emotional folk ballad, slow piano with erhu and strings, warm analog, deeply nostalgic, in A minor`
**⑤ Lyrics**: `[Intro: solo piano]` → `[Verse 1: breathy intimate, sparse, 6/8 feel]` → `[Pre-Chorus: strings enter, rising]` → `[Chorus: full band, erhu accent, opened-up vocals, 4/4]` (short hook: one couplet + the point, locked rhyme, zero 倒字) → `[Bridge: piano only, vulnerable]` → `[Final Chorus: biggest, light harmonies, erhu]` → `[Outro: fade out]` → `[End]`. Even line length, minimal punctuation, last section leaves a motif for the instrumental to recur.
**⑥–⑨**: Weirdness=Safe / Style=Strong / Helper=Off; N≥8 pick the voice closest to the brief → Create Persona for album-wide reuse; chorus Replace 2–3× to keep "the turn to major bright enough" + line-by-line 倒字 check; QC target ≥9/10.

---

# Part VI — Quality control and workflow

## 31. The dual SOP
- **Signature track (85+)**: N≥8; set Persona/Custom Model first; chorus Inpainting 2–5×; line-by-line 倒字 check; Helper off; up to 3 iterations.
- **Base track (60+)**: N=2–4; reuse the signature track's Persona + same style family; accept once it passes, don't over-polish.
- Concentrate energy on the one signature track per album (uneven quality investment).
- **Application-layer extensible**: a specific project may add a "second lead" on top of the "signature track" (melody/style-first, catchiness winning first impressions) with tiered investment — see the skill that calls this guide.

## 32. Finished-product QC rubric (10-item checklist)
① stable pitch ② clear diction, the words read through (no answer-off-axis / opened-but-unclosed construction / one-word-two-senses / dangling fragment), no 倒字 ③ complete structure, no botched ending ④ no AI artifacts (metallic/electric/drift) ⑤ the hook holds up ⑥ emotion matches intent ⑦ clear instrumentation ⑧ dynamics rise and fall ⑨ consistent with the album/Persona ⑩ usable runtime. **Signature track ≥9, base track ≥7.** Below the bar → fine-fix or go back and change a dimension.

## 33. Symptom → cause → prescription
| Symptom | Prescription |
|---|---|
| Ten generations all unrelated | fill Style to 4–7, raise Style Influence |
| Generic AI voice / timbre changes each time | translate the voice into three layers and put it first, restate it in the section metatag |
| Lyrics read like prose | lock one rhyme category to the end, even out line length, bury couplets in each chorus, cut colloquial prose phrases |
| Output is muddy | cut to 4–7, remove conflicting items |
| The chorus doesn't burst | parameterize `[Chorus: full band…]`, Replace Section |
| Chorus differs each time / robotic | shorten and repeat, remove internal rhyme, add an anchor line |
| Lyrics cut off / rushed | shrink to 4 lines, fewer characters, add blank lines, move dense writing to the verse |
| Sentences run together / breath points vanish | change punctuation or line break, lines ≤10–12 chars |
| Chinese heard as the wrong character | swap the character, adjust phrasing, write numbers as Chinese, don't fight the same word |
| Sudden ending / trailing tail | `[Outro] fade out` + `[End]` |
| The tracks don't sound like one family | lock Persona/train Custom Model, unify the style family, add `in X minor/major` to Style |
| Opera/folk instruments not authentic | name folk instruments in English, roll more and lower expectations, or switch to Mandarin guofeng |
| Too weird, incoherent | lower Weirdness, turn Helper off |
| "Heartbreak" but not moving | Prosody is wrong → use unstable tools (odd line counts/shrink the last line/distant rhyme/ABBA) |

## 34. Album coordination
**Coherence comes from the invariant binder (Persona + thematic motif + unified key), not from a single uniform genre** (§24) — so genre/era-color may vary track to track by narrative beat. Thematic motif: the signature track's melody / a line of its lyric varied in another track or recurring in the instrumental; recurring motif word threads the motif line. **Sequencing is driven by the subject's emotional curve** (the valence-over-time line distilled from the material, §5): map each beat to a track, then shape the curve — research on album sequencing finds **tempo follows an inverted-U while valence/arousal run opposite**, so place the signature track at the emotional climax (center-back), leave 1–2 tracks of descent/release after it, an instrumental interlude as a breath, `[End]` to close, total runtime 26–30 min (8 tracks). The tidy-vs-free baseline (§13.7): set the tidy baseline first, free-verse latitude 0–2 tracks at the creator's discretion. Use perspective changes to create breath.

## 35. Delivery specs
WAV master + 320k MP3; unified **-14 LUFS**; verify loudness and track order separately for a physical carrier; include the cover (§36)/tracklist/handwritten card. For Pro + commercial rights, check the current terms first.

## 36. Cover design (Prosody at the visual layer)
**Principle**: the cover looks like the album sounds. The four visual elements (subject/color/typography/composition) share a **source** with the lyrics/music/voice/production and obey the same emotional intent — reuse the blueprint's throughline image + strongest personal anchor + emotional tone + style family + Persona character directly, don't start from scratch.

- **Subject = the throughline image / strongest personal anchor** (prefer a concrete object, sense-bound), don't use a generic abstract image. Leave **negative space for overlaying the title** in the composition. **When the throughline is abstract and can't be visualized** (e.g. "a sentence never said"), fall back to the **strongest personal-anchor object**, don't force a literal abstract concept.
- **Color = a map of the emotional tone** (same bright/dark logic as §3): warm/bright high-saturation = major-key warmth and joy; cool/low-saturation = minor-key introspection and sorrow; high-saturation high-contrast = inspiration and celebration. Echo the emotional arc.
- **Typography = the Persona/genre character**: heavy serif = solemn and deep; light handwriting/sans-serif = gentle and lively. Clear hierarchy for the album name (+ optional subject name).
- **Composition**: rule of thirds, a clear focal point, negative space, high contrast; **the thumbnail must be legible** (the streaming first image is tiny → strong focal point, little information, no small text). Symmetry = stability, asymmetry = motion, choose by character. **Avoid** clutter, platform logos, prices, URLs.
- **Three styles in one pass** (echoing the "multiple options" spirit of the §28 end-to-end): photorealistic photography / hand-drawn illustration / abstract minimalism or collage are the **default archetypes, swappable per the album's character** (e.g. for a high-energy album swap in a dynamic collage / film-grain sense of speed); only the three need to **genuinely diverge** (not reskins), for selection.
- **Two prompt styles for AI**: Midjourney uses "subject + style/medium + lighting + color mood + composition" + `--ar 1:1` (≤ ~60 words); Nano Banana / GPT Image use natural-language sentences (Subject+Action+Scene+mood). **AI text rendering is unreliable** (Midjourney especially): prefer overlaying the album name/subject name in post, or use a model strong at text (Nano Banana Pro / GPT Image); **always add `no text` / "do not render any text"** to the prompt, to stop the model from smearing fake letters into the space.
- **Specs**: streaming master **3000×3000, 1:1, sRGB, JPG/PNG** (Spotify minimum 640, Apple minimum 1400, output a uniform 3000+); physical CD finished 120×120mm → design file **126×126mm incl. 3mm bleed, 300 DPI (≥1417px), CMYK**, with text in the safe area. AI first outputs the highest-resolution square, then upscale to 3000².
- **Real / living subjects** (§27): **don't rely on a recognizable face by default** — use the throughline object, a hand/back-of-figure or other crop, or illustration (this both sidesteps likeness rights and works because AI can't actually render a specific real person); a genuine portrait of the person requires family authorization. Abstract sensitive imagery.

---

# Part VII — Limits · confidence · sources
- **High confidence (platform-independent)**: songwriting theory (prosody/perspective/rhyme/object writing/stability/the tidiness baseline), the three principles, the seven dimensions/emotion mapping/roll-fine-fix-QC methodology.
- **High (severity decreasing as models improve)**: Chinese 倒字/singability disciplines (still used as a finalizing discipline).
- **Medium-high (recently researched, verify against current Suno before hands-on)**: Suno fields/Metatags/Sliders/Editor/4–7 descriptors, three vocal layers/voice-first/artist-name translation, punctuation-as-rhythm, key in Style, the genre-confidence map.
- **Medium (ethics-authorization is a hard constraint)**: Voice Cloning of the firsthand person's original voice.

**Sources**: Pattison *Writing Better Lyrics*, Berklee Online, songwriting.net (Prosody); help.suno.com, blakecrosley.com *Suno V5.5 Reference*, jackrighteous.com; voice-control synthesis from hookgenius.app/sider.ai/musci.io and other community evidence. Cover specs and design principles synthesize Spotify/Apple official cover-art requirements, DIY Musician/LANDR/99designs design practice, and the Google Nano Banana and Midjourney prompt guides. **Suno and image models iterate fast — re-check Part IV/§36 every 3–6 months.**

---

*v3.5 condensed · songwriting/music/voice/production + the three principles + the element vocabulary + AI best practices + the prompt framework + cover design · paired with song_examples*
*2026-06-23 · by Claude Opus 4.8*

#!/usr/bin/env ruby
require 'set'
require 'yaml'

TAG_MAP = {
  # 删除通用 tag
  "anime" => nil, "Anime" => nil, "movie" => nil, "Movie" => nil,
  "game" => nil, "Game" => nil, "cartoon" => nil, "Cartoon" => nil,
  "superhero" => nil, "Superhero" => nil, "manga" => nil, "Manga" => nil,
  "cute" => nil, "Cute" => nil, "Pixar" => nil, "Illumination" => nil,
  "Landscape" => nil, "landscape" => nil, "Sports" => nil, "sports" => nil,
  "Racing" => nil, "racing" => nil, "Football" => nil, "football" => nil,
  "Car" => nil, "car" => nil, "Technology" => nil, "Event" => nil,
  "summer" => nil, "cool" => nil, "Cool" => nil, "thunder" => nil,
  "determination" => nil, "Determination" => nil, "swordsman" => nil,
  "Strategy" => nil, "Work" => nil, "Overtime" => nil, "Cowboy" => nil,
  "Western" => nil, "Chinese" => nil, "Romantic" => nil, "Elegant" => nil,
  "Weapon" => nil, "Stylish" => nil, "Underwater" => nil, "Dancing" => nil,
  "Playful" => nil, "Beauty" => nil, "LookingBack" => nil, "Childhood" => nil,
  "Reincarnation" => nil, "DivineLight" => nil, "Chaos" => nil,
  "Explosion" => nil, "Healing" => nil, "Spirit" => nil, "Sword Spirit" => nil,
  "Relaxation" => nil, "Pool" => nil, "Mountain Drift" => nil,
  "Touge Racing" => nil, "Tofu Shop" => nil, "Canyon Racing" => nil,
  "Twilight Scene" => nil, "Mountain Curves" => nil, "Sports Car" => nil,
  "Red Black" => nil, "Night Racing" => nil, "Japanese Racing" => nil,
  "Moonlight" => nil, "TapDance" => nil, "Summoning" => nil,
  "Wings" => nil, "kimono" => nil, "Pink" => nil,
  "Robot" => nil, "Japanese Anime" => nil, "Space" => nil, "Sky" => nil,
  "Starry Sky" => nil, "Ice Cream" => nil, "Donut" => nil, "Champion" => nil,
  "Flying" => nil, "Super Hero" => nil, "Cinematic" => nil,
  "Chinese Animation" => nil, "Battle-Ready" => nil, "Uchiha Clan" => nil,
  "Straw Hat Pirates" => nil, "Empress" => nil, "Los Blancos" => nil,
  "Gunners" => nil, "Nerazzurri" => nil, "The Reds" => nil,
  "Red Devils" => nil, "Bianconeri" => nil, "Blaugrana" => nil,
  "Citizens" => nil, "Rossoneri" => nil, "Thunder Breathing" => nil,
  "League" => nil, "Flame" => nil, "Sword" => nil,
  "Ukiyo-E Style" => nil,

  # 格式修正 + 合并
  "DemonSlayer" => "Demon Slayer",
  "AttackonTitan" => "Attack on Titan",
  "MortalsJourneytoImmortality" => "A Record of a Mortal's Journey to Immortality",
  "NangongWan" => "Nangong Wan",
  "Rei-Ayanami" => "Rei Ayanami",
  "Battle-Suit" => "Battle Suit",
  "BuzzLightyear" => "Buzz Lightyear",
  "SpaceRanger" => "Space Ranger",
  "SasukeUchiha" => "Sasuke Uchiha",
  "KakashiHatake" => "Kakashi Hatake",
  "SakuraHaruno" => "Sakura Haruno",
  "JujutsuKaisen" => "Jujutsu Kaisen",
  "NarutoUzumaki" => "Naruto Uzumaki",
  "UltraInstinct" => "Ultra Instinct",
  "SuperSaiyan" => "Super Saiyan",
  "SuperSaiyan2" => "Super Saiyan 2",
  "SuperSaiyan3" => "Super Saiyan 3",
  "SuperSaiyan4" => "Super Saiyan 4",
  "AndysRoom" => "Andy's Room",
  "SexPistols" => "Sex Pistols",
  "PorcoRosso" => "Porco Rosso",
  "SpiritedAway" => "Spirited Away",
  "TokitoMuichiro" => "Tokito Muichiro",
  "DoubleExposure" => "Double Exposure",
  "MistPillar" => "Mist Pillar",
  "UkyioE" => "Ukiyo-E",
  "StudioGhibli" => "Studio Ghibli",
  "A Record Of Mortals Journey To Immortality" => "A Record of a Mortal's Journey to Immortality",
  "A Mortal's Journey" => "A Record of a Mortal's Journey to Immortality",
  "Powerpuff" => "Powerpuff Girls",
  "Zootopia 2" => "Zootopia",
  "King of Fighters" => "The King of Fighters",
  "KOF" => "The King of Fighters",
  "SNK" => nil,
  "Love Pillar" => "Mitsuri Kanroji",
  "Love Hashira" => "Mitsuri Kanroji",
  "Insect Pillar" => "Shinobu Kocho",
  "Flame Pillar" => "Kyojuro Rengoku",
  "Water Pillar" => "Giyu Tomioka",
  "Sound Pillar" => "Tengen Uzui",
  "Mist Pillar" => "Tokito Muichiro",
  "SpongeBob" => "SpongeBob SquarePants",
  "Pokemon" => "Pokémon",
  "Titan" => "Attack on Titan",
  "Evangelion" => "EVA",
  "DC Comics" => "DC",
  "Marvel Comics" => "Marvel",
  "Crayon Shin chan" => "Crayon Shin-chan",
  "HanLi" => "Han Li",
  "Sword Coming" => "Sword of Coming",
  "Ghibli" => "Studio Ghibli",

  # 第二轮补充
  # 删除通用 tag
  "graffiti" => nil, "Graffiti" => nil,
  "Chibi" => nil, "Fantasy" => nil, "Xianxia" => nil,
  "Cultivation" => nil, "Football Club" => nil,
  "martial arts" => nil, "comic style" => nil,
  "thick paint" => nil, "sword" => nil,
  "Mecha" => nil, "DarkEpic" => nil, "Dark Epic" => nil,
  "Dragon" => nil, "Cute Animals" => nil, "Kittens" => nil,
  "Apple" => nil, "Nintendo" => nil, "Mythology" => nil,
  "Formula" => nil, "WWDC" => nil, "Everlasting Judgment" => nil,
  "Leaf Village" => nil, "Bikini Bottom" => nil,

  # 格式修正
  "DragonBall" => "Dragon Ball",
  "FinalFantasy" => "Final Fantasy",
  "SaintSeiya" => "Saint Seiya",
  "ToyStory" => "Toy Story",
  "MortalJourney" => "A Record of a Mortal's Journey to Immortality",
  "HinataHyuga" => "Hinata Hyuga",
  "DemonHunter" => "Demon Hunter",
  "WindThunder" => "Wind Thunder",
  "BikiniBottom" => "Bikini Bottom",
  "Kanroji Mitsuri" => "Mitsuri Kanroji",
  "Chen Ping An" => "Chen Ping'an",
  "A Record of a Mortals Journey to Immortality" => "A Record of a Mortal's Journey to Immortality",

  # 第三轮补充
  "Sword Come" => "Sword of Coming",
  "LeafVillage" => nil,
  "Double Exposure" => nil,
  "Orange Mazda RX7" => nil,
  "Salute" => nil,
  "Thorn" => nil,
  "Three Cats" => nil,
  "Four Cats" => nil,
  "Five Cats" => nil,
  "Ukiyo-E" => nil,
  "Wind Thunder" => nil
}

stats = { processed: 0, modified: 0, removed: 0, replaced: 0 }

files = Dir.glob("_iphone-wallpaper/**/*.markdown") + Dir.glob("_ipad-wallpaper/**/*.markdown")

files.each do |file|
  content = File.read(file)
  next unless content =~ /^(---\s*\n.*?\n---\s*\n)/m

  front_matter = $1
  body = content[front_matter.length..-1]

  # Find and parse tags line
  # Match tags: [...] or tags : [...] (single line or multiline array)
  tags_match = front_matter.match(/^(tags\s*:\s*)(\[.*?\])/m)
  unless tags_match
    # Try multiline array format
    tags_match = front_matter.match(/^(tags\s*:\s*)((?:\n?\s+-\s+.*)+)/m)
  end

  next unless tags_match

  prefix = tags_match[1]
  tags_str = tags_match[2]

  # Parse tags
  if tags_str.start_with?("[")
    # Inline array: parse with YAML
    tag_list = begin
      YAML.safe_load(tags_str)
    rescue
      next
    end
  else
    # Multiline array
    tag_list = tags_str.lines.map { |l| l.sub(/^\s+-\s+/, '').strip }.reject(&:empty?)
  end

  next unless tag_list.is_a?(Array)

  original_tags = tag_list.dup
  new_tags = []

  tag_list.each do |tag|
    tag_str = tag.to_s.strip
    next if tag_str.empty?

    if TAG_MAP.key?(tag_str)
      mapped = TAG_MAP[tag_str]
      if mapped.nil?
        stats[:removed] += 1
      else
        new_tags << mapped
        stats[:replaced] += 1
      end
    else
      new_tags << tag_str
    end
  end

  # Deduplicate while preserving order
  seen = Set.new
  new_tags = new_tags.reject { |t| seen.include?(t) || !seen.add(t) }

  next if new_tags == original_tags

  stats[:modified] += 1

  # Build new tags string
  if new_tags.empty?
    new_tags_line = "tags: []"
  else
    # Quote tags that contain special chars
    formatted = new_tags.map do |t|
      if t =~ /['",\[\]:]/ || t == "true" || t == "false" || t == "null" || t =~ /^\d+$/
        '"' + t.gsub('"', '\"') + '"'
      else
        t
      end
    end
    new_tags_line = "tags: [" + formatted.join(", ") + "]"
  end

  # Replace in front matter
  new_front_matter = front_matter.sub(tags_match[0], prefix + new_tags_line.gsub(/^tags: /, ''))

  File.write(file, new_front_matter + body)
  stats[:processed] += 1
end

puts "Done. Processed #{stats[:processed]} files, modified #{stats[:modified]}."
puts "Removed #{stats[:removed]} tags, replaced #{stats[:replaced]} tags."

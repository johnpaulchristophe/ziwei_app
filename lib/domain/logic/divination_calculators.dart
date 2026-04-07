// lib/domain/logic/divination_calculators.dart

import '../models/models.dart';

class DivinationCalculators {
  /// 旁路断语计算入口（当前仅限命宫）
  static List<String> getCommentariesForPalace(Palace palace) {
    if (!palace.name.contains('命宫')) return [];

    List<String> results = [];
    final zhi = palace.earthlyBranch.isNotEmpty
        ? palace.earthlyBranch.substring(palace.earthlyBranch.length - 1)
        : '';
    final majorNames = palace.majorStars.map((s) => s.name).toList();
    final minorNames = palace.minorStars.map((s) => s.name).toList();
    final allNames = [...majorNames, ...minorNames];

    final modifiers = <String, String>{};
    for (var s in [...palace.majorStars, ...palace.minorStars]) {
      if (s.modifier != null && s.modifier!.isNotEmpty) {
        modifiers[s.name] = s.modifier!;
      }
    }
    final isSoloMajor = majorNames.length == 1;

    // 路由分发至 14 主星
    if (majorNames.contains('紫微'))
      _getZiweiRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('天机'))
      _getTianjiRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('太阳'))
      _getTaiyangRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('武曲'))
      _getWuquRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('天同'))
      _getTiantongRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('廉贞'))
      _getLianzhenRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('贪狼'))
      _getTanlangRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('天府'))
      _getTianfuRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('太阴'))
      _getTaiyinRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('巨门'))
      _getJumenRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('天相'))
      _getTianxiangRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('天梁'))
      _getTianliangRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('七杀'))
      _getQishaRules(zhi, isSoloMajor, allNames, modifiers, results);
    if (majorNames.contains('破军'))
      _getPojunRules(zhi, isSoloMajor, allNames, modifiers, results);

    return results;
  }

  // --- 辅助判断工具 ---
  static bool _hasSha(List<String> names) =>
      names.any((n) => ['擎羊', '陀罗', '火星', '铃星'].contains(n));
  static bool _hasKong(List<String> names) =>
      names.any((n) => ['天空', '地空', '地劫', '截空', '旬空'].contains(n));
  static bool _hasPeach(List<String> names) =>
      names.any((n) => ['红鸾', '天喜', '咸池', '天姚'].contains(n));

  // ==========================================
  // 👇 各主星判词库 (严格映射文档，降级处理跨宫位条件)
  // ==========================================

  static void _getZiweiRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("紫微独坐：性情敦厚豪爽耿直，但多志高气傲，主观甚强。易耳软，虽有领导之才。[cite: 4]");
      if (zhi == '子' || zhi == '午')
        res.add("午宫入庙，领导力及制化调和之力较子宫独坐为大，地位和财富均优胜。[cite: 16]");
      if (all.contains('左辅') ||
          all.contains('右弼') ||
          all.contains('文昌') ||
          all.contains('文曲') ||
          all.contains('龙池') ||
          all.contains('凤阁')) {
        res.add("紫微得左右昌曲等：增加气势，减少辛劳。[cite: 19]");
      }
      if (_hasKong(all)) res.add("紫微见空曜：宜追寻哲理，可成为宗教人物或领导人才。[cite: 22]");
      if (_hasSha(all))
        res.add("紫微见煞曜：容易怀才不遇，宜经商致富。[cite: 28] 耳朵软，易听谗言是非。[cite: 43]");
    }
    if (all.contains('破军')) {
      res.add("紫微破军同宫：人生辛劳但有领导力与决断力，可历辛劳而有成。[cite: 49]");
      if (_hasSha(all) || mod.containsValue('忌'))
        res.add("紫微破军煞忌并见：眼神游移不定。[cite: 7]");
    }
    if (all.contains('贪狼'))
      res.add(
        "紫微贪狼同宫：脸形带扁。[cite: 10] 脸形变化；宜根据文昌文曲、左辅右弼、煞曜等组合进一步判断。[cite: 61] 主人好色，会桃花诸曜则更甚；会天刑或陀罗则能自制。[cite: 46]",
      );
    if (all.contains('禄存')) res.add("紫微禄存同宫：体态虽丰厚，但神孤。[cite: 13]");
    if (all.contains('天府'))
      res.add("紫微天府同宫：性质冲突难发挥，最宜教育事业，公职可行，不宜从商。[cite: 58]");

    if (mod['紫微'] == '禄' || all.contains('禄存'))
      res.add("紫微化禄或会禄存：致富且有社会地位。[cite: 31]");
    if (mod['紫微'] == '权') res.add("紫微化权：增加领导力及竞争力。[cite: 37]");
    if (mod['紫微'] == '科') res.add("紫微化科：有声誉，宜从事学术研究，可融汇百家而有所创造。[cite: 40]");
    if (_hasSha(all) && all.contains('擎羊'))
      res.add("紫微煞重见擎羊：纠纷是非，或外科手术。[cite: 34]");
  }

  static void _getTianjiRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("天机独坐：面色青白，面型长圆带瘦，聪明机巧，性主心慈性急，机谋多变，好动好学。[cite: 65]");
      if (zhi == '子' || zhi == '午')
        res.add("入庙能发挥特性，入陷则身材瘦，中高身材；对宫巨门会合，若不化忌，事业顺利。[cite: 83]");
      if (zhi == '丑' || zhi == '未') {
        if (mod.containsValue('忌') || _hasSha(all))
          res.add("天机丑未逢煞忌：女命多感情挫折，宜迟婚，否则刑克不免。[cite: 89]");
      }
      if (zhi == '巳' || zhi == '亥')
        res.add("巳宫对宫太阴入庙，亥宫对宫太阴落陷，巳宫较亥宫性质佳，男女多感情发展。[cite: 101]");
    }
    if (all.contains('巨门')) res.add("天机会巨门吉曜：办事有条理，反应敏锐，口才机变。[cite: 68]");
    if (all.contains('太阴'))
      res.add(
        "天机太阴同度：男命目光灵动沉潜，女命温柔端庄，善感情。[cite: 86] 本宫处事条理，有内才及工心计。男性易于接近异性，女性主容貌美丽，感情易得。[cite: 92]",
      );
    if (all.contains('左辅') && all.contains('右弼') && all.contains('禄存'))
      res.add("天机会左右及禄存：增加气势，心志高尚，富贵可成。[cite: 95]");

    if (mod['天机'] == '禄') {
      res.add("天机化禄：财来财去，难积聚，但易有突如其来的进财幸运。[cite: 71]");
      if (_hasSha(all)) res.add("天机化禄遇煞：财帛入不敷支；遇吉曜则进财。[cite: 98]");
    }
    if (mod['天机'] == '权')
      res.add(
        "天机化权：可增加权势，有机会结识权要，对事业及地位有帮助。[cite: 74] 增加变动主动性，可辅助事业发展。[cite: 104]",
      );
    if (mod['天机'] == '科')
      res.add(
        "天机化科：必须得文昌文曲相夹或拱照方能有所表现，反应敏锐，聪明出众。[cite: 77] 必须与太阴、文昌文曲等会照方能发挥作用，反易徒具虚名。[cite: 107]",
      );
    if (mod.containsValue('忌') || _hasSha(all))
      res.add("天机会煞忌：易无谓思虑，犹豫失机缘，感情及事业受挫。[cite: 80]");
  }

  static void _getTaiyangRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) res.add("太阳独坐：面色红白或红黄，面型饱满圆脸或长圆脸，性大方洒脱，量宽忠耿，聪明。[cite: 111]");
    res.add("女命太阳：逢吉曜可创业、富贵；逢煞曜则感情及婚姻多波折。[cite: 135]");

    if (zhi == '午') res.add("太阳在午宫：阳光强烈，可化解天梁及巨门刑克，开创力量大。[cite: 114]");
    if (zhi == '子') res.add("太阳在子宫：包含容忍力量较大，童年易受父亲影响，命主感情内蕴，外表不显。[cite: 117]");
    if (zhi == '辰' || zhi == '戌')
      res.add("太阳在辰戌：日月并明格，少年得志，处世练达，若辅佐化禄权科，贵显。[cite: 138]");
    if (zhi == '亥' || zhi == '戌' || zhi == '子')
      res.add("日月反背格(近似)：与父母无缘，名声难显达，需经艰辛奋斗。[cite: 141]");
    if (zhi == '巳' || zhi == '亥')
      res.add("太阳巳亥独坐：巳宫入庙较佳，可少年得志或得父母福荫；亥宫落陷，幼年不利父亲。[cite: 144]");

    if (all.contains('巨门'))
      res.add("太阳巨门同度：寅宫阳光初露，前程远大但需奋斗；申宫阳光转弱，晚景需持盈保泰。[cite: 132]");

    if (mod['太阳'] == '禄') {
      res.add("太阳化禄：财帛丰盈，能富能贵，若午宫太阳已旺，化禄可增强名誉。[cite: 121]");
      if (all.contains('天马'))
        res.add("化禄会天马：可富，化权科可增加权力声誉；化忌少年不利，亦不易服从上司。[cite: 147]");
    }
    if (mod['太阳'] == '权') res.add("太阳化权：可贵显，难遇煞曜可为小局面领导；午宫已旺则主观更强。[cite: 123]");
    if (mod['太阳'] == '科') res.add("太阳化科：主名誉昭彰，寅宫较有利。[cite: 126]");
    if (mod['太阳'] == '忌')
      res.add("太阳化忌：早年与父母无缘，自身多灾病；午宫化忌需防血压及心脏病。[cite: 129]");
  }

  static void _getWuquRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) res.add("武曲独坐：面色青白青黑青黄，面型长圆带瘦。性果敢刚毅心直无毒决断力强，但多短见。[cite: 151]");
    res.add("女命武曲：若见吉曜，主为女中豪杰；若见天刑，婚姻不利，但自身事业财帛可比美男子。[cite: 184]");

    if (all.contains('七杀') && zhi == '卯') res.add("武曲七杀卯宫同度：主体态肥胖。[cite: 154]");
    if (all.contains('七杀'))
      res.add("武曲七杀：喜左辅右弼拱照，更得会化禄或禄存，则人生际遇顺遂，否则容易孤立无援而破财。[cite: 178]");
    if (all.contains('天府'))
      res.add("武曲天府同度：主创业理财守财；会合时易生矛盾，但不如紫府冲突强烈。[cite: 157]");
    if (all.contains('贪狼')) {
      res.add("武曲贪狼同宫：若福德宫吉长寿；喜财帛宫吉曜化禄权则命宫生色。[cite: 172]");
      if (all.contains('火星') || all.contains('铃星'))
        res.add("武贪见火铃：主暴发，不宜再见化忌羊陀，易暴败，宜持盈保泰。[cite: 175]");
    }
    if (all.contains('破军')) res.add("武曲破军同宫：不宜经商，但若事业宫紫贪见禄马或火铃可突发。[cite: 181]");

    if (mod['武曲'] == '禄' || mod['天府'] == '禄')
      res.add("武曲天府化禄：财源丰厚，但不喜见禄存；虽富亦主悭贪，性格略自私。[cite: 160]");
    if (mod['武曲'] == '权') res.add("武曲化权：武曲力量增加，利开创，可进财。[cite: 163]");
    if (mod['武曲'] == '科') res.add("武曲化科：主事业顺遂，但不宜好高鹜远；略会一两点煞星易招失败。[cite: 166]");
    if (mod['武曲'] == '忌')
      res.add("武曲化忌：事业失败，周转困难；女命健康不佳，易患癌症或夫子刑克。[cite: 169]");
  }

  static void _getTiantongRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("天同独坐：面色黄白，面型长方微圆，体态丰满，眉清目秀，眼神仁慈。[cite: 188]");
      if (zhi == '巳' || zhi == '亥')
        res.add("巳亥独坐：对宫天梁，基本性质同天同天梁；享受心理不如独坐强烈，少离浪。[cite: 209]");
    }
    res.add("女命天同：衣禄丰足，易觉精神空虚；巳亥入庙虽美而淫，可通过充实精神生活避免。[cite: 212]");

    if (all.contains('太阴')) {
      res.add("天同太阴同度：子宫入庙旺，男女皆对异性有吸引力；女命擅长修饰美容。[cite: 200]");
      res.add("机月同梁格(近似)：利于服务公职、大机构或与外国人相关工作。[cite: 203]");
    }
    if (all.contains('巨门'))
      res.add("天同巨门同度：巨门为是非之挠，需昌曲魁钺左右会照，方可富贵或从事公职文化工作。[cite: 206]");

    if (mod['天同'] == '禄')
      res.add("天同化禄：主人生活安适，有生活情趣，但亦增加困扰力量；可富可贵。[cite: 191]");
    if (mod['天同'] == '权') res.add("天同化权：激发事业发展，人生多坦途；女命可主动处理感情。[cite: 194]");
    if (mod['天同'] == '忌')
      res.add("天同化忌：子午宫不妨；午宫化忌男女皆对女亲不利，但对数理科技有特殊天才。[cite: 197]");
  }

  static void _getLianzhenRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) res.add("廉贞独坐：面色黄或黄黑，面型长圆瘦，眉宽口阔颧高；性不拘礼节，暴躁浮荡易忿争。[cite: 216]");
    res.add("女命廉贞：不见吉曜或见煞易受感情欺骗；见吉曜可成贞烈女中豪杰夫唱妇随。[cite: 234]");

    if (all.contains('贪狼'))
      res.add("廉贞贪狼同度：外表圆滑，内心少实际；善文艺，可从事艺术创作。[cite: 219]");
    if (all.contains('天府'))
      res.add(
        "廉贞天府同度：主内心宽厚守成，开创力欠佳，宜按部就班升迁至主管。[cite: 222] 默默工作肩担重任；宜服务财经机构或企业行政，需化禄升迁。[cite: 240]",
      );
    if (all.contains('擎羊'))
      res.add("廉贞擎羊同度：多招是非，见天刑空劫主词讼倾败；丙年生化忌更主客死异乡。[cite: 228]");
    if (all.contains('七杀'))
      res.add("廉贞七杀同度：喜变动，适行政；受七杀影响文艺有爱好，宜节制。[cite: 231]");
    if (all.contains('破军'))
      res.add("廉贞破军同度：多喜研究专门技能，少年多灾病，成年可凭技艺谋生。[cite: 237]");

    if (mod['廉贞'] == '忌') res.add("廉贞化忌：横发横破，富贵不耐久；遇桃花诸曜因酒色招破败。[cite: 225]");
  }

  static void _getTanlangRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("贪狼独坐：面色青白青黄，面型长圆或圆方露骨；性情不常机谋深远作事性急。[cite: 244]");
      res.add("女命贪狼：多嗜好，良好者绘画跳舞美容，不良者烟酒赌博。[cite: 271]");
      if (zhi == '子') res.add("贪狼入子宫：喜会火铃为铃贪格可暴发；会空劫羊陀宜专门技艺谋生。[cite: 256]");
      if (zhi == '午') res.add("贪狼入午宫：无煞可掌财政，为木火通明格，会禄更佳；有煞宜经商。[cite: 259]");
      if (zhi == '寅' || zhi == '申')
        res.add("贪狼寅申独坐：可从事政治行政；化权女命宜迟婚，男命得能干之妻。[cite: 274]");
      if (zhi == '辰' || zhi == '戌')
        res.add("贪狼辰戌独坐：最喜火铃为火贪铃贪格，可成巨富或握重权，受武曲影响主迟发。[cite: 277]");
    }

    if (all.contains('文昌') || all.contains('文曲'))
      res.add("贪狼会昌曲：诗酒风流，酷爱文艺。[cite: 247]");
    if (_hasPeach(all)) res.add("贪狼会桃花诸曜：易沉迷花酒，女命眼神流丽多欠正大。[cite: 250]");
    if (_hasSha(all)) res.add("贪狼会煞曜：有烟酒嗜好。[cite: 253]");
    if (all.contains('七杀') || all.contains('破军'))
      res.add("贪狼见七杀破军(特例)：不宜见，否则易沉迷酒色。[cite: 280]");

    if (mod['贪狼'] == '权') res.add("贪狼化权：无煞正常发挥；逢四煞反主应酬破财。[cite: 265]");
    if (mod['贪狼'] == '禄') res.add("贪狼化禄：需同时见火铃，否则进财不大且易惹桃花。[cite: 268]");
    if (!all.contains('火星') && !all.contains('铃星') && zhi != '午') {
      res.add("不入火贪铃贪木火通明：遇禄亦不宜经商，可从事消费文艺；见桃花宜演艺化妆。[cite: 262]");
    }
  }

  static void _getTianfuRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("天府独坐：面色黄白，面型方圆颧骨中正；性稳重心宽体胖，守财有道善谋算。[cite: 284]");
      if (zhi == '子' || zhi == '午')
        res.add("天府子午独坐：入庙得助，财帛丰富声望可增；落陷仍可守成。[cite: 311]");
    }
    res.add("女命天府：衣禄丰足守成致富；若化禄权可兼顾家庭与事业。[cite: 305]");

    if (all.contains('武曲'))
      res.add("天府武曲同度：主创业理财有方，守财得力事业稳定；宜稳健不宜冒进。[cite: 299]");
    if (all.contains('廉贞'))
      res.add("天府廉贞同度：内心宽厚，守成为主；适合行政理财管理，稳重可贵。[cite: 302]");
    if (all.contains('紫微'))
      res.add("天府紫微同度：性格稳重，守成致富能力强；遇化禄或化权则主显达贵显。[cite: 308]");

    if (mod['天府'] == '禄') res.add("天府化禄：富贵安稳财帛丰厚，可守成致富；性情仁慈易受朋友欢迎。[cite: 287]");
    if (mod['天府'] == '权') res.add("天府化权：增加权势，利掌管财务或企业，行事可大权独揽。[cite: 290]");
    if (mod['天府'] == '科') res.add("天府化科：名誉声望高，适合教育文化或官职，主文职顺遂。[cite: 293]");
    if (mod['天府'] == '忌') res.add("天府化忌：子午宫化忌易受损财或招小人，生活谨慎；女命感情烦扰。[cite: 296]");
  }

  static void _getTaiyinRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("太阴独坐：面色白净体态丰厚眉清目秀；性情柔顺善忍耐，感情丰富。[cite: 315]");
      if (zhi == '寅' || zhi == '申')
        res.add("太阴寅申独坐：入庙较佳少年得父母福荫；成年稳重踏实感情顺利。[cite: 333]");
      if (zhi == '巳' || zhi == '亥')
        res.add("太阴巳亥独坐：入庙力量较弱，性情多愁；遇吉曜辅佐仍可安稳度日。[cite: 336]");
    }

    if (all.contains('文昌') && all.contains('文曲'))
      res.add("太阴昌曲同度：增加才智，利学术文艺；女命有美丽容貌善理家务。[cite: 330]");

    if (mod['太阴'] == '禄') res.add("太阴化禄：生活安逸财帛丰厚，可富可贵；感情顺利夫妻和睦。[cite: 318]");
    if (mod['太阴'] == '权') res.add("太阴化权：增强影响力权威，利管理；女命可主家中持家有方。[cite: 321]");
    if (mod['太阴'] == '科') res.add("太阴化科：声誉显著，宜教育文职科研；男命多利科研文书。[cite: 324]");
    if (mod['太阴'] == '忌') res.add("太阴化忌：多愁善感，身心易受忧虑疾病影响；女命感情不顺宜晚婚。[cite: 327]");
  }

  static void _getJumenRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("巨门独坐：面型方或长方，性聪明敏捷口才佳善辩；多疑主口舌是非。[cite: 340]");
      if (zhi == '子' || zhi == '午')
        res.add("巨门子午独坐：子宫入庙智慧聪明口才极佳；午宫权谋增强事业受器重。[cite: 358]");
      if (zhi == '巳' || zhi == '亥')
        res.add("巨门巳亥独坐：入庙较弱，主多口舌烦恼；遇吉曜或辅佐可改善。[cite: 361]");
    }

    if (all.contains('天同'))
      res.add("巨门天同同度：增加口才与理财能力，能从事文化、传播或公职职业。[cite: 355]");

    if (mod['巨门'] == '禄') res.add("巨门化禄：主口才利财，能言善辩财运佳；遇吉曜可仕学或文化职业。[cite: 343]");
    if (mod['巨门'] == '权')
      res.add("巨门化权：可增加权势及执行力，宜行政管理；女命可主家中事务有序。[cite: 346]");
    if (mod['巨门'] == '科') res.add("巨门化科：主名誉显赫，宜教育文化科研；男命有利写作科研。[cite: 349]");
    if (mod['巨门'] == '忌') res.add("巨门化忌：容易口舌是非或招讼争；女命感情不顺宜迟婚。[cite: 352]");
  }

  static void _getTianxiangRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("天相独坐：面型端正眉清目秀；性情稳重谦和，善判断协调，处事长袖善舞。[cite: 365]");
      if (zhi == '巳' || zhi == '亥')
        res.add("天相巳亥独坐：巳宫入庙行动稳健；亥宫入陷性格犹豫，多虑少果。[cite: 383]");
    }

    if (all.contains('天梁'))
      res.add("天相天梁同度：性格谦和，权谋增加；遇吉曜可顺利掌管管理职位。[cite: 380]");

    if (mod['天相'] == '禄') res.add("天相化禄：安稳致富家境富厚；有权势不显锋芒，适合行政或守成。[cite: 368]");
    if (mod['天相'] == '权') res.add("天相化权：增加威望与权力，利管理职位；女命可主家中稳重。[cite: 371]");
    if (mod['天相'] == '科') res.add("天相化科：名誉声望高，适合从事教育文化科研；男性主文书才艺。[cite: 374]");
    if (mod['天相'] == '忌') res.add("天相化忌：容易忧虑多思，精神受困扰；女命感情不顺宜晚婚。[cite: 377]");
  }

  static void _getTianliangRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("天梁独坐：面型端正中等偏胖；性情沉稳仁厚善理财；处事保守稳健。[cite: 387]");
      if (zhi == '巳' || zhi == '亥')
        res.add("天梁巳亥独坐：巳宫入庙行动稳健生活安稳；亥宫入陷多虑行动迟缓。[cite: 405]");
    }

    if (all.contains('天相')) res.add("天梁天相同度：性格谦和稳重；利掌管行政或管理职位。[cite: 402]");

    if (mod['天梁'] == '禄') res.add("天梁化禄：财帛丰厚生活安稳；性格宽厚能守财成富。[cite: 390]");
    if (mod['天梁'] == '权')
      res.add("天梁化权：增加权势，可主行政管理；女性宜持家有方，男性利于官职。[cite: 393]");
    if (mod['天梁'] == '科') res.add("天梁化科：名誉声望高，宜从事教育文职科研；利文书学术研究。[cite: 396]");
    if (mod['天梁'] == '忌') res.add("天梁化忌：容易忧虑多思精神受困；女命感情不顺宜晚婚。[cite: 399]");
  }

  static void _getQishaRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("七杀独坐：面型方正带棱，眉目凌厉；性情果决好胜有决断力；易冲动急切。[cite: 409]");
      if (zhi == '巳' || zhi == '亥')
        res.add("七杀巳亥独坐：巳宫入庙有利官职或创业；亥宫入陷多虑且行动受阻。[cite: 427]");
    }

    if (all.contains('廉贞')) res.add("七杀廉贞同度：行动力强但易冲动；需辅佐吉曜方能顺利发展。[cite: 424]");

    if (mod['七杀'] == '禄') res.add("七杀化禄：能制财聚财，善经营事业；若会吉曜辅佐则可富贵显达。[cite: 412]");
    if (mod['七杀'] == '权') res.add("七杀化权：主事业权势增强，可掌管大权；女性可主家庭中掌权。[cite: 415]");
    if (mod['七杀'] == '科')
      res.add("七杀化科：声誉显著，宜从事文职军事科研；男性有利官职或专业技能。[cite: 418]");
    if (mod['七杀'] == '忌') res.add("七杀化忌：容易冲动惹祸，或身心多灾；女命婚姻不顺宜晚婚。[cite: 421]");
  }

  static void _getPojunRules(
    String zhi,
    bool isSolo,
    List<String> all,
    Map<String, String> mod,
    List<String> res,
  ) {
    if (isSolo) {
      res.add("破军独坐：面型方带棱，面色青白青黑；性格果决有冒险精神，作事果断多变动。[cite: 431]");
      if (zhi == '巳' || zhi == '亥')
        res.add("破军巳亥独坐：巳宫入庙利行动力开创能力；亥宫入陷行动易受阻多波折。[cite: 449]");
    }

    if (all.contains('紫微'))
      res.add("破军紫微同度：行动力增强，易历波折而有成就；遇吉曜辅佐则贵显。[cite: 446]");

    if (mod['破军'] == '禄') res.add("破军化禄：可突发财运，创业有利；若吉曜辅佐则稳健可成大业。[cite: 434]");
    if (mod['破军'] == '权') res.add("破军化权：力量决断力增强，利开创掌握权势；女性可主家中权威。[cite: 437]");
    if (mod['破军'] == '科')
      res.add("破军化科：名誉显著，可从事文化教育文职；男性利专业技能女性利职业。[cite: 440]");
    if (mod['破军'] == '忌') res.add("破军化忌：易有突发灾害感情波折；行动多变，慎防损财招小人。[cite: 443]");
  }
}

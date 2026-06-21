# ===========================================================================
# format_output.R - 结果格式化与复现校验模块
# 生成 SPSS 风格三线表 Markdown 报告，逐项对比计算值与原文统计量
# ===========================================================================

# ---------------------------------------------------------------------------
# 工具函数：p值格式化（含显著性星号标记）
# *** p<0.001, ** p<0.01, * p<0.05, † p<0.10
# ---------------------------------------------------------------------------
fmt_p <- function(p) {
  if (is.na(p)) return("")
  stars <- ifelse(p < 0.001, "***",
           ifelse(p < 0.01, "**",
           ifelse(p < 0.05, "*",
           ifelse(p < 0.10, "\u2020", ""))))
  p_str <- ifelse(p < 0.001, "< 0.001", sprintf("%.3f", p))
  paste0(p_str, stars)
}

# ---------------------------------------------------------------------------
# 复现校验函数：对比计算值与原文统计量
# F/t/z值使用相对误差2%阈值；η²/r/d值使用绝对误差0.02阈值
# ---------------------------------------------------------------------------
compare_stat <- function(computed, original, label) {
  if (label %in% c("F","t","z")) {
    # 用绝对值比较（原文均报告正值），相对误差<2%视为复现成功
    rel_diff <- abs(abs(computed) - abs(original)) / abs(original)
    if (rel_diff < 0.02) return("REPRODUCED")
    return(sprintf("DIFF(%.1f%%)", rel_diff*100))
  }
  # η²/r/d：绝对差值<0.02视为复现成功
  if (abs(computed - original) < 0.02) return("REPRODUCED")
  return(sprintf("DIFF(%.3f)", abs(computed-original)))
}

# ---------------------------------------------------------------------------
# 主报告构建函数：按Study 1a→1b→2a→2b→2c顺序输出SPSS三线表
# ---------------------------------------------------------------------------
build_report <- function(res1a, res1b, res2a, res2b, res2c) {
  lines <- c()
  add <- function(...) lines <<- c(lines, paste0(...))
  sep <- function() lines <<- c(lines, "")

  add("# 复现分析报告 | Reproduction Analysis Report")
  sep()
  add(sprintf("**生成时间**: %s", Sys.time()))
  add("**说明**: ANOVA 使用 Type II SS（与 SPSS Type III 数值接近）；F/t 值比较使用相对误差<2%阈值")
  sep()
  add("---")
  sep()

  # =====================================================================
  # Study 1a：2×2×2×3 ANOVA + 分场景 + Sobel 中介
  # =====================================================================
  add("## Study 1a: 关注×获益×时间×场景顺序 (2×2×2×3)")
  sep()
  add(sprintf("- **N** = %d（原始312名，排除3名缺失值）", res1a$n))
  add(sprintf("- **Cronbach α** = %.2f（9条目亲密感，原文：0.76）", res1a$alpha))
  sep()

  # --- 亲密感 ANOVA ---
  add("### 2×2×2×3 ANOVA (Type II SS)：亲密感")
  sep()
  add("| 效应 | df1 | df2 | F | p | η²(p) | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  a <- res1a$anova
  ef <- a$focus_intimacy
  add(sprintf("| 关注（Focus） | %d | %d | %.2f | %s | %.3f | 35.36*** | %s |",
      ef$df1, ef$df2, ef$F, fmt_p(ef$p), ef$eta2, compare_stat(ef$F, 35.36, "F")))
  eb <- a$benefit_intimacy
  add(sprintf("| 获益（Benefit） | %d | %d | %.2f | %s | %.3f | 5.96* | %s |",
      eb$df1, eb$df2, eb$F, fmt_p(eb$p), eb$eta2, compare_stat(eb$F, 5.96, "F")))
  sep()

  # --- 帮助期望 ANOVA ---
  add("### 2×2×2×3 ANOVA (Type II SS)：对伴侣帮助的期望")
  sep()
  add("| 效应 | df1 | df2 | F | p | η²(p) | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  ef_exp <- a$focus_exp_help
  add(sprintf("| 关注（Focus） | %d | %d | %.2f | %s | %.3f | 13.74*** | %s |",
      ef_exp$df1, ef_exp$df2, ef_exp$F, fmt_p(ef_exp$p), ef_exp$eta2, compare_stat(ef_exp$F, 13.74, "F")))
  sep()

  # --- 帮助意愿 ANOVA ---
  add("### 2×2×2×3 ANOVA (Type II SS)：帮助伴侣的意愿")
  sep()
  add("| 效应 | df1 | df2 | F | p | η²(p) | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  ef_w <- a$focus_will_help
  add(sprintf("| 关注（Focus） | %d | %d | %.2f | %s | %.3f | 11.70*** | %s |",
      ef_w$df1, ef_w$df2, ef_w$F, fmt_p(ef_w$p), ef_w$eta2, compare_stat(ef_w$F, 11.70, "F")))
  eb_w <- a$benefit_will_help
  add(sprintf("| 获益（Benefit） | %d | %d | %.2f | %s | %.3f | 8.76** | %s |",
      eb_w$df1, eb_w$df2, eb_w$F, fmt_p(eb_w$p), eb_w$eta2, compare_stat(eb_w$F, 8.76, "F")))
  sep()

  # --- 分场景 ANOVA：关注主效应 ---
  add("### 分场景方差分析：关注主效应对亲密感的影响")
  sep()
  add("| 场景 | F | df1 | df2 | p | η²(p) | 原文 η² | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  orig_eta <- c(advice = 0.053, surprise = 0.022, moral = 0.091)
  for (sc in names(res1a$scenario)) {
    s <- res1a$scenario[[sc]]
    add(sprintf("| %s | %.2f | %d | %d | %s | %.3f | %.3f | %s |",
        sc, s$focus_F, s$focus_df1, s$focus_df2, fmt_p(s$focus_p), s$focus_eta2,
        orig_eta[sc], compare_stat(s$focus_eta2, orig_eta[sc], "eta2")))
  }
  sep()

  # --- 分场景：获益主效应（边际显著） ---
  add("### 分场景方差分析：获益主效应对亲密感的影响")
  sep()
  add("| 场景 | F | df1 | df2 | p | η²(p) | 说明 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:-----|")
  for (sc in names(res1a$scenario)) {
    s <- res1a$scenario[[sc]]
    add(sprintf("| %s | %.2f | %d | %d | %s | %.3f | 原文：建议p=0.084，惊喜p=0.070（边际显著）|",
        sc, s$benefit_F, s$benefit_df1, s$benefit_df2, fmt_p(s$benefit_p), s$benefit_eta2))
  }
  sep()

  # --- Sobel 中介 ---
  add("### Sobel 中介效应检验")
  sep()
  add("| 路径 | z | p | 原文 z | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|")
  so <- res1a$sobel
  add(sprintf("| 关注→亲密感→帮助期望 | %.2f | %s | 5.34*** | %s |",
      so$exp_help$z, fmt_p(so$exp_help$p), compare_stat(so$exp_help$z, 5.34, "z")))
  add(sprintf("| 关注→亲密感→帮助意愿 | %.2f | %s | 5.32*** | %s |",
      so$will_help$z, fmt_p(so$will_help$p), compare_stat(so$will_help$z, 5.32, "z")))
  sep()
  add("---")
  sep()

  # =====================================================================
  # Study 1b：2×2×2×3（性别×关注×获益×顺序）
  # =====================================================================
  add("## Study 1b: 关注×获益×性别×场景顺序 (2×2×2×3)")
  sep()
  add(sprintf("- **N** = %d（无排除）", res1b$n))
  add(sprintf("- **Cronbach α** = %.2f（9条目，原文：0.82）", res1b$alpha))
  sep()

  add("### 2×2×2×3 ANOVA (Type II SS)：亲密感")
  sep()
  add("| 效应 | df1 | df2 | F | p | η²(p) | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  ab <- res1b$anova
  ef1b <- ab$focus_intimacy
  add(sprintf("| 关注（Focus） | %d | %d | %.2f | %s | %.3f | 45.76*** | %s |",
      ef1b$df1, ef1b$df2, ef1b$F, fmt_p(ef1b$p), ef1b$eta2, compare_stat(ef1b$F, 45.76, "F")))
  eb1b <- ab$benefit_intimacy
  add(sprintf("| 获益（Benefit） | %d | %d | %.2f | %s | %.3f | 6.60* | %s |",
      eb1b$df1, eb1b$df2, eb1b$F, fmt_p(eb1b$p), eb1b$eta2, compare_stat(eb1b$F, 6.60, "F")))
  sep()

  add("### 2×2×2×3 ANOVA (Type II SS)：对伴侣帮助的期望")
  sep()
  add("| 效应 | df1 | df2 | F | p | η²(p) | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  ef1b_exp <- ab$focus_exp_help
  add(sprintf("| 关注（Focus） | %d | %d | %.2f | %s | %.3f | 8.50** | %s |",
      ef1b_exp$df1, ef1b_exp$df2, ef1b_exp$F, fmt_p(ef1b_exp$p), ef1b_exp$eta2, compare_stat(ef1b_exp$F, 8.50, "F")))
  sep()

  add("### 2×2×2×3 ANOVA (Type II SS)：帮助伴侣的意愿")
  sep()
  add("| 效应 | df1 | df2 | F | p | η²(p) | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  ef1b_will <- ab$focus_will_help
  add(sprintf("| 关注（Focus） | %d | %d | %.2f | %s | %.3f | 7.19** | %s |",
      ef1b_will$df1, ef1b_will$df2, ef1b_will$F, fmt_p(ef1b_will$p), ef1b_will$eta2, compare_stat(ef1b_will$F, 7.19, "F")))
  sep()

  add("### 分场景：关注主效应对亲密感的影响")
  sep()
  add("| 场景 | F | df1 | df2 | p | η²(p) | 原文 η² | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  orig_eta1b <- c(advice = 0.150, surprise = 0.230, moral = 0.214)
  for (sc in names(res1b$scenario)) {
    s <- res1b$scenario[[sc]]
    add(sprintf("| %s | %.2f | %d | %d | %s | %.3f | %.3f | %s |",
        sc, s$focus_F, s$focus_df1, s$focus_df2, fmt_p(s$focus_p), s$focus_eta2,
        orig_eta1b[sc], compare_stat(s$focus_eta2, orig_eta1b[sc], "eta2")))
  }
  sep()

  add("### 分场景：获益主效应对亲密感的影响")
  sep()
  add("| 场景 | F | df1 | df2 | p | η²(p) | 说明 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:-----|")
  for (sc in names(res1b$scenario)) {
    s <- res1b$scenario[[sc]]
    add(sprintf("| %s | %.2f | %d | %d | %s | %.3f | 原文：惊喜F=10.18 p=0.002 |",
        sc, s$benefit_F, s$benefit_df1, s$benefit_df2, fmt_p(s$benefit_p), s$benefit_eta2))
  }
  sep()

  add("### Sobel 中介效应检验")
  sep()
  add("| 路径 | z | p | 原文 z | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|")
  so1b <- res1b$sobel
  add(sprintf("| 关注→亲密感→帮助期望 | %.2f | %s | 5.45*** | %s |",
      so1b$exp_help$z, fmt_p(so1b$exp_help$p), compare_stat(so1b$exp_help$z, 5.45, "z")))
  add(sprintf("| 关注→亲密感→帮助意愿 | %.2f | %s | 5.06*** | %s |",
      so1b$will_help$z, fmt_p(so1b$will_help$p), compare_stat(so1b$will_help$z, 5.06, "z")))
  sep()
  add("---")
  sep()

  # =====================================================================
  # Study 2a：独立样本t检验 + 单样本t + Pearson相关
  # =====================================================================
  add("## Study 2a: 关注（80% vs 0%）→ 亲密感 / 友谊兴趣")
  sep()
  add(sprintf("- **N** = %d（30名参与，排除1名怀疑欺骗者）", res2a$n))
  sep()

  add("### 独立样本 t 检验")
  sep()
  add("| 变量 | t | df | p | Cohen d | M±SD (关注组) | M±SD (无关注组) | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  int2a <- res2a$intimacy
  add(sprintf("| 亲密感 | %.2f | %d | %s | %.2f | %.2f±%.2f | %.2f±%.2f | t=5.91 d=2.20 | %s |",
      abs(int2a$t), int2a$df, fmt_p(int2a$p), int2a$d,
      int2a$mean_focus, int2a$sd_focus, int2a$mean_nofocus, int2a$sd_nofocus,
      compare_stat(abs(int2a$t), 5.91, "t")))
  fr2a <- res2a$friendship
  add(sprintf("| 友谊兴趣 | %.2f | %d | %s | - | - | - | t=1.04 p=0.306 | %s |",
      abs(fr2a$t), fr2a$df, fmt_p(fr2a$p), compare_stat(abs(fr2a$t), 1.04, "t")))
  sep()

  add("### 单样本 t 检验（与量表中点4分比较）")
  sep()
  add("| 组别 | t | df | p | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|")
  os2a <- res2a$one_sample
  add(sprintf("| 无关注组 | %.2f | %d | %s | t=5.60 p<0.001（显著低于中点） | %s |",
      abs(os2a$nofocus$t), os2a$nofocus$df, fmt_p(os2a$nofocus$p), compare_stat(abs(os2a$nofocus$t), 5.60, "t")))
  add(sprintf("| 关注组 | %.2f | %d | %s | t=2.77 p=0.015（显著高于中点） | %s |",
      abs(os2a$focus$t), os2a$focus$df, fmt_p(os2a$focus$p), compare_stat(abs(os2a$focus$t), 2.77, "t")))
  sep()

  add("### Pearson 相关：亲密感与友谊兴趣")
  sep()
  add("| r | df | p | 原文 | 校验 |")
  add("|:---:|:---:|:---:|:---:|:---:|")
  cor2a <- res2a$correlation
  add(sprintf("| %.2f | %d | %s | r=0.38 p=0.045 | %s |",
      cor2a$r, cor2a$df, fmt_p(cor2a$p), compare_stat(cor2a$r, 0.38, "r")))
  sep()
  add("---")
  sep()

  # =====================================================================
  # Study 2b：有意关注 vs 无意图
  # =====================================================================
  add("## Study 2b: 有意关注（80%）vs 无意图（系统随机信号）")
  sep()
  add(sprintf("- **N** = %d（45名参与，排除1名怀疑欺骗者）", res2b$n))
  sep()

  add("### 独立样本 t 检验")
  sep()
  add("| 变量 | t | df | p | Cohen d | M±SD (有意) | M±SD (无意图) | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  int2b <- res2b$intimacy
  add(sprintf("| 亲密感 | %.2f | %d | %s | %.2f | %.2f±%.2f | %.2f±%.2f | t=4.10 d=1.27 | %s |",
      abs(int2b$t), int2b$df, fmt_p(int2b$p), int2b$d,
      int2b$mean_focus, int2b$sd_focus, int2b$mean_nofocus, int2b$sd_nofocus,
      compare_stat(abs(int2b$t), 4.10, "t")))
  fr2b <- res2b$friendship
  add(sprintf("| 友谊兴趣 | %.2f | %d | %s | %.2f | - | - | t=1.96 p=0.057 d=0.59 | %s |",
      abs(fr2b$t), fr2b$df, fmt_p(fr2b$p), fr2b$d, compare_stat(abs(fr2b$t), 1.96, "t")))
  sep()

  add("### 单样本 t 检验（vs 中点4）：无意图组为中性控制")
  sep()
  add("| 组别 | t | df | p | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|")
  os2b <- res2b$one_sample
  add(sprintf("| 无意图组 | %.2f | %d | %s | t=1.67 p>0.05（与中点无差异） | %s |",
      abs(os2b$nointent$t), os2b$nointent$df, fmt_p(os2b$nointent$p), compare_stat(abs(os2b$nointent$t), 1.67, "t")))
  add(sprintf("| 有意关注组 | %.2f | %d | %s | t=4.84 p<0.001（显著高于中点） | %s |",
      abs(os2b$intent$t), os2b$intent$df, fmt_p(os2b$intent$p), compare_stat(abs(os2b$intent$t), 4.84, "t")))
  sep()

  add("### Pearson 相关：亲密感与友谊兴趣")
  sep()
  add("| r | df | p | 原文 | 校验 |")
  add("|:---:|:---:|:---:|:---:|:---:|")
  cor2b <- res2b$correlation
  add(sprintf("| %.2f | %d | %s | r=0.68 p<0.001 | %s |",
      cor2b$r, cor2b$df, fmt_p(cor2b$p), compare_stat(cor2b$r, 0.68, "r")))
  sep()
  add("---")
  sep()

  # =====================================================================
  # Study 2c：三水平 ANOVA + Tukey + 相关 + 配对t
  # =====================================================================
  add("## Study 2c: 关注剂量（低20% / 中50% / 高80%）")
  sep()
  add(sprintf("- **N** = %d（38名参与，排除2名怀疑欺骗者）", res2c$n))
  sep()

  add("### 单因素 ANOVA：亲密感")
  sep()
  add("| 效应 | df1 | df2 | F | p | η²(p) | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
  i2c <- res2c$intimacy_anova
  add(sprintf("| 关注量 | %d | %d | %.2f | %s | %.3f | F=3.97 η²=0.194 | %s |",
      i2c$df1, i2c$df2, i2c$F, fmt_p(i2c$p), i2c$eta2, compare_stat(i2c$F, 3.97, "F")))
  sep()

  add("### 单因素 ANOVA：友谊兴趣")
  sep()
  add("| 效应 | df1 | df2 | F | p | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|")
  f2c <- res2c$friendship_anova
  add(sprintf("| 关注量 | %d | %d | %.2f | %s | F=1.12 p>0.05 | %s |",
      f2c$df1, f2c$df2, f2c$F, fmt_p(f2c$p), compare_stat(f2c$F, 1.12, "F")))
  sep()

  add("### Tukey HSD 事后检验：亲密感组间比较")
  sep()
  add("| 比较 | 均值差 | 下限 | 上限 | p | 原文 | 校验 |")
  add("|:-----|:---:|:---:|:---:|:---:|:---:|:---:|")
  tk <- res2c$tukey
  orig_tukey <- c("Medium(50%)-Low(20%)" = NA, "High(80%)-Low(20%)" = 0.048, "High(80%)-Medium(50%)" = 0.055)
  for (rn in rownames(tk)) {
    row <- tk[rn, ]
    p_orig <- orig_tukey[rn]
    chk <- if (is.na(p_orig)) "N/A" else compare_stat(round(row$"p adj", 4), p_orig, "p")
    add(sprintf("| %s | %.2f | %.2f | %.2f | %s | %s | %s |",
        rn, row$diff, row$lwr, row$upr, fmt_p(round(row$"p adj", 4)),
        if(is.na(p_orig)) "p>0.05" else sprintf("p=%.3f", p_orig), chk))
  }
  sep()

  add("### Pearson 相关分析")
  sep()
  add("| 变量对 | r | df | p | 原文 | 校验 |")
  add("|:-------|:---:|:---:|:---:|:---:|:---:|")
  cor2c <- res2c$correlations
  add(sprintf("| 实际 vs 估计关注频率 | %.2f | %d | %s | r=0.85 p<0.001 | %s |",
      cor2c$actual_est$r, cor2c$actual_est$df, fmt_p(cor2c$actual_est$p),
      compare_stat(cor2c$actual_est$r, 0.85, "r")))
  add(sprintf("| 实际关注频率 vs 亲密感 | %.2f | %d | %s | r=0.45 p=0.006 | %s |",
      cor2c$actual_int$r, cor2c$actual_int$df, fmt_p(cor2c$actual_int$p),
      compare_stat(cor2c$actual_int$r, 0.45, "r")))
  add(sprintf("| 亲密感 vs 友谊兴趣 | %.2f | %d | %s | r=0.49 p=0.002 | %s |",
      cor2c$intimacy_friend$r, cor2c$intimacy_friend$df, fmt_p(cor2c$intimacy_friend$p),
      compare_stat(cor2c$intimacy_friend$r, 0.49, "r")))
  sep()

  add("### 配对 t 检验：实际 vs 估计关注频率")
  sep()
  add("| t | df | p | 原文 | 校验 |")
  add("|:---:|:---:|:---:|:---:|:---:|")
  pt2c <- res2c$paired_t
  add(sprintf("| %.2f | %d | %s | t=1.01 p>0.05 | %s |",
      abs(pt2c$t), pt2c$df, fmt_p(pt2c$p), compare_stat(abs(pt2c$t), 1.01, "t")))
  sep()

  return(lines)
}
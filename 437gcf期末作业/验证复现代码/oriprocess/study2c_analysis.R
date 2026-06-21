# ===========================================================================
# study2c_analysis.R — Study 2c 统计分析
# 方法：单因素 ANOVA + Tukey HSD + Pearson 相关 + 配对 t 检验
# 自变量：关注量（低20% / 中50% / 高80%），三水平被试间设计
# ===========================================================================

run_study2c <- function(filepath) {
  loaded <- load_study2c(filepath)
  d <- loaded$data

  # --- 单因素 ANOVA：亲密感 ---
  fit_int <- aov(intimacy ~ attention, data = d)
  aov_int <- car::Anova(fit_int, type = 2)
  ss_effect <- aov_int["attention", "Sum Sq"]
  ss_error  <- aov_int["Residuals", "Sum Sq"]
  eta2_int  <- ss_effect / (ss_effect + ss_error)

  intimacy_anova <- list(
    F = round(aov_int["attention", "F value"], 2),
    df1 = aov_int["attention", "Df"],
    df2 = aov_int["Residuals", "Df"],
    p = round(aov_int["attention", "Pr(>F)"], 4),
    eta2 = round(eta2_int, 3)
  )

  # --- 单因素 ANOVA：友谊兴趣（原文：无显著差异） ---
  fit_friend <- aov(friendship ~ attention, data = d)
  aov_friend <- car::Anova(fit_friend, type = 2)
  friendship_anova <- list(
    F = round(aov_friend["attention", "F value"], 2),
    df1 = aov_friend["attention", "Df"],
    df2 = aov_friend["Residuals", "Df"],
    p = round(aov_friend["attention", "Pr(>F)"], 4)
  )

  # --- Tukey HSD 事后多重比较 ---
  tukey_res <- TukeyHSD(fit_int)
  tukey_df <- as.data.frame(tukey_res$attention)

  # --- Pearson 相关分析 ---
  # 实际关注频率 vs 估计频率（原文：r=0.85）
  cor_ae <- cor.test(d$"Actual.attention", d$"Est.attention")
  # 实际关注频率 vs 亲密感（原文：r=0.45）
  cor_ai <- cor.test(d$"Actual.attention", d$intimacy)
  # 亲密感 vs 友谊兴趣（原文：r=0.49）
  cor_if <- cor.test(d$intimacy, d$friendship)

  correlations <- list(
    actual_est = list(r = round(cor_ae$estimate, 2), df = round(cor_ae$parameter, 0),
                      p = round(cor_ae$p.value, 4)),
    actual_int = list(r = round(cor_ai$estimate, 2), df = round(cor_ai$parameter, 0),
                      p = round(cor_ai$p.value, 4)),
    intimacy_friend = list(r = round(cor_if$estimate, 2),
                           df = round(cor_if$parameter, 0),
                           p = round(cor_if$p.value, 4))
  )

  # --- 配对 t 检验：实际 vs 估计关注频率（原文：无显著差异） ---
  t_paired <- t.test(d$"Actual.attention", d$"Est.attention", paired = TRUE)
  paired_t <- list(
    t = round(unname(t_paired$statistic), 2),
    df = round(unname(t_paired$parameter), 0),
    p = round(t_paired$p.value, 4)
  )

  list(n = loaded$n, intimacy_anova = intimacy_anova,
       friendship_anova = friendship_anova, tukey = tukey_df,
       correlations = correlations, paired_t = paired_t)
}
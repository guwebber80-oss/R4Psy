# ===========================================================================
# study1a_analysis.R — Study 1a 统计分析
# 方法：2×2×2×3 被试间 ANOVA（Type II SS）+ 分场景 ANOVA + Sobel 中介检验
# ===========================================================================

# ---------------------------------------------------------------------------
# 2×2×2×3 四因素被试间方差分析
# 对三个因变量分别建模：亲密感、对伴侣帮助的期望、帮助伴侣的意愿
# 使用 car::Anova Type II SS（与 SPSS Type III 数值接近但更稳健）
# ---------------------------------------------------------------------------

run_anova_1a <- function(d) {
  results <- list()

  # --- 因变量1：亲密感 ---
  fit_int <- aov(intimacy ~ attention * benefit * time * Order, data = d)
  aov_tab <- car::Anova(fit_int, type = 2)
  results$intimacy_anova <- aov_tab

  # 从ANOVA表中提取指定效应的F值、自由度、p值和偏η²
  extract_effect <- function(aov_tab, term_name) {
    row <- aov_tab[term_name, ]
    ss_err <- aov_tab["Residuals", "Sum Sq"]
    df_err <- aov_tab["Residuals", "Df"]
    # 偏η² = SS_effect / (SS_effect + SS_error)
    eta2 <- row$"Sum Sq" / (row$"Sum Sq" + ss_err)
    list(F = round(row$"F value", 2), df1 = row$Df, df2 = df_err,
         p = round(row$"Pr(>F)", 4), eta2 = round(eta2, 3))
  }

  # 提取关键主效应（原文报告的核心统计量）
  results$focus_intimacy   <- extract_effect(aov_tab, "attention")
  results$benefit_intimacy <- extract_effect(aov_tab, "benefit")

  # --- 因变量2：对伴侣帮助的期望 ---
  fit_exp <- aov(exp_help ~ attention * benefit * time * Order, data = d)
  aov_exp <- car::Anova(fit_exp, type = 2)
  results$focus_exp_help <- extract_effect(aov_exp, "attention")

  # --- 因变量3：帮助伴侣的意愿 ---
  fit_will <- aov(will_help ~ attention * benefit * time * Order, data = d)
  aov_will <- car::Anova(fit_will, type = 2)
  results$focus_will_help  <- extract_effect(aov_will, "attention")
  results$benefit_will_help <- extract_effect(aov_will, "benefit")

  return(results)
}

# ---------------------------------------------------------------------------
# 分场景单独方差分析
# 对建议、惊喜、道德支持三个场景分别运行相同的2×2×2×3模型
# 提取关注和获益的主效应
# ---------------------------------------------------------------------------

run_per_scenario_1a <- function(d) {
  scenarios <- c("advice", "surprise", "moral")
  results <- list()
  for (sc in scenarios) {
    dv_name <- paste0("intimacy_", sc)
    # 使用该场景特定的亲密感得分作为因变量
    formula <- as.formula(paste(dv_name, "~ attention * benefit * time * Order"))
    fit <- aov(formula, data = d)
    aov_tab <- car::Anova(fit, type = 2)
    ss_err <- aov_tab["Residuals", "Sum Sq"]
    df_err <- aov_tab["Residuals", "Df"]
    focus_row <- aov_tab["attention", ]
    benefit_row <- aov_tab["benefit", ]
    results[[sc]] <- list(
      focus_F = round(focus_row$"F value", 2),
      focus_df1 = focus_row$Df, focus_df2 = df_err,
      focus_p = round(focus_row$"Pr(>F)", 4),
      focus_eta2 = round(focus_row$"Sum Sq" / (focus_row$"Sum Sq" + ss_err), 3),
      benefit_F = round(benefit_row$"F value", 2),
      benefit_df1 = benefit_row$Df, benefit_df2 = df_err,
      benefit_p = round(benefit_row$"Pr(>F)", 4),
      benefit_eta2 = round(benefit_row$"Sum Sq" / (benefit_row$"Sum Sq" + ss_err), 3)
    )
  }
  return(results)
}

# ---------------------------------------------------------------------------
# Sobel 中介效应检验
# 路径：关注(X) → 亲密感(M) → 对伴侣帮助的期望 / 帮助伴侣的意愿(Y)
# Sobel z = a*b / √(b²*SEa² + a²*SEb²)
# 原文均报告为完全中介
# ---------------------------------------------------------------------------

run_sobel_1a <- function(d) {
  # 将关注因子转换为数值（0=无关注, 1=有关注）
  x <- as.numeric(d$attention) - 1

  # 路径a：关注 → 亲密感
  fit_a <- lm(intimacy ~ x, data = d)
  a <- coef(fit_a)[2]       # 路径系数a
  se_a <- summary(fit_a)$coefficients[2, 2]  # a的标准误

  # 路径b（控制X后M→Y）：关注+亲密感 → 对伴侣帮助的期望
  fit_b_exp <- lm(exp_help ~ x + intimacy, data = d)
  b_exp <- coef(fit_b_exp)[3]
  se_b_exp <- summary(fit_b_exp)$coefficients[3, 2]

  # 路径b（控制X后M→Y）：关注+亲密感 → 帮助伴侣的意愿
  fit_b_will <- lm(will_help ~ x + intimacy, data = d)
  b_will <- coef(fit_b_will)[3]
  se_b_will <- summary(fit_b_will)$coefficients[3, 2]

  # Sobel检验公式
  sobel_z <- function(a, se_a, b, se_b) {
    a * b / sqrt(b^2 * se_a^2 + a^2 * se_b^2)
  }

  z_exp  <- sobel_z(a, se_a, b_exp, se_b_exp)
  z_will <- sobel_z(a, se_a, b_will, se_b_will)

  list(
    exp_help  = list(z = round(z_exp, 2),  p = round(2 * pnorm(-abs(z_exp)), 4)),
    will_help = list(z = round(z_will, 2), p = round(2 * pnorm(-abs(z_will)), 4))
  )
}

# ---------------------------------------------------------------------------
# Master函数：串联数据加载与全部分析流程
# ---------------------------------------------------------------------------

run_study1a <- function(filepath) {
  loaded <- load_study1a(filepath)
  d <- loaded$data
  list(
    n = loaded$n, alpha = loaded$alpha,
    anova = run_anova_1a(d),
    scenario = run_per_scenario_1a(d),
    sobel = run_sobel_1a(d)
  )
}
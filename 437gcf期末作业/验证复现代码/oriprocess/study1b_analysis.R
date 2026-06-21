# ===========================================================================
# study1b_analysis.R — Study 1b 统计分析
# 方法：2×2×2×3 被试间 ANOVA（Type II SS）+ 分场景 + Sobel
# 与 Study 1a 设计一致，但用性别替换时间因素
# ===========================================================================

run_anova_1b <- function(d) {
  results <- list()
  # Study 1b的第四个因素为性别（sex），而非时间
  fit_int <- aov(intimacy ~ attention * benefit * sex * Order, data = d)
  aov_tab <- car::Anova(fit_int, type = 2)
  results$intimacy_anova <- aov_tab

  extract_effect <- function(aov_tab, term_name) {
    row <- aov_tab[term_name, ]
    ss_err <- aov_tab["Residuals", "Sum Sq"]
    df_err <- aov_tab["Residuals", "Df"]
    eta2 <- row$"Sum Sq" / (row$"Sum Sq" + ss_err)
    list(F = round(row$"F value", 2), df1 = row$Df, df2 = df_err,
         p = round(row$"Pr(>F)", 4), eta2 = round(eta2, 3))
  }

  results$focus_intimacy   <- extract_effect(aov_tab, "attention")
  results$benefit_intimacy <- extract_effect(aov_tab, "benefit")

  # 对帮助期望的ANOVA
  fit_exp <- aov(exp_help ~ attention * benefit * sex * Order, data = d)
  aov_exp <- car::Anova(fit_exp, type = 2)
  results$focus_exp_help <- extract_effect(aov_exp, "attention")

  # 对帮助意愿的ANOVA
  fit_will <- aov(will_help ~ attention * benefit * sex * Order, data = d)
  aov_will <- car::Anova(fit_will, type = 2)
  results$focus_will_help <- extract_effect(aov_will, "attention")

  return(results)
}

# 分场景单独方差分析（建议/惊喜/道德支持）
run_per_scenario_1b <- function(d) {
  scenarios <- c("advice", "surprise", "moral")
  results <- list()
  for (sc in scenarios) {
    dv_name <- paste0("intimacy_", sc)
    formula <- as.formula(paste(dv_name, "~ attention * benefit * sex * Order"))
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

# Sobel中介：关注 → 亲密感 → 帮助期望/意愿
run_sobel_1b <- function(d) {
  x <- as.numeric(d$attention) - 1
  fit_a <- lm(intimacy ~ x, data = d)
  a <- coef(fit_a)[2]
  se_a <- summary(fit_a)$coefficients[2, 2]

  fit_b_exp <- lm(exp_help ~ x + intimacy, data = d)
  b_exp <- coef(fit_b_exp)[3]
  se_b_exp <- summary(fit_b_exp)$coefficients[3, 2]

  fit_b_will <- lm(will_help ~ x + intimacy, data = d)
  b_will <- coef(fit_b_will)[3]
  se_b_will <- summary(fit_b_will)$coefficients[3, 2]

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

run_study1b <- function(filepath) {
  loaded <- load_study1b(filepath)
  d <- loaded$data
  list(
    n = loaded$n, alpha = loaded$alpha,
    anova = run_anova_1b(d),
    scenario = run_per_scenario_1b(d),
    sobel = run_sobel_1b(d)
  )
}
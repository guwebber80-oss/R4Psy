# ===========================================================================
# study2a_analysis.R — Study 2a 统计分析
# 方法：独立样本 t 检验 + 单样本 t 检验 + Pearson 相关
# 自变量：关注（80%监控 vs 0%监控），因变量：亲密感、友谊兴趣
# ===========================================================================

run_study2a <- function(filepath) {
  loaded <- load_study2a(filepath)
  d <- loaded$data

  # 分组
  focus_y <- d$intimacy[d$attention == "Yes"]
  focus_n <- d$intimacy[d$attention == "No"]

  # --- 独立样本 t 检验：亲密感 ---
  t_int <- t.test(intimacy ~ attention, data = d, var.equal = TRUE)
  # Cohen's d = (M1 - M2) / pooled_sd
  pooled_sd <- sqrt(((length(focus_y)-1)*var(focus_y) + (length(focus_n)-1)*var(focus_n)) / 
                    (length(focus_y) + length(focus_n) - 2))
  cohens_d_int <- (mean(focus_y) - mean(focus_n)) / pooled_sd

  intimacy_result <- list(
    t = round(unname(t_int$statistic), 2),
    df = round(unname(t_int$parameter), 0),
    p = round(t_int$p.value, 4),
    d = round(cohens_d_int, 2),
    mean_focus = round(mean(focus_y), 2),
    sd_focus   = round(sd(focus_y), 2),
    mean_nofocus = round(mean(focus_n), 2),
    sd_nofocus   = round(sd(focus_n), 2)
  )

  # --- 独立样本 t 检验：友谊兴趣（原文：无显著差异） ---
  t_friend <- t.test(friendship ~ attention, data = d, var.equal = TRUE)
  friendship_result <- list(
    t = round(unname(t_friend$statistic), 2),
    df = round(unname(t_friend$parameter), 0),
    p = round(t_friend$p.value, 4)
  )

  # --- 单样本 t 检验：与量表中点4分比较 ---
  t_one_nofocus <- t.test(focus_n, mu = 4)
  t_one_focus   <- t.test(focus_y, mu = 4)

  one_sample <- list(
    nofocus = list(t = round(unname(t_one_nofocus$statistic), 2),
                   df = round(unname(t_one_nofocus$parameter), 0),
                   p = round(t_one_nofocus$p.value, 4)),
    focus   = list(t = round(unname(t_one_focus$statistic), 2),
                   df = round(unname(t_one_focus$parameter), 0),
                   p = round(t_one_focus$p.value, 4))
  )

  # --- Pearson 相关：亲密感与友谊兴趣 ---
  cor_test <- cor.test(d$intimacy, d$friendship)
  correl <- list(r = round(cor_test$estimate, 2),
                 df = round(cor_test$parameter, 0),
                 p = round(cor_test$p.value, 4))

  list(n = loaded$n, intimacy = intimacy_result, friendship = friendship_result,
       one_sample = one_sample, correlation = correl)
}
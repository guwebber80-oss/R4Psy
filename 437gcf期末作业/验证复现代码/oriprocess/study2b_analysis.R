# ===========================================================================
# study2b_analysis.R — Study 2b 统计分析
# 方法：独立样本 t 检验 + 单样本 t 检验 + Pearson 相关
# 自变量：有意关注（80%）vs 无意图（系统随机信号）
# ===========================================================================

run_study2b <- function(filepath) {
  loaded <- load_study2b(filepath)
  d <- loaded$data

  focus_y <- d$intimacy[d$attention == "Intentional"]
  focus_n <- d$intimacy[d$attention == "NoIntent"]

  # --- 独立样本 t 检验：亲密感 ---
  t_int <- t.test(intimacy ~ attention, data = d, var.equal = TRUE)
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

  # --- 独立样本 t 检验：友谊兴趣（原文：边际显著，d=0.59） ---
  t_friend <- t.test(friendship ~ attention, data = d, var.equal = TRUE)
  n1 <- sum(d$attention == "Intentional")
  n2 <- sum(d$attention == "NoIntent")
  pool_sd_f <- sqrt(((n1-1)*var(d$friendship[d$attention=="Intentional"]) +
                     (n2-1)*var(d$friendship[d$attention=="NoIntent"])) / (n1+n2-2))
  cohens_d_friend <- (mean(d$friendship[d$attention=="Intentional"]) -
                      mean(d$friendship[d$attention=="NoIntent"])) / pool_sd_f

  friendship_result <- list(
    t = round(unname(t_friend$statistic), 2),
    df = round(unname(t_friend$parameter), 0),
    p = round(t_friend$p.value, 4),
    d = round(cohens_d_friend, 2)
  )

  # --- 单样本 t 检验（vs 中点4）：无意图组为中性控制 ---
  t_one_nointent <- t.test(focus_n, mu = 4)
  t_one_intent   <- t.test(focus_y, mu = 4)

  one_sample <- list(
    nointent = list(t = round(unname(t_one_nointent$statistic), 2),
                    df = round(unname(t_one_nointent$parameter), 0),
                    p = round(t_one_nointent$p.value, 4)),
    intent   = list(t = round(unname(t_one_intent$statistic), 2),
                    df = round(unname(t_one_intent$parameter), 0),
                    p = round(t_one_intent$p.value, 4))
  )

  # --- Pearson 相关 ---
  cor_test <- cor.test(d$intimacy, d$friendship)
  correl <- list(r = round(cor_test$estimate, 2),
                 df = round(cor_test$parameter, 0),
                 p = round(cor_test$p.value, 4))

  list(n = loaded$n, intimacy = intimacy_result, friendship = friendship_result,
       one_sample = one_sample, correlation = correl)
}
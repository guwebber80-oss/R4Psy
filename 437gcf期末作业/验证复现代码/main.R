# ===========================================================================
# main.R �? 主执行脚�?
# 功能：加载模�? �? 运行5个子研究分析 �? 生成复现校验Markdown报告
# 使用方法：D:\R-4.5.2\bin\x64\Rscript.exe main.R
# ===========================================================================

# --- 加载依赖�? ---
suppressPackageStartupMessages({
  library(readxl)   # Excel读取
  library(psych)    # Cronbach信度
  library(car)      # Type II/III ANOVA
})

# --- 加载分析模块（按分层架构：数据层→逻辑层→表现层） ---
source("oriprocess/data_loader.R")        # 数据层：加载与清�?
source("oriprocess/study1a_analysis.R")   # 逻辑层：Study 1a分析
source("oriprocess/study1b_analysis.R")   # 逻辑层：Study 1b分析
source("oriprocess/study2a_analysis.R")   # 逻辑层：Study 2a分析
source("oriprocess/study2b_analysis.R")   # 逻辑层：Study 2b分析
source("oriprocess/study2c_analysis.R")   # 逻辑层：Study 2c分析
source("oriprocess/format_output.R")      # 表现层：格式化输�?

# --- 数据文件路径 ---
EXCEL_FILE <- "1-s2.0-S1090513814000245-mmc1.xlsx"

# ===========================================================================
# 依次运行5个子研究
# ===========================================================================

cat("\n==========================================================\n")
cat("  论文复现分析：The Bright Side of Being Watched\n")
cat("  (Sparks & Barclay, 2013, Evolution and Human Behavior)\n")
cat("==========================================================\n")

# --- Study 1a ---
cat("\n>>> 运行 Study 1a：关注×获益×时间×顺�? (N=309)\n")
res1a <- run_study1a(EXCEL_FILE)
cat(sprintf("  N=%d, α=%.3f\n", res1a$n, res1a$alpha))
cat(sprintf("  亲密感：关注F=%.2f, 获益F=%.2f\n", res1a$anova$focus_intimacy$F, res1a$anova$benefit_intimacy$F))
cat(sprintf("  Sobel中介：帮助期望z=%.2f, 帮助意愿z=%.2f\n", res1a$sobel$exp_help$z, res1a$sobel$will_help$z))

# --- Study 1b ---
cat("\n>>> 运行 Study 1b：关注×获益×性别×顺序 (N=105)\n")
res1b <- run_study1b(EXCEL_FILE)
cat(sprintf("  N=%d, α=%.3f\n", res1b$n, res1b$alpha))
cat(sprintf("  亲密感：关注F=%.2f, 获益F=%.2f\n", res1b$anova$focus_intimacy$F, res1b$anova$benefit_intimacy$F))

# --- Study 2a ---
cat("\n>>> 运行 Study 2a：关�?(80% vs 0%) �? 亲密�?/友谊 (N=29)\n")
res2a <- run_study2a(EXCEL_FILE)
cat(sprintf("  N=%d, 亲密感t=%.2f, 友谊t=%.2f\n", res2a$n, abs(res2a$intimacy$t), abs(res2a$friendship$t)))

# --- Study 2b ---
cat("\n>>> 运行 Study 2b：有意关�?(80%) vs 无意�? (N=44)\n")
res2b <- run_study2b(EXCEL_FILE)
cat(sprintf("  N=%d, 亲密感t=%.2f, 友谊t=%.2f\n", res2b$n, abs(res2b$intimacy$t), abs(res2b$friendship$t)))

# --- Study 2c ---
cat("\n>>> 运行 Study 2c：关注剂�?(�?20%/�?50%/�?80%) (N=36)\n")
res2c <- run_study2c(EXCEL_FILE)
cat(sprintf("  N=%d, 亲密感F=%.2f, 友谊F=%.2f\n", res2c$n, res2c$intimacy_anova$F, res2c$friendship_anova$F))

# ===========================================================================
# 生成复现报告
# ===========================================================================

cat("\n>>> 生成SPSS三线表Markdown报告...\n")
report_lines <- build_report(res1a, res1b, res2a, res2b, res2c)

# 输出�? Rana.final 根目�?
output_path <- "reproduction_report.md"
writeLines(report_lines, output_path)

# 统计复现�?
n_repro <- sum(grepl("REPRODUCED", report_lines))
n_total <- sum(grepl("校验", report_lines)) - 6  # 减去表头�?
cat(sprintf("\n  报告已写入：%s\n", output_path))
cat(sprintf("  复现统计�?%d/%d 项统计量成功复现\n", n_repro, n_total))

cat("\n==========================================================\n")
cat("  分析完成！\n")
cat("==========================================================\n")
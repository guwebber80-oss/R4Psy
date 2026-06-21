# ===========================================================================
# data_loader.R — 数据处理与加载模块
# 功能：从Excel文件中加载5个子研究的原始数据，进行清洗、变量聚合与因子编码
# 依赖：readxl（Excel读取）、psych（Cronbach信度）
# ===========================================================================

suppressPackageStartupMessages({
  library(readxl)
  library(psych)
})

# ---------------------------------------------------------------------------
# 通用工作表加载函数
# 处理Excel中多层表头（如Study 1a的场景分组行+变量名行）
# 统一处理"NA"字符串→真实NA、"ao"→"a0"等数据录入问题
# ---------------------------------------------------------------------------

#' 从Excel中加载单个工作表
#' @param filepath  Excel文件路径
#' @param sheet_name 工作表名称
#' @param header_rows 表头行数（1或2）
#' @return 清洗后的data.frame
load_sheet <- function(filepath, sheet_name, header_rows) {
  # 以文本模式读取，避免场景分组头（如"Advice"）导致列类型误判
  raw <- read_excel(filepath, sheet = sheet_name, col_names = FALSE,
                    col_types = "text")
  if (header_rows == 2) {
    # Study 1a/1b：第1行为场景分组头，第2行为变量名
    col_names <- as.character(unlist(raw[2, ]))
    data <- raw[-(1:2), ]
  } else {
    # Study 2a/2b/2c：第1行为变量名
    col_names <- as.character(unlist(raw[1, ]))
    data <- raw[-1, ]
  }
  names(data) <- col_names
  data <- as.data.frame(data, stringsAsFactors = FALSE)

  # 将Excel中的文本"NA"转换为R的缺失值NA
  data[] <- lapply(data, function(col) {
    col[!is.na(col) & col == "NA"] <- NA_character_
    col
  })

  # 修复Study 1a中的录入错误："ao"（字母O）→"a0"（数字0）
  if ("attention" %in% names(data)) {
    data$attention[!is.na(data$attention) & data$attention == "ao"] <- "a0"
  }

  # 将纯数字列从字符转换为数值型
  data[] <- lapply(data, function(x) {
    xn <- suppressWarnings(as.numeric(x))
    # 如果转换前后NA数量一致，说明该列全为数值，可以安全转换
    if (sum(is.na(xn)) == sum(is.na(x))) {
      return(xn)
    }
    return(as.character(x))
  })
  return(data)
}

# ===========================================================================
# Study 1a：关注×获益×时间×场景顺序（2×2×2×3）被试间设计
# 因变量：亲密感、对伴侣帮助的期望、帮助伴侣的意愿
# ===========================================================================

#' 加载并处理Study 1a数据
#' @param filepath Excel文件路径
#' @return 包含data、样本量n、Cronbach's α的列表
load_study1a <- function(filepath) {
  d <- load_sheet(filepath, "Study 1a", header_rows = 2)
  # 原始312名参与者，3名因缺失值被排除，Excel中已为309行
  n <- nrow(d)

  # 亲密感：3个场景 × 3个条目（理解、认可、关心）= 9个条目
  intimacy_items <- d[, c("intimacy11","intimacy12","intimacy13",
                          "intimacy21","intimacy22","intimacy23",
                          "intimacy31","intimacy32","intimacy33")]
  # 跨场景聚合亲密感（均值，na.rm处理偶尔的缺失响应）
  d$intimacy          <- rowMeans(intimacy_items, na.rm = TRUE)
  # 分场景亲密感（用于分场景方差分析）
  d$intimacy_advice   <- rowMeans(d[, c("intimacy11","intimacy12","intimacy13")], na.rm = TRUE)
  d$intimacy_surprise <- rowMeans(d[, c("intimacy21","intimacy22","intimacy23")], na.rm = TRUE)
  d$intimacy_moral    <- rowMeans(d[, c("intimacy31","intimacy32","intimacy33")], na.rm = TRUE)

  # 社会交换变量：跨场景均值
  d$exp_help  <- rowMeans(d[, c("Exp.Help1","Exp.Help2","Exp.Help3")], na.rm = TRUE)
  d$will_help <- rowMeans(d[, c("Will.Help1","Will.Help2","Will.Help3")], na.rm = TRUE)

  # 9条目亲密感的Cronbach's α（原始：0.76）
  alpha_val <- psych::alpha(intimacy_items)$total$raw_alpha

  # 因子编码：自变量
  d$attention <- factor(d$attention, levels = c("a0","a1"), labels = c("No","Yes"))
  d$benefit   <- factor(d$benefit,   levels = c("b0","b1"), labels = c("No","Yes"))
  d$time      <- factor(d$time,      levels = c("t0","t1"), labels = c("Short","Long"))
  d$Order     <- factor(d$Order)  # 场景呈现顺序（1/2/3）

  list(data = d, n = n, alpha = alpha_val)
}

# ===========================================================================
# Study 1b：关注×获益×性别×场景顺序（2×2×2×3），用性别替换时间因素
# ===========================================================================

load_study1b <- function(filepath) {
  d <- load_sheet(filepath, "Study 1b", header_rows = 2)
  n <- nrow(d)  # 105名无重叠参与者，无排除

  intimacy_items <- d[, c("intimacy11","intimacy12","intimacy13",
                          "intimacy21","intimacy22","intimacy23",
                          "intimacy31","intimacy32","intimacy33")]
  d$intimacy          <- rowMeans(intimacy_items, na.rm = TRUE)
  d$intimacy_advice   <- rowMeans(d[, c("intimacy11","intimacy12","intimacy13")], na.rm = TRUE)
  d$intimacy_surprise <- rowMeans(d[, c("intimacy21","intimacy22","intimacy23")], na.rm = TRUE)
  d$intimacy_moral    <- rowMeans(d[, c("intimacy31","intimacy32","intimacy33")], na.rm = TRUE)
  d$exp_help  <- rowMeans(d[, c("Exp.Help1","Exp.Help2","Exp.Help3")], na.rm = TRUE)
  d$will_help <- rowMeans(d[, c("Will.Help1","Will.Help2","Will.Help3")], na.rm = TRUE)

  alpha_val <- psych::alpha(intimacy_items)$total$raw_alpha  # 原始：0.82

  # Study 1b用性别替换Study 1a中的时间因素
  d$attention <- factor(d$attention, levels = c("a0","a1"), labels = c("No","Yes"))
  d$benefit   <- factor(d$benefit,   levels = c("b0","b1"), labels = c("No","Yes"))
  d$sex       <- factor(d$sex,       levels = c("f","m"),   labels = c("Female","Male"))
  d$Order     <- factor(d$Order)

  list(data = d, n = n, alpha = alpha_val)
}

# ===========================================================================
# Study 2a：单因素被试间设计，关注（80%监控 vs 0%监控）
# 因变量：亲密感、友谊兴趣
# ===========================================================================

load_study2a <- function(filepath) {
  d <- load_sheet(filepath, "Study 2a", header_rows = 1)
  n <- nrow(d)  # 30名参与者，排除1名怀疑欺骗者 → N=29

  # 亲密感：4条目（care关心, care2反向关心, accept认可, understand理解）
  d$intimacy   <- rowMeans(d[, c("care","care2","accept","understand")], na.rm = TRUE)
  # 友谊兴趣：2条目
  d$friendship <- rowMeans(d[, c("friend1","friend2")], na.rm = TRUE)
  d$attention  <- factor(d$attention, levels = c("a0","a1"), labels = c("No","Yes"))

  list(data = d, n = n)
}

# ===========================================================================
# Study 2b：单因素，有意关注（80%）vs 无意图（系统随机显示监控信号）
# ===========================================================================

load_study2b <- function(filepath) {
  d <- load_sheet(filepath, "Study 2b", header_rows = 1)
  n <- nrow(d)  # 45→44

  d$intimacy   <- rowMeans(d[, c("care","care2","accept","understand")], na.rm = TRUE)
  d$friendship <- rowMeans(d[, c("friend1","friend2")], na.rm = TRUE)
  d$attention  <- factor(d$attention, levels = c("a0","a1"),
                         labels = c("NoIntent","Intentional"))

  list(data = d, n = n)
}

# ===========================================================================
# Study 2c：单因素三水平，关注量（低20% / 中50% / 高80%）
# 额外变量：实际关注频率、估计关注频率
# ===========================================================================

load_study2c <- function(filepath) {
  d <- load_sheet(filepath, "Study 2c", header_rows = 1)
  n <- nrow(d)  # 38→36

  d$intimacy   <- rowMeans(d[, c("care","care2","accept","understand")], na.rm = TRUE)
  d$friendship <- rowMeans(d[, c("friend1","friend2")], na.rm = TRUE)
  d$attention  <- factor(d$attention, levels = c("low","mid","high"),
                         labels = c("Low(20%)","Medium(50%)","High(80%)"))

  list(data = d, n = n)
}
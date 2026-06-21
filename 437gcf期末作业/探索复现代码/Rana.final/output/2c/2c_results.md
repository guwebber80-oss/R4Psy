## Study 2c - Results

Total N=36 (Low=12, Mid=12, High=12), Outliers excluded=0

### Reliability

| Scale | Items | Alpha |
| --- | --- | --- |
| Intimacy (4 items) | care,care2_r,accept,understand | 0.359 |
| Friendship (2 items) | friend1,friend2 | 0.450 |

### Descriptive Statistics

| attention | N | Intimacy_M | Intimacy_SD | Friendship_M | Friendship_SD | Est_att_M | Est_att_SD | Act_att_M | Act_att_SD |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Low(20%) | 12.000 | 3.438 | 0.724 | 3.708 | 1.177 | 4.833 | 3.298 | 3.583 | 1.084 |
| Mid(50%) | 12.000 | 3.750 | 0.959 | 3.375 | 0.956 | 10.000 | 4.513 | 9.000 | 1.907 |
| High(80%) | 12.000 | 3.771 | 0.719 | 4.250 | 0.917 | 16.333 | 3.701 | 16.917 | 1.929 |

### Main Analysis: Intimacy by Attention

| Analysis | Statistic | p | EffectSize |
| --- | --- | --- | --- |
| Welch ANOVA | F(2.00,21.69)=0.72 | 0.4959 | f=0.201 |
| Bayesian ANOVA | BF10=0.29 | NA | Moderate H0 |

### Robustness Check

| Condition | Welch_F | Welch_p | BF10 | N |
| --- | --- | --- | --- | --- |
| Full | 0.72 | 0.4959 | 0.29 | 36.000 |
| No-outlier | 0.72 | 0.4959 | 0.29 | 36.000 |
| Robust BF | NA | NA | 0.29 | 36.000 |

### Dose-Response

| Method | Coefficient | SE | p | R2 |
| --- | --- | --- | --- | --- |
| Robust Regression | b=0.6035 | 0.5084 | 0.2434 | 0.0194 |
| Spearman Correlation | rho=0.2184 | NA | 0.2006 | NA |

### Manipulation Check

| Analysis | Variables | BF10 | EffectSize | CI95 |
| --- | --- | --- | --- | --- |
| Bayesian Correlation | Est~Actual | 25529721.575 | rho=0.846 | [0.716,0.919] |
| Bayesian Paired t | Est vs Actual | 0.286 | d=0.168 | [-0.564,1.675] |
| Bayesian ANOVA | Est~attention | 89275.579 | See posterior | - |


## Study 1b - Results

### Sample

- Valid subjects: 104
- Long-format obs: 312
- Note: No time variable

### Cronbach Alpha (Intimacy)

| Scenario | Items | Alpha | CI_lower | CI_upper |
| --- | --- | --- | --- | --- |
| Advice | 3 | 0.685 | 0.585 | 0.785 |
| Surprise | 3 | 0.776 | 0.702 | 0.849 |
| Moral_Support | 3 | 0.800 | 0.739 | 0.860 |

### Mixed Model: intimacy

Formula: intimacy~attention*benefit*scenario+Order+(1|ID)

| Term | NumDF | DenDF | F | p |
| --- | --- | --- | --- | --- |
| attention | 1.000 | 104.000 | 52.323 | 0.000 |
| benefit | 1.000 | 104.000 | 7.195 | 0.009 |
| scenario | 2.000 | 208.000 | 2.429 | 0.091 |
| Order | 2.000 | 104.000 | 0.739 | 0.480 |
| attention:benefit | 1.000 | 104.000 | 0.099 | 0.754 |
| attention:scenario | 2.000 | 208.000 | 1.688 | 0.187 |
| benefit:scenario | 2.000 | 208.000 | 0.152 | 0.859 |
| attention:benefit:scenario | 2.000 | 208.000 | 0.015 | 0.985 |

### Mixed Model: exp_help

| Term | NumDF | DenDF | F | p |
| --- | --- | --- | --- | --- |
| attention | 1.000 | 104.000 | 9.531 | 0.003 |
| benefit | 1.000 | 104.000 | 0.002 | 0.962 |
| scenario | 2.000 | 208.000 | 0.110 | 0.895 |
| Order | 2.000 | 104.000 | 1.496 | 0.229 |
| attention:benefit | 1.000 | 104.000 | 0.067 | 0.797 |
| attention:scenario | 2.000 | 208.000 | 1.418 | 0.244 |
| benefit:scenario | 2.000 | 208.000 | 0.034 | 0.967 |
| attention:benefit:scenario | 2.000 | 208.000 | 0.131 | 0.877 |

### Mixed Model: will_help

| Term | NumDF | DenDF | F | p |
| --- | --- | --- | --- | --- |
| attention | 1.000 | 104.000 | 8.770 | 0.004 |
| benefit | 1.000 | 104.000 | 0.030 | 0.864 |
| scenario | 2.000 | 208.000 | 3.412 | 0.035 |
| Order | 2.000 | 104.000 | 0.054 | 0.947 |
| attention:benefit | 1.000 | 104.000 | 0.077 | 0.782 |
| attention:scenario | 2.000 | 208.000 | 1.814 | 0.166 |
| benefit:scenario | 2.000 | 208.000 | 0.163 | 0.849 |
| attention:benefit:scenario | 2.000 | 208.000 | 0.058 | 0.943 |

### Standardized Coefficients (Std. Beta)

| DV | Parameter | Std_Beta | CI_low | CI_high |
| --- | --- | --- | --- | --- |
| intimacy | attentiona1 | 0.853 | 0.367 | 1.338 |
| intimacy | benefitb1 | 0.288 | -0.193 | 0.769 |
| intimacy | scenarioSurprise | -0.021 | -0.463 | 0.421 |
| intimacy | scenarioMoral_Support | -0.315 | -0.757 | 0.126 |
| intimacy | Orderb | -0.045 | -0.326 | 0.235 |
| intimacy | Orderc | 0.124 | -0.159 | 0.407 |
| intimacy | attentiona1:benefitb1 | 0.076 | -0.604 | 0.756 |
| intimacy | attentiona1:scenarioSurprise | -0.282 | -0.901 | 0.336 |
| intimacy | attentiona1:scenarioMoral_Support | 0.154 | -0.465 | 0.772 |
| intimacy | benefitb1:scenarioSurprise | -0.096 | -0.709 | 0.517 |
| intimacy | benefitb1:scenarioMoral_Support | 0.062 | -0.551 | 0.675 |
| intimacy | attentiona1:benefitb1:scenarioSurprise | 0.035 | -0.831 | 0.902 |
| intimacy | attentiona1:benefitb1:scenarioMoral_Support | -0.042 | -0.909 | 0.825 |
| exp_help | attentiona1 | 0.538 | 0.006 | 1.070 |
| exp_help | benefitb1 | -0.118 | -0.645 | 0.409 |
| exp_help | scenarioSurprise | 0.133 | -0.314 | 0.579 |
| exp_help | scenarioMoral_Support | 0.133 | -0.314 | 0.579 |
| exp_help | Orderb | -0.263 | -0.596 | 0.070 |
| exp_help | Orderc | -0.020 | -0.355 | 0.316 |
| exp_help | attentiona1:benefitb1 | 0.203 | -0.541 | 0.948 |
| exp_help | attentiona1:scenarioSurprise | -0.260 | -0.886 | 0.365 |
| exp_help | attentiona1:scenarioMoral_Support | -0.175 | -0.801 | 0.450 |
| exp_help | benefitb1:scenarioSurprise | 0.154 | -0.466 | 0.774 |
| exp_help | benefitb1:scenarioMoral_Support | 0.113 | -0.507 | 0.733 |
| exp_help | attentiona1:benefitb1:scenarioSurprise | -0.196 | -1.073 | 0.680 |
| exp_help | attentiona1:benefitb1:scenarioMoral_Support | -0.198 | -1.074 | 0.678 |
| will_help | attentiona1 | 0.674 | 0.143 | 1.206 |
| will_help | benefitb1 | 0.064 | -0.463 | 0.590 |
| will_help | scenarioSurprise | -0.049 | -0.449 | 0.350 |
| will_help | scenarioMoral_Support | -0.099 | -0.499 | 0.301 |
| will_help | Orderb | -0.059 | -0.418 | 0.301 |
| will_help | Orderc | -0.040 | -0.403 | 0.322 |
| will_help | attentiona1:benefitb1 | -0.064 | -0.808 | 0.680 |
| will_help | attentiona1:scenarioSurprise | -0.331 | -0.891 | 0.229 |
| will_help | attentiona1:scenarioMoral_Support | -0.234 | -0.794 | 0.326 |
| will_help | benefitb1:scenarioSurprise | 0.095 | -0.460 | 0.650 |
| will_help | benefitb1:scenarioMoral_Support | -0.084 | -0.639 | 0.471 |
| will_help | attentiona1:benefitb1:scenarioSurprise | -0.095 | -0.880 | 0.689 |
| will_help | attentiona1:benefitb1:scenarioMoral_Support | 0.037 | -0.748 | 0.821 |


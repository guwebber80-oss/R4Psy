## Study 1a - Results

### Sample

- Valid subjects: 295
- Long-format obs: 885

### Cronbach Alpha (Intimacy)

| Scenario | Items | Alpha | CI_lower | CI_upper |
| --- | --- | --- | --- | --- |
| Advice | 3 | 0.748 | 0.698 | 0.797 |
| Surprise | 3 | 0.687 | 0.626 | 0.748 |
| Moral_Support | 3 | 0.719 | 0.664 | 0.775 |
| Overall | 9 | 0.752 | NA | NA |

### Mixed Model: intimacy

Formula: intimacy ~ attention * benefit * scenario + time + Order + (1|ID)

| Term | NumDF | DenDF | F | p |
| --- | --- | --- | --- | --- |
| attention | 1.000 | 301.324 | 37.975 | 0.000 |
| benefit | 1.000 | 292.958 | 5.108 | 0.025 |
| scenario | 2.000 | 590.137 | 0.613 | 0.542 |
| time | 1.000 | 292.918 | 0.996 | 0.319 |
| Order | 2.000 | 299.321 | 4.194 | 0.016 |
| attention:benefit | 1.000 | 300.844 | 0.125 | 0.724 |
| attention:scenario | 2.000 | 590.137 | 2.469 | 0.086 |
| benefit:scenario | 2.000 | 590.137 | 0.068 | 0.934 |
| attention:benefit:scenario | 2.000 | 590.137 | 0.315 | 0.730 |

### Mixed Model: exp_help

| Term | NumDF | DenDF | F | p |
| --- | --- | --- | --- | --- |
| attention | 1.000 | 300.499 | 13.424 | 0.000 |
| benefit | 1.000 | 292.745 | 0.320 | 0.572 |
| scenario | 2.000 | 590.011 | 0.410 | 0.664 |
| time | 1.000 | 292.695 | 1.686 | 0.195 |
| Order | 2.000 | 298.636 | 0.459 | 0.632 |
| attention:benefit | 1.000 | 300.075 | 0.040 | 0.842 |
| attention:scenario | 2.000 | 590.011 | 2.276 | 0.104 |
| benefit:scenario | 2.000 | 590.011 | 0.120 | 0.887 |
| attention:benefit:scenario | 2.000 | 590.011 | 0.197 | 0.822 |

### Mixed Model: will_help

| Term | NumDF | DenDF | F | p |
| --- | --- | --- | --- | --- |
| attention | 1.000 | 302.353 | 11.374 | 0.001 |
| benefit | 1.000 | 293.313 | 8.799 | 0.003 |
| scenario | 2.000 | 590.441 | 0.072 | 0.930 |
| time | 1.000 | 293.280 | 0.003 | 0.959 |
| Order | 2.000 | 300.194 | 0.329 | 0.720 |
| attention:benefit | 1.000 | 301.818 | 0.038 | 0.846 |
| attention:scenario | 2.000 | 590.441 | 0.309 | 0.734 |
| benefit:scenario | 2.000 | 590.441 | 0.311 | 0.733 |
| attention:benefit:scenario | 2.000 | 590.441 | 0.621 | 0.538 |

### Model Fit

| DV | AIC | BIC | R2m | R2c |
| --- | --- | --- | --- | --- |
| intimacy | 1477.071 | 1558.426 | 0.084 | 0.293 |
| exp_help | 2223.912 | 2305.267 | 0.030 | 0.206 |
| will_help | 1937.462 | 2018.817 | 0.038 | 0.298 |

### Standardized Coefficients (Std. Beta)

| DV | Parameter | Std_Beta | CI_low | CI_high |
| --- | --- | --- | --- | --- |
| intimacy | attentionao | -0.489 | -0.803 | -0.176 |
| intimacy | benefitb1 | 0.169 | -0.141 | 0.479 |
| intimacy | scenarioSurprise | -0.072 | -0.349 | 0.205 |
| intimacy | scenarioMoral_Support | 0.096 | -0.181 | 0.373 |
| intimacy | timet1 | 0.078 | -0.075 | 0.230 |
| intimacy | Order2 | 0.127 | -0.057 | 0.311 |
| intimacy | Order3 | 0.281 | 0.090 | 0.472 |
| intimacy | attentionao:benefitb1 | 0.009 | -0.429 | 0.446 |
| intimacy | attentionao:scenarioSurprise | 0.260 | -0.129 | 0.649 |
| intimacy | attentionao:scenarioMoral_Support | -0.143 | -0.532 | 0.246 |
| intimacy | benefitb1:scenarioSurprise | 0.125 | -0.260 | 0.510 |
| intimacy | benefitb1:scenarioMoral_Support | -0.021 | -0.406 | 0.364 |
| intimacy | attentionao:benefitb1:scenarioSurprise | -0.190 | -0.734 | 0.353 |
| intimacy | attentionao:benefitb1:scenarioMoral_Support | -0.000 | -0.544 | 0.543 |
| exp_help | attentionao | -0.332 | -0.654 | -0.010 |
| exp_help | benefitb1 | 0.088 | -0.231 | 0.407 |
| exp_help | scenarioSurprise | -0.082 | -0.375 | 0.212 |
| exp_help | scenarioMoral_Support | -0.016 | -0.310 | 0.277 |
| exp_help | timet1 | -0.100 | -0.252 | 0.051 |
| exp_help | Order2 | 0.087 | -0.095 | 0.270 |
| exp_help | Order3 | 0.062 | -0.127 | 0.252 |
| exp_help | attentionao:benefitb1 | -0.105 | -0.555 | 0.345 |
| exp_help | attentionao:scenarioSurprise | 0.193 | -0.219 | 0.606 |
| exp_help | attentionao:scenarioMoral_Support | 0.000 | -0.412 | 0.413 |
| exp_help | benefitb1:scenarioSurprise | -0.041 | -0.449 | 0.368 |
| exp_help | benefitb1:scenarioMoral_Support | -0.045 | -0.453 | 0.363 |
| exp_help | attentionao:benefitb1:scenarioSurprise | 0.177 | -0.399 | 0.753 |
| exp_help | attentionao:benefitb1:scenarioMoral_Support | 0.045 | -0.531 | 0.621 |
| will_help | attentionao | -0.179 | -0.500 | 0.142 |
| will_help | benefitb1 | 0.326 | 0.009 | 0.644 |
| will_help | scenarioSurprise | 0.038 | -0.238 | 0.314 |
| will_help | scenarioMoral_Support | 0.075 | -0.201 | 0.351 |
| will_help | timet1 | -0.004 | -0.165 | 0.157 |
| will_help | Order2 | 0.044 | -0.149 | 0.237 |
| will_help | Order3 | -0.037 | -0.238 | 0.164 |
| will_help | attentionao:benefitb1 | -0.177 | -0.625 | 0.271 |
| will_help | attentionao:scenarioSurprise | -0.111 | -0.499 | 0.277 |
| will_help | attentionao:scenarioMoral_Support | -0.130 | -0.518 | 0.257 |
| will_help | benefitb1:scenarioSurprise | -0.090 | -0.474 | 0.293 |
| will_help | benefitb1:scenarioMoral_Support | -0.111 | -0.494 | 0.273 |
| will_help | attentionao:benefitb1:scenarioSurprise | 0.306 | -0.235 | 0.848 |
| will_help | attentionao:benefitb1:scenarioMoral_Support | 0.130 | -0.412 | 0.672 |

### Diagnostics

- Shapiro-Wilk (intimacy residuals): W=0.986, p=0.0000
- Levene test: F(11,873)=0.829, p=0.6106

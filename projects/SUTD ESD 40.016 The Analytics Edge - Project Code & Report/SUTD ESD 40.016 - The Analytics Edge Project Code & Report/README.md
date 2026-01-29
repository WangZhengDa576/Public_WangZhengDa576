# TAE Project: Predictive Modelling for Vehicle Safety Choice Task

## Contents

### 1. `01 Multinomial_Submission_Insight Edge.Rmd`
- **Model**: Multinomial Logit using `mlogit`
- **Objective**: Establish a baseline model by reshaping and fitting the choice data to a multinomial logistic regression.
- **Key Steps**:
  - Preprocess and reshape data from wide to long format
  - Engineer a `choice` column for model fitting
  - Fit the model using individual and alternative-specific variables
  - Predict probabilities and calculate log loss
  - Export prediction results to CSV

---

### 2. `02 Catboost_Submission_Insight Edge.Rmd`
- **Model**: CatBoost Multiclass Classifier
- **Objective**: Leverage CatBoost's handling of categorical variables and feature importance for classification.
- **Key Steps**:
  - Convert one-hot encoded labels into integer targets
  - Perform train-validation split and create `catboost.Pool` objects
  - Run cross-validation with early stopping to find optimal iterations
  - Compute validation log loss
  - Apply feature importance-based filtering
  - Retrain final model with selected features
  - Predict and generate a submission file

---

### 3. `03 XGBoost_Submission_Insight Edge.Rmd`
- **Model**: XGBoost Multiclass Classifier
- **Objective**: Use XGBoost for robust, high-performance modeling on the same task.
- **Key Steps**:
  - Reformat one-hot targets into single-label integers
  - Create `DMatrix` objects for efficient training
  - Perform cross-validation with early stopping
  - Train the model using optimal number of rounds
  - Evaluate log loss on validation
  - Retrain using the full dataset
  - Generate a submission file with predicted probabilities

---

### 4. `04 Model Combination_Submission_Insight Edge.Rmd`
- Combines the CatBoost, XgBoost, Multinomial Model using 0.7,0.2,0.1 weighted ratios

---

### 5. `train2024.csv`
- Required to run all three models

---

### 6. `test2024.csv`
- Required to run all three models

---

### 7. `sample_submission2024.csv`
- Required to run Catboost model

---

### 8. `Multilogit_Model_Insight_Edge_Probabilities.csv`
- Output of Multilogit model

---

### 9. `CatBoost_Model_Insight_Edge_Probabilities.csv`
- Output of CatBoost model

---

### 10. `XGBoost_Model_Insight_Edge_Probabilities.csv`
- Output of XGBoost model

---

### 11. `Final_Insight_Edge_Probabilities.csv`
- Output of final probaibilities

---

## Evaluation Metric

All models are evaluated using **Log Loss** on a multiclass prediction task. Probabilities are clipped to prevent `log(0)` errors, and only the probability of the chosen class is considered per instance.

---

## Outputs

Each model exports a `.csv` submission file with soft probabilities for each of the 4 choices (`Ch1`to `Ch4`), compatible with external evaluation systems.

---




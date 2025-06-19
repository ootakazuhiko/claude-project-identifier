# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Identification

When working with this project, Claude Code should always display the following information at startup and when waiting for user input:

```
[WAITING] ユーザー入力待機中... / Waiting for user input...
================================================
 Project: ML Data Analyzer
 Type: Python Data Science Tool
 Environment: Development
 Current Directory: [current path]
 Time: [current time]
================================================
```

## Project Overview

ML Data Analyzer is a comprehensive machine learning toolkit for data analysis, featuring automated EDA, model training, and visualization capabilities.

## Project Structure

```
ml-data-analyzer/
├── src/                    # Source code
│   ├── models/            # ML model implementations
│   ├── preprocessing/     # Data preprocessing modules
│   ├── visualization/     # Plotting and visualization
│   ├── utils/            # Utility functions
│   └── api/              # FastAPI endpoints
├── notebooks/             # Jupyter notebooks
├── tests/                 # Test files
├── data/                  # Data files (git-ignored)
└── configs/               # Configuration files
```

## Development Commands

### Quick Start
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
pip install -r requirements-dev.txt

# Run FastAPI server
uvicorn src.api.main:app --reload

# Run Jupyter notebook
jupyter notebook

# Run tests
pytest
```

## Key Features

- Automated Exploratory Data Analysis (EDA)
- Multiple ML algorithms (Random Forest, XGBoost, Neural Networks)
- Real-time data visualization
- RESTful API with FastAPI
- Jupyter notebook integration
- Comprehensive data preprocessing pipeline
- Model evaluation and comparison
- Export to multiple formats

## Python Environment

```
Python: 3.11+
Virtual Environment: venv
Package Manager: pip
```

## Important Libraries

- pandas - Data manipulation
- numpy - Numerical computing
- scikit-learn - Machine learning
- tensorflow/pytorch - Deep learning
- matplotlib/seaborn - Visualization
- FastAPI - Web framework
- pytest - Testing

## Git Workflow

All commits should follow the pattern:
```bash
git commit -m "[AI: Claude Code] feat: Add automated feature engineering"
```

## Testing

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src

# Run specific test file
pytest tests/test_models.py

# Run in verbose mode
pytest -v
```

## Code Style

- Follow PEP 8
- Use type hints
- Maximum line length: 88 (Black formatter)
- Docstrings for all functions and classes

---

Remember: Always display the project identification banner when starting work on this project, and show the waiting indicator when idle.
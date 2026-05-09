# Spam Shield: AI-Powered On-Device Spam Detection

**Spam Shield** is a privacy-focused mobile application developed using **Flutter** that detects spam in SMS and emails in real-time. Unlike traditional filters that rely on cloud-based processing, Spam Shield utilizes a lightweight, embedded **Machine Learning (SVM)** model to classify messages directly on the device, ensuring 100% user privacy and offline functionality.

---

## 🚀 Key Features

* **On-Device AI**: Performs classification locally on the mobile CPU with near-zero latency.
* **Privacy First**: No internet required for prediction; user data never leaves the device.
* **Lightweight Model**: Optimized mathematical inference using exported weights and bias for high speed without heavy ML libraries.
* **Cross-Platform**: Built with **Flutter** for a seamless experience on both Android and iOS.
* **Intelligent Analysis**: Employs **TF-IDF vectorization** to identify high-signal spam patterns.

---

## 🛠️ Tech Stack & Syllabus Alignment

### **Mobile Application**
* **Framework**: Flutter & Dart.
* **UI/UX**: Custom Material 3 design with Dark/Light mode support.
* **Method**: On-device dot product calculation using pre-trained model parameters ($Score = W \cdot X + b$).

### **Machine Learning Pipeline (Syllabus Integration)**
* **Dataset**: **UCI SMS Spam Collection** (5,572 labeled messages).
* **Data Pre-processing**: Handled noisy datasets using **Regex cleaning**, **NLTK stopword removal**, and **Lowercasing**.
* **Feature Extraction**: **TF-IDF Vectorizer** (1,000 features) to transform text into numerical importance scores.
* **Algorithm**: **Linear Support Vector Machine (SVM)** selected for optimal binary classification.
* **Metrics**: Performance evaluated using a **Confusion Matrix**, Precision, Recall, and F1-Score.

---

## 🧠 How It Works

1. **Training**: The model is trained in Python (Scikit-Learn) on the labeled **UCI dataset**.
2. **Extraction**: The optimal **Weights ($W$)** and **Bias ($b$)** are extracted from the trained Linear SVM.
3. **Deployment**: These parameters are stored in a **JSON** format inside the app's assets.
4. **Inference**: When a user inputs text, the app performs a simple mathematical calculation instantly to classify the message.

---

## 📂 Project Structure

```text
Spam-Shield-ML/
├── assets/
│   ├── logo.png               # App Logo
│   ├── svm_weights.json       # Exported SVM parameters (W & b)
│   └── tfidf_vocab.json       # TF-IDF vocabulary mapping
├── lib/
│   ├── screens/               # Analysis, History, and Settings UI
│   ├── theme/                 # App styling and Dark Mode logic
│   └── main.dart              # Application entry point
└── ML_Model_Training/
    └── training_notebook.ipynb # Python code for Pre-processing & SVM training

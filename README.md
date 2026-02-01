# OilCalcApp 🛢️

**Professional Calculator for Oil & Petroleum Products**

OilCalcApp is a specialized iOS application designed for the precise calculation of oil product quantities. It adheres to **API MPMS Chapter 11.1** standards, ensuring high accuracy for both refined products and crude oil.

## ✨ Key Features

### 📐 Advanced Fuel Calculator

- **Dual Conversion Modes:**
  - **Mass → Volume:** Input Mass (kg) to get Volume (Liters) at 15°C and actual temperature.
  - **Volume → Mass:** Input Volume to get precise Mass.
- **Standards Compliant:** Uses **API MPMS Table 54B** (Refined Products) and **Table 54A** (Crude Oil) for density corrections.
- **Accurate Physics:** Automatically calculates Density at 15°C and Density at actual Temperature ($T^\circ C$).

### 📉 Trip Loss Analysis

- **Loss Control:** Essential tool for marine and transport operations.
- **Compare Two Points:** Input data for **Point A (Loading)** and **Point B (Discharge)**.
- **Detailed Report:** Instantly see differences in Mass and Volume (both at 15°C and actual specific temperatures).
- **Visual Indicators:** Green/Red highlighting for gains and losses.

### 🛠️ Additional Functionality

- **History:** Automatically saves your calculations for future reference.
- **Settings:** Customization options.
- **Design:** Modern, clean SwiftUI interface with support for Dark Mode.

## 📱 Screenshots

| Main Calculator | Trip Loss Analysis | Results |
|:---:|:---:|:---:|
| <!-- Add screenshot here --> | <!-- Add screenshot here --> | <!-- Add screenshot here --> |

## ⚙️ Technology Stack

- **Language:** Swift 5.0+
- **Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **Concurrency:** Combine / Async/Await
- **Minimum Requirements:** iOS 17.0

## 🚀 Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/AslanAdamoff/OilCalcApp.git
   ```

2. **Open in Xcode:**
   Navigate to the folder and open `OilCalcApp.xcodeproj`.
3. **Run:**
   Select your simulator or device and hit **Run (Cmd+R)**.

## 📝 License

This project is created by **Aslan Adamov**. All rights reserved.

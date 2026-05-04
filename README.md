# 🏗️ CV Studio Pro — Comprehensive Architecture & Documentation

Welcome to the definitive internal technical documentation for **CV Studio Pro**. This document serves as the "source of truth" for the application's overall structure, data flow, external API integrations, state management architecture, and PDF generation logic.

---

## 🧭 Executive Summary

**CV Studio Pro** is an intelligent, high-performance Flutter application designed to guide users through creating professional resumes. It completely decouples the **data layer** (what the user types) from the **presentation layer** (how the CV looks as a PDF). 

This allows users to fill out their data once via an intuitive wizard and seamlessly switch between numerous highly-styled, ATS-friendly PDF templates with a single tap.

---

## 🛠️ Technology Stack & Tooling

* **Framework Layer**: Flutter (`SDK 3.4.0+`)
* **Core Language**: Dart
* **State Management**: Riverpod (` flutter_riverpod ^2.5.1`)
* **Routing Strategy**: Declarative Navigation via GoRouter (`go_router`)
* **Backend as a Service (BaaS)**: Supabase (`supabase_flutter`)
* **PDF Rendering Engine**: Dart PDF & Printing (`pdf ^3.12.0`, `printing ^5.14.3`)
* **External APIs**: OpenWeatherMap (Location/Climate context), ZenQuotes (Daily Motivation)

---

## 📂 Complete Project Structure 

All primary application logic resides inside the `/lib` directory, strictly adhering to a **Feature-Driven Architecture**.

### 1. The Entry Point
* **`lib/main.dart`**: The application bootstrapper. It calls `WidgetsFlutterBinding.ensureInitialized()`, initializes the `Supabase` client using secure keys, wraps the global application tree in a `ProviderScope` (for Riverpod), and triggers `GoRouter`.

### 2. `/lib/core/` — Foundation & Global Configurations
This directory contains elements that are shared completely across all features.
* **`constants/api_keys.dart`**: Houses `SupabaseConfig` (URL & Anon Key) and OpenWeatherMap credentials.
* **`constants/app_colors.dart`**: The brand design system. Contains static colors like *Emerald*, *Graphite*, *Surface*, and structural shades.
* **`theme/app_theme.dart`**: Modifies the global Material `ThemeData`. It sets default element styles (like `ElevatedButtonThemeData`, `InputDecorationTheme`, and typography using Google Fonts — primarily `Outfit` and `Inter`).
* **`router/app_router.dart`**: Defines the `GoRouter` configuration. Maps paths like `/dashboard`, `/editor`, and `/preview` to their respective screens and injects routing logic based on user authentication state.

### 3. `/lib/features/` — Domain Modules
Every distinct "screen workflow" is containerized here.

#### 🔐 Auth Module (`/lib/features/auth/`)
* **`splash_screen.dart`**: The loading sequence. Checks for an active Supabase session (JWT) and redirects to `/dashboard` or `/login`.
* **`login_screen.dart` & `signup_screen.dart`**: UI screens for email/password authentication using premium glassmorphic widgets.
* **`auth_service.dart`**: Contains `signIn`, `signUp`, and `signOut` wrappers around `Supabase.instance.client.auth`.

#### 🏠 Dashboard Module (`/lib/features/dashboard/`)
* **`dashboard_screen.dart`**: The authenticated landing hub. 
    * Displays active resumes fetched via Supabase streams.
    * Incorporates a dynamic animated Hero section powered by external APIs. It leverages a Riverpod `FutureProvider` to asynchronously retrieve the user's weather.

#### 📝 Editor Module (`/lib/features/editor/`)
The heaviest data-entry portion of the app.
* **`cv_model.dart`**: The fundamental definition of a Resume. Maps heavily to JSON. Contains structures for `Experience`, `Education`, `Project`, etc. Also ships an automated `.completeness()` calculation to score the user's resume health out of 100%.
* **`input_screen.dart`**: An advanced multi-step wizard. Utilizes collapsible lists, dynamic form arrays (adding multiple education blocks), and real-time state saving.
* **`resume_service.dart`**: Standard database repository logic (CRUD ops to the Supabase `resumes` table).

#### 📄 Preview Module (`/lib/features/preview/`)
* **`preview_screen.dart`**: An interactive viewer powered by the `printing` package. It renders the underlying byte stream of the generated PDF. Includes a horizontal template carousel allowing the user to hot-swap themes (e.g., from *Classic* to *Tech*) and immediately view the updated PDF rendering.

### 4. `/lib/services/` — The Heavy Processing Layer
Logic that strictly bridges external environments or intense computation.

* **`pdf_service.dart`**: **The core intellectual property of the app.**
    * It does not use Flutter's visual widgets. It exclusively uses `package:pdf/widgets.dart` (`pw.Widget`). 
    * Exposes `PdfService.generateCV(CVModel, String templateName)`. 
    * Maps the visual logic of 6 distinct templates (*Classic, Modern, Tech, Executive, Creative, Academic*).
    * Handles complex pagination using `pw.Partitions` to prevent page overflow when dynamically growing lists span multiple A4 pages.
* **`weather_service.dart`**: Connects to `OpenWeatherMap`. Parses `geolocator` device coordinates, fetches current metrics, and translates weather ID codes into visual Emojis.
* **`quote_service.dart`**: Reaches out to ZenQuotes API for daily motivation payloads.

---

## 🗄️ Database Architecture & Data Flow

The backend relies on **Supabase (PostgreSQL)** for rapid mapping and offline resiliency.

### The `resumes` Table Structure
Instead of highly nested RDBMS normalization (which is painfully slow for massive, deeply nested dynamic forms), we utilize a monolithic `jsonb` architectural pattern perfectly suited for dynamic CV generation.

| Column | Internal Type | Note / Usage |
| :--- | :--- | :--- |
| `id` | `uuid` (Primary Key) | Auto-generated standard PK. |
| `user_id` | `uuid` (Foreign Key) | Strictly maps to Supabase `auth.users(id)` ensuring Row-Level Security (RLS). |
| `title` | `text` | The display name mapping to a specific application copy (e.g., "Microsoft Sweep Resume"). |
| `data` | `jsonb` | **The Core Payload.** This field stores the direct `CVModel.toJson()` serialization. Whenever the user leaves the `/editor`, this payload is updated. |
| `created_at` | `timestamp` | Audit metric for sorting recency. |

### The Data Flow Trajectory
1. User enters data on the **Input UI** (`input_screen.dart`).
2. App maps UI `TextEditingController` state into an immutable `CVModel`.
3. `CVModel.toJson()` fires, flattening the data.
4. `resume_service.dart` syncs the JSON payload to Supabase.
5. User navigates to **Preview UI**.
6. `CVModel` object is passed into `PdfService.generateCV`.
7. `PdfService` parses the model fields line-by-line using `package:pdf` primitives.
8. The `printing` package takes the raw underlying `Uint8List` PDF bytes and renders them locally onto the device screen without server-side rendering latency.

---
*Generated by Antigravity AI Engine during the Application Finalization phase.*

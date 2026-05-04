# Supabase Setup Guide — CV Studio Pro

## 1. Create a Supabase Project

1. Go to https://supabase.com and sign in
2. Click **New Project**
3. Give it a name: `cv-studio-pro`
4. Set a secure database password (save it!)
5. Choose the region nearest to you (e.g., Southeast Asia)

## 2. Get Your Project Credentials

1. In your Supabase dashboard, go to **Project Settings → API**
2. Copy:
   - **Project URL** → paste into `lib/core/constants/api_keys.dart` as `SupabaseConfig.url`
   - **anon / public key** → paste as `SupabaseConfig.anonKey`

## 3. Run the Database Schema

1. Go to **SQL Editor** in your Supabase dashboard
2. Click **New Query**, paste the SQL below, and click **Run**:

```sql
-- ── Profiles table ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id         UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name  TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Resumes table ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.resumes (
  id               UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id          UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title            TEXT DEFAULT 'My Resume',
  template_id      TEXT DEFAULT 'classic',
  completeness     INTEGER DEFAULT 0,
  profile          JSONB DEFAULT '{}',
  experiences      JSONB DEFAULT '[]',
  educations       JSONB DEFAULT '[]',
  researches       JSONB DEFAULT '[]',
  projects         JSONB DEFAULT '[]',
  certifications   JSONB DEFAULT '[]',
  activities       JSONB DEFAULT '[]',
  references_list  JSONB DEFAULT '[]', -- Fixed: Renamed from 'references' to avoid keyword conflict
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW()
);

-- ── Row Level Security ────────────────────────────────────────────
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.resumes  ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "profiles_select" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "profiles_insert" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles_update" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Resumes policies
CREATE POLICY "resumes_select" ON public.resumes FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "resumes_insert" ON public.resumes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "resumes_update" ON public.resumes FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "resumes_delete" ON public.resumes FOR DELETE USING (auth.uid() = user_id);

-- Auto-update updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER resumes_updated_at
  BEFORE UPDATE ON public.resumes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
```

## 4. Enable Email Auth

1. Go to **Authentication → Providers**
2. Make sure **Email** is enabled
3. Under **Email → Confirm email**: You can turn this OFF
   for easier local testing (turn ON for production)

## 5. Get OpenWeatherMap API Key

1. Go to https://openweathermap.org/api
2. Sign up (free) and verify email
3. Go to **My API Keys** → copy your default key
4. Paste it in `lib/core/constants/api_keys.dart` as `ApiKeys.openWeatherMap`

## 6. Enable Developer Mode on Windows (Required for Flutter)

Flutter uses symlinks on Windows, which requires Developer Mode:

1. Press Win + I → Settings
2. Go to **System → For developers**
3. Turn on **Developer Mode**
4. Restart your terminal

Then run:
```
flutter pub get
flutter run
```

## 7. Final Checklist

- [x] `SupabaseConfig.url` filled in
- [x] `SupabaseConfig.anonKey` filled in
- [ ] `ApiKeys.openWeatherMap` filled in (optional)
- [ ] SQL schema executed in Supabase
- [ ] Email auth enabled in Supabase
- [ ] Developer Mode enabled on Windows
- [ ] `flutter pub get` run successfully
- [ ] `flutter run` builds and launches on device/emulator

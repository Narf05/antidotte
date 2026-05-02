-- Users, profiles, calibration, and privacy settings

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  age_verified BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE user_profiles (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  profile_image_url TEXT,
  language TEXT NOT NULL DEFAULT 'en',
  style_mode TEXT NOT NULL DEFAULT 'chaos',
  main_animations_enabled BOOLEAN NOT NULL DEFAULT true,
  join_status_default TEXT NOT NULL DEFAULT 'join_me',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE user_calibration (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  body_weight_kg DECIMAL NOT NULL,
  height_cm DECIMAL,
  usual_drinks_per_session DECIMAL,
  usual_sessions_per_week DECIMAL,
  tolerance_self_rating TEXT,
  sports TEXT,
  drink_unit_definition JSONB NOT NULL DEFAULT '{}',
  motion_baseline_status TEXT NOT NULL DEFAULT 'not_started',
  phone_usage_baseline_status TEXT NOT NULL DEFAULT 'not_started',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE privacy_settings (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  location_sharing_enabled BOOLEAN NOT NULL DEFAULT false,
  location_precision TEXT NOT NULL DEFAULT 'off',
  share_when_app_closed BOOLEAN NOT NULL DEFAULT false,
  show_me_on_friend_map BOOLEAN NOT NULL DEFAULT true,
  share_during_sessions_only BOOLEAN NOT NULL DEFAULT false,
  photo_drink_detection_enabled BOOLEAN NOT NULL DEFAULT false,
  save_drink_photos_enabled BOOLEAN NOT NULL DEFAULT false,
  photo_analysis_default TEXT NOT NULL DEFAULT 'quick_log',
  motion_tracking_enabled BOOLEAN NOT NULL DEFAULT false,
  phone_usage_tracking_enabled BOOLEAN NOT NULL DEFAULT false,
  voice_analysis_enabled BOOLEAN NOT NULL DEFAULT false,
  message_analysis_enabled BOOLEAN NOT NULL DEFAULT false,
  drunkness_visibility TEXT NOT NULL DEFAULT 'category',
  notifications_enabled BOOLEAN NOT NULL DEFAULT true,
  panic_privacy_active BOOLEAN NOT NULL DEFAULT false,
  panic_privacy_expires_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

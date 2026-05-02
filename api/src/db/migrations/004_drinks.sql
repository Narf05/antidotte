-- Drink logs and photo-assisted drink detection

CREATE TABLE drink_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID REFERENCES night_out_sessions(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  drank_at TIMESTAMPTZ NOT NULL,
  timezone TEXT NOT NULL,
  source TEXT NOT NULL DEFAULT 'plus_one',
  drink_unit_count DECIMAL NOT NULL DEFAULT 1.0,
  alcohol_percentage DECIMAL,
  volume_ml INTEGER,
  drink_type TEXT NOT NULL,
  price_amount DECIMAL,
  price_currency TEXT,
  price_source TEXT,
  venue_id UUID REFERENCES venues(id),
  venue_name_snapshot TEXT,
  rough_area_latitude DECIMAL,
  rough_area_longitude DECIMAL,
  location_accuracy_m DECIMAL,
  location_source TEXT NOT NULL DEFAULT 'none',
  visibility TEXT NOT NULL DEFAULT 'private',
  note TEXT,
  photo_analysis_id UUID,
  drink_brand TEXT,
  serving_size_label TEXT,
  confidence DECIMAL,
  entered_while_offline BOOLEAN NOT NULL DEFAULT false,
  client_created_at TIMESTAMPTZ,
  is_deleted BOOLEAN NOT NULL DEFAULT false,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE drink_photo_analysis (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  drink_log_id UUID REFERENCES drink_logs(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  photo_storage_key TEXT,
  photo_deleted_at TIMESTAMPTZ,
  detected_drink_type TEXT,
  detected_volume_ml INTEGER,
  detected_alcohol_percentage DECIMAL,
  detected_price_amount DECIMAL,
  detection_confidence DECIMAL
);

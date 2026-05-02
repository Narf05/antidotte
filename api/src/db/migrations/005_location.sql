-- Location samples, live presence, and visibility rules

CREATE TABLE location_visibility_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  viewer_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  viewer_group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  visibility TEXT NOT NULL DEFAULT 'exact',
  active_only_during_session BOOLEAN NOT NULL DEFAULT false,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE location_samples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID REFERENCES night_out_sessions(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  sampled_at TIMESTAMPTZ NOT NULL,
  latitude DECIMAL NOT NULL,
  longitude DECIMAL NOT NULL,
  accuracy_m DECIMAL,
  speed_mps DECIMAL,
  heading_deg DECIMAL,
  source TEXT NOT NULL DEFAULT 'gps',
  retention_class TEXT NOT NULL DEFAULT 'realtime'
);

CREATE TABLE live_location_presence (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID REFERENCES night_out_sessions(id),
  last_seen_at TIMESTAMPTZ NOT NULL,
  latitude DECIMAL,
  longitude DECIMAL,
  rough_area_latitude DECIMAL,
  rough_area_longitude DECIMAL,
  venue_id UUID REFERENCES venues(id),
  venue_name_snapshot TEXT,
  presence_state TEXT NOT NULL DEFAULT 'hidden',
  stale_since TIMESTAMPTZ,
  hide_after TIMESTAMPTZ,
  battery_mode TEXT
);

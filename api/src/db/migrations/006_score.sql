-- Drunk score snapshots and active test results

CREATE TABLE drunk_score_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID REFERENCES night_out_sessions(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  percentage DECIMAL NOT NULL,
  confidence DECIMAL NOT NULL,
  tipsiness_category TEXT NOT NULL,
  motion_component DECIMAL,
  phone_usage_component DECIMAL,
  drink_log_component DECIMAL,
  active_test_component DECIMAL,
  session_floor_active BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE active_test_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID REFERENCES night_out_sessions(id),
  game_type TEXT NOT NULL,
  raw_score DECIMAL NOT NULL,
  normalized_score DECIMAL NOT NULL,
  confidence DECIMAL NOT NULL,
  round_type TEXT NOT NULL DEFAULT 'quick',
  multiplayer_room_id UUID,
  is_guest BOOLEAN NOT NULL DEFAULT false,
  guest_label TEXT,
  completed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

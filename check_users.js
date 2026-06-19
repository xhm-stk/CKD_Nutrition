const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://wgjvfqsdhozgvxrqvgyo.supabase.co';
const supabaseServiceKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndnanZmcXNkaG96Z3Z4cnF2Z3lvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4MDEzOTM4NywiZXhwIjoyMDk1NzE1Mzg3fQ.eFwlnLVkIidTDKO9GP4V-w_PaXMItpho1sQvZm1oVPU';

const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function checkProfile() {
  const { data, error } = await supabase.from('user_health_profiles').select('*').eq('user_id', 'd09ca5ae-97d3-4037-8cc0-24e5b4115bb6');
  
  if (error) {
    console.error('Error fetching profile:', error.message);
  } else {
    console.log('Health Profile Data:', data);
  }
}

checkProfile();

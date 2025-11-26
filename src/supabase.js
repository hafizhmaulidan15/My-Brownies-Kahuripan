import { createClient } from '@supabase/supabase-js'

// GANTI DENGAN DATA DARI WEBSITE SUPABASE LU:
const supabaseUrl = 'https://dktteahhcjdeqqioqbmb.supabase.co' // <-- Copas Project URL disini
const supabaseKey = 'sb_publishable_0bxdRXDc79sUQ-Vp8j4JJw_Q3li5CvR' // <-- Copas anon/public key disini

export const supabase = createClient(supabaseUrl, supabaseKey)
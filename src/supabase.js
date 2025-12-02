import { createClient } from '@supabase/supabase-js'


const supabaseUrl = 'https://dktteahhcjdeqqioqbmb.supabase.co'
const supabaseKey = 'sb_publishable_0bxdRXDc79sUQ-Vp8j4JJw_Q3li5CvR'

export const supabase = createClient(supabaseUrl, supabaseKey)
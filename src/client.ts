import {createClient} from '@supabase/supabase-js';
const env=(import.meta as unknown as {env:Record<string,string>}).env;
const url=env.VITE_SUPABASE_URL||'https://pgedkmfcjvccmusvgaav.supabase.co';
const key=env.VITE_SUPABASE_PUBLISHABLE_KEY||"sb_publishable_4Wq2IHmSJuNHJvstQPDPug_QrwCN7cJ";
export const configured=!!url&&!!key;
export const supabase=createClient(url,key,{auth:{storageKey:'tnbt_crm_auth_v1',persistSession:true,autoRefreshToken:true,detectSessionInUrl:false}});

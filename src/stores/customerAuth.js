import { defineStore } from 'pinia';
import { ref } from 'vue';
import { supabase } from '../supabase';

export const useCustomerAuthStore = defineStore('customerAuth', () => {
    const customer = ref(null);
    const loading = ref(false);

    // Load customer from localStorage on init
    const storedCustomer = localStorage.getItem('customer');
    if (storedCustomer) {
        try {
            customer.value = JSON.parse(storedCustomer);
        } catch (e) {
            localStorage.removeItem('customer');
        }
    }

    // Register new customer
    async function register(customerData) {
        loading.value = true;
        try {
            // Simple password hash (Base64)
            const passwordHash = btoa(customerData.password);

            const { data, error } = await supabase
                .from('customers')
                .insert([{
                    name: customerData.name,
                    email: customerData.email,
                    phone: customerData.phone,
                    password_hash: passwordHash,
                    address: customerData.address || null
                }])
                .select()
                .single();

            if (error) {
                if (error.code === '23505') { // Unique violation
                    throw new Error('Email sudah terdaftar');
                }
                throw error;
            }

            // Auto login after register
            customer.value = {
                id: data.id,
                name: data.name,
                email: data.email,
                phone: data.phone,
                address: data.address
            };

            localStorage.setItem('customer', JSON.stringify(customer.value));
            return { success: true, customer: customer.value };
        } catch (error) {
            console.error('Register error:', error);
            return { success: false, error: error.message };
        } finally {
            loading.value = false;
        }
    }

    // Login customer
    async function login(email, password) {
        loading.value = true;
        try {
            const passwordHash = btoa(password);

            const { data, error } = await supabase
                .from('customers')
                .select('*')
                .eq('email', email)
                .eq('password_hash', passwordHash)
                .single();

            if (error || !data) {
                throw new Error('Email atau password salah');
            }

            customer.value = {
                id: data.id,
                name: data.name,
                email: data.email,
                phone: data.phone,
                address: data.address
            };

            localStorage.setItem('customer', JSON.stringify(customer.value));
            return { success: true, customer: customer.value };
        } catch (error) {
            console.error('Login error:', error);
            return { success: false, error: error.message };
        } finally {
            loading.value = false;
        }
    }

    // Update customer profile
    async function updateProfile(updates) {
        if (!customer.value) return { success: false, error: 'Not logged in' };

        loading.value = true;
        try {
            const { data, error } = await supabase
                .from('customers')
                .update(updates)
                .eq('id', customer.value.id)
                .select()
                .single();

            if (error) throw error;

            customer.value = {
                id: data.id,
                name: data.name,
                email: data.email,
                phone: data.phone,
                address: data.address
            };

            localStorage.setItem('customer', JSON.stringify(customer.value));
            return { success: true, customer: customer.value };
        } catch (error) {
            console.error('Update profile error:', error);
            return { success: false, error: error.message };
        } finally {
            loading.value = false;
        }
    }

    // Logout customer
    function logout() {
        customer.value = null;
        localStorage.removeItem('customer');
    }

    // Check if logged in
    function isLoggedIn() {
        return customer.value !== null;
    }

    return {
        customer,
        loading,
        register,
        login,
        updateProfile,
        logout,
        isLoggedIn
    };
});

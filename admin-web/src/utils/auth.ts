import type { AdminProfile, MenuItem } from '@/api/auth';

const TOKEN_KEY = 'tcm_admin_token';
const REFRESH_KEY = 'tcm_admin_refresh_token';
const USERNAME_KEY = 'tcm_admin_username';
const PROFILE_KEY = 'tcm_admin_profile';
const MENUS_KEY = 'tcm_admin_menus';

export function getToken() {
  return localStorage.getItem(TOKEN_KEY) || '';
}

export function setSession(accessToken: string, refreshToken: string, profile: AdminProfile, menus: MenuItem[]) {
  localStorage.setItem(TOKEN_KEY, accessToken);
  localStorage.setItem(REFRESH_KEY, refreshToken);
  localStorage.setItem(PROFILE_KEY, JSON.stringify(profile));
  localStorage.setItem(MENUS_KEY, JSON.stringify(menus));
}

export function getProfile(): AdminProfile | null {
  const raw = localStorage.getItem(PROFILE_KEY);
  if (!raw) {
    return null;
  }
  try {
    return JSON.parse(raw) as AdminProfile;
  } catch {
    return null;
  }
}

export function getMenus(): MenuItem[] {
  const raw = localStorage.getItem(MENUS_KEY);
  if (!raw) {
    return [];
  }
  try {
    return JSON.parse(raw) as MenuItem[];
  } catch {
    return [];
  }
}

export function rememberUsername(username: string) {
  localStorage.setItem(USERNAME_KEY, username);
}

export function getRememberedUsername() {
  return localStorage.getItem(USERNAME_KEY) || '';
}

export function clearSession() {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(REFRESH_KEY);
  localStorage.removeItem(PROFILE_KEY);
  localStorage.removeItem(MENUS_KEY);
}

export function hasPermission(code: string) {
  const profile = getProfile();
  if (!profile) {
    return false;
  }
  if (profile.roles.includes('super_admin')) {
    return true;
  }
  return profile.permissions.includes(code);
}

import axios from "axios";

/** QT/production API (Nest `/api`). Override with `NEXT_PUBLIC_API_URL` or legacy `NEXT_PUBLIC_API_BASE_URL`. */
const apiBase =
  process.env.NEXT_PUBLIC_API_URL?.trim() ||
  process.env.NEXT_PUBLIC_API_BASE_URL?.trim() ||
  "https://zoea-africa.qtsoftwareltd.com/api";

export const apiClient = axios.create({
  baseURL: apiBase.replace(/\/$/, ""),
  timeout: 30_000,
  headers: { "Content-Type": "application/json" },
});

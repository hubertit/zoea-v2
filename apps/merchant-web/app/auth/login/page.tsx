"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Eye, EyeOff, Lock, Mail, Phone } from "lucide-react";
import { AuthBrandLogo } from "@/components/auth/AuthBrandLogo";
import { AuthSplitShell } from "@/components/auth/AuthSplitShell";
import { routes } from "@/lib/config/nav.config";
import { setPortalSession } from "@/lib/auth/portal-session";

export default function LoginPage() {
  const router = useRouter();
  const [identifier, setIdentifier] = useState("");
  const [password, setPassword] = useState("");
  const [isPhoneLogin, setIsPhoneLogin] = useState(true);
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [successMessage] = useState(() => {
    if (typeof window === "undefined") return "";
    return new URLSearchParams(window.location.search).get("registered") === "true"
      ? "Registration successful! Please log in with your credentials."
      : "";
  });

  useEffect(() => {
    if (typeof window === "undefined") return;
    if (new URLSearchParams(window.location.search).get("registered") === "true") {
      router.replace(routes.login, { scroll: false });
    }
  }, [router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      if (!identifier.trim()) {
        setError(isPhoneLogin ? "Phone number is required" : "Email is required");
        setLoading(false);
        return;
      }

      let normalized = identifier.trim();
      if (isPhoneLogin) {
        if (normalized.length < 9) {
          setError("Please enter a valid phone number");
          setLoading(false);
          return;
        }
        normalized = normalized.replace(/\D/g, "");
      } else if (!normalized.includes("@")) {
        setError("Please enter a valid email address");
        setLoading(false);
        return;
      }

      /* TODO: POST /auth/login via apiClient + secure cookie/session */
      const emailLabel = isPhoneLogin ? `+${normalized}` : normalized;
      const displayName = isPhoneLogin ? "Merchant" : emailLabel.split("@")[0] || "Merchant";
      setPortalSession({ displayName, email: emailLabel });
      await new Promise((r) => setTimeout(r, 450));
      router.push(routes.dashboard);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : "Login failed. Please try again.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthSplitShell>
      <div className="mb-8">
        <AuthBrandLogo />
        <h1 className="mb-2 text-3xl font-bold text-gray-900">Log in to Your zoea portal</h1>
        <p className="text-sm text-gray-600">
          New here?{" "}
          <Link href={routes.register} className="font-medium text-primary hover:opacity-80">
            Create account
          </Link>
        </p>
      </div>

      {successMessage ? (
        <div className="mb-4 rounded-sm border border-green-200 bg-green-50 p-3 text-sm text-green-700">
          {successMessage}
        </div>
      ) : null}

      {error ? (
        <div className="mb-4 rounded-sm border border-red-200 bg-red-50 p-3 text-sm text-red-600">{error}</div>
      ) : null}

      <form onSubmit={handleSubmit} className="space-y-5">
        <div className="mb-2 rounded-xl border border-gray-200/80 bg-gray-100 p-1">
          <div className="flex gap-0.5">
            <button
              type="button"
              onClick={() => {
                setIsPhoneLogin(true);
                setIdentifier("");
                setError("");
              }}
              className={`flex flex-1 items-center justify-center gap-2 rounded-lg px-4 py-2.5 text-sm font-medium transition-all duration-200 ease-out ${
                isPhoneLogin
                  ? "bg-white text-primary shadow-sm ring-1 ring-gray-200/50"
                  : "text-gray-500 hover:bg-gray-50/80 hover:text-gray-700"
              }`}
              disabled={loading}
            >
              <Phone className="size-4 shrink-0" aria-hidden />
              Phone
            </button>
            <button
              type="button"
              onClick={() => {
                setIsPhoneLogin(false);
                setIdentifier("");
                setError("");
              }}
              className={`flex flex-1 items-center justify-center gap-2 rounded-lg px-4 py-2.5 text-sm font-medium transition-all duration-200 ease-out ${
                !isPhoneLogin
                  ? "bg-white text-primary shadow-sm ring-1 ring-gray-200/50"
                  : "text-gray-500 hover:bg-gray-50/80 hover:text-gray-700"
              }`}
              disabled={loading}
            >
              <Mail className="size-4 shrink-0" aria-hidden />
              Email
            </button>
          </div>
        </div>

        <div>
          <label htmlFor="identifier" className="mb-2 block text-sm font-medium text-gray-700">
            {isPhoneLogin ? "Phone number" : "Email"}
          </label>
          <div className="relative">
            <div className="pointer-events-none absolute bottom-0 left-0 top-0 flex w-12 items-center justify-center text-gray-400">
              {isPhoneLogin ? <Phone className="size-4" aria-hidden /> : <Mail className="size-4" aria-hidden />}
            </div>
            <input
              id="identifier"
              type={isPhoneLogin ? "tel" : "email"}
              value={identifier}
              onChange={(e) => setIdentifier(e.target.value)}
              className="w-full rounded-sm border border-gray-200 bg-gray-50 py-2.5 pl-12 pr-4 text-sm text-gray-900 placeholder-gray-500 focus:border-primary focus:bg-white focus:outline-none focus:ring-1 focus:ring-primary"
              placeholder={isPhoneLogin ? "Enter your phone number" : "Enter your email"}
              required
              disabled={loading}
            />
          </div>
        </div>

        <div>
          <label htmlFor="password" className="mb-2 block text-sm font-medium text-gray-700">
            Password
          </label>
          <div className="relative">
            <div className="pointer-events-none absolute bottom-0 left-0 top-0 flex w-12 items-center justify-center text-gray-400">
              <Lock className="size-4" aria-hidden />
            </div>
            <input
              id="password"
              type={showPassword ? "text" : "password"}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full rounded-sm border border-gray-200 bg-gray-50 py-2.5 pl-12 pr-12 text-sm text-gray-900 placeholder-gray-500 focus:border-primary focus:bg-white focus:outline-none focus:ring-1 focus:ring-primary"
              placeholder="Enter your password"
              required
              disabled={loading}
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute bottom-0 right-0 top-0 flex w-12 items-center justify-center text-gray-400 hover:text-gray-600"
              tabIndex={-1}
              aria-label={showPassword ? "Hide password" : "Show password"}
            >
              {showPassword ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
            </button>
          </div>
        </div>

        <div className="flex items-center justify-end">
          <Link href={routes.forgotPassword} className="text-sm font-medium text-primary hover:opacity-80">
            Forgot password?
          </Link>
        </div>

        <button
          type="submit"
          disabled={loading}
          className="btn btn-primary flex w-full items-center justify-center gap-2 text-sm disabled:cursor-not-allowed disabled:opacity-50"
        >
          {loading ? (
            <>
              <span className="size-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
              <span>Logging in…</span>
            </>
          ) : (
            "Log in"
          )}
        </button>
      </form>

      <div className="mt-12 text-center">
        <p className="mb-2 text-xs text-gray-500">© {new Date().getFullYear()} Zoea</p>
        <p className="text-xs text-gray-500">Merchant business portal</p>
      </div>
    </AuthSplitShell>
  );
}

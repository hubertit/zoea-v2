"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import PhoneInput, { type Value } from "react-phone-number-input";
import { Eye, EyeOff, Lock, Mail, User } from "lucide-react";
import { AuthBrandLogo } from "@/components/auth/AuthBrandLogo";
import { AuthSplitShell } from "@/components/auth/AuthSplitShell";
import { routes } from "@/lib/config/nav.config";

export default function RegisterPage() {
  const router = useRouter();
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState<Value>();
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [errors, setErrors] = useState<Record<string, string>>({});

  const validateForm = () => {
    const newErrors: Record<string, string> = {};

    if (!firstName.trim()) newErrors.firstName = "First name is required";
    else if (firstName.trim().length > 50) newErrors.firstName = "First name cannot exceed 50 characters";

    if (!lastName.trim()) newErrors.lastName = "Last name is required";
    else if (lastName.trim().length > 50) newErrors.lastName = "Last name cannot exceed 50 characters";

    if (!email.trim()) newErrors.email = "Email is required";
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) newErrors.email = "Please provide a valid email address";

    if (!phone) newErrors.phone = "Phone number is required";
    else if (typeof phone === "string" && phone.length < 8) newErrors.phone = "Please enter a valid phone number";

    if (!password) newErrors.password = "Password is required";
    else if (password.length < 6) newErrors.password = "Password must be at least 6 characters long";

    if (!confirmPassword) newErrors.confirmPassword = "Please confirm your password";
    else if (password !== confirmPassword) newErrors.confirmPassword = "Passwords do not match";

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setErrors({});
    if (!validateForm()) return;

    setLoading(true);
    try {
      /* TODO: POST /auth/register */
      await new Promise((r) => setTimeout(r, 500));
      router.push(`${routes.login}?registered=true`);
    } catch (err: unknown) {
      const msg =
        err && typeof err === "object" && "message" in err
          ? String((err as { message?: string }).message)
          : "Registration failed. Please try again.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  const fieldBorder = (key: string) =>
    errors[key] ? "border-red-300 focus:border-red-500 focus:ring-2 focus:ring-red-100" : "border-gray-200 focus:border-primary focus:ring-2 focus:ring-primary/10";

  return (
    <AuthSplitShell>
      <div className="mb-8">
        <AuthBrandLogo />
        <h1 className="mb-2 text-3xl font-bold text-gray-900">Create account</h1>
        <p className="text-sm text-gray-600">
          Already have an account?{" "}
          <Link href={routes.login} className="font-medium text-primary hover:opacity-80">
            Log in
          </Link>
        </p>
      </div>

      {error ? (
        <div className="mb-4 rounded-sm border border-red-200 bg-red-50 p-3 text-sm text-red-600">{error}</div>
      ) : null}

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label htmlFor="firstName" className="mb-2 block text-sm font-medium text-gray-700">
            First name
          </label>
          <div className="relative">
            <div className="pointer-events-none absolute bottom-0 left-0 top-0 flex w-12 items-center justify-center text-gray-400">
              <User className="size-4" aria-hidden />
            </div>
            <input
              id="firstName"
              type="text"
              value={firstName}
              onChange={(e) => setFirstName(e.target.value)}
              className={`w-full rounded-sm border bg-gray-50 py-2.5 pl-12 pr-4 text-sm text-gray-900 placeholder-gray-500 focus:bg-white focus:outline-none focus:ring-1 ${fieldBorder("firstName")}`}
              placeholder="First name"
              required
              disabled={loading}
            />
          </div>
          {errors.firstName ? <p className="mt-1 text-xs text-red-600">{errors.firstName}</p> : null}
        </div>

        <div>
          <label htmlFor="lastName" className="mb-2 block text-sm font-medium text-gray-700">
            Last name
          </label>
          <input
            id="lastName"
            type="text"
            value={lastName}
            onChange={(e) => setLastName(e.target.value)}
            className={`w-full rounded-sm border bg-gray-50 px-4 py-2.5 text-sm text-gray-900 placeholder-gray-500 focus:bg-white focus:outline-none focus:ring-1 ${fieldBorder("lastName")}`}
            placeholder="Last name"
            required
            disabled={loading}
          />
          {errors.lastName ? <p className="mt-1 text-xs text-red-600">{errors.lastName}</p> : null}
        </div>

        <div>
          <label htmlFor="email" className="mb-2 block text-sm font-medium text-gray-700">
            Email
          </label>
          <div className="relative">
            <div className="pointer-events-none absolute bottom-0 left-0 top-0 flex w-12 items-center justify-center text-gray-400">
              <Mail className="size-4" aria-hidden />
            </div>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className={`w-full rounded-sm border bg-gray-50 py-2.5 pl-12 pr-4 text-sm text-gray-900 placeholder-gray-500 focus:bg-white focus:outline-none focus:ring-1 ${fieldBorder("email")}`}
              placeholder="Enter your email"
              required
              disabled={loading}
            />
          </div>
          {errors.email ? <p className="mt-1 text-xs text-red-600">{errors.email}</p> : null}
        </div>

        <div>
          <label htmlFor="phone" className="mb-2 block text-sm font-medium text-gray-700">
            Phone number
          </label>
          <div className={`phone-input-wrapper ${errors.phone ? "error" : ""}`}>
            <PhoneInput international defaultCountry="RW" value={phone} onChange={setPhone} disabled={loading} />
          </div>
          {errors.phone ? <p className="mt-1 text-xs text-red-600">{errors.phone}</p> : null}
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
              className={`w-full rounded-sm border bg-gray-50 py-2.5 pl-12 pr-12 text-sm text-gray-900 placeholder-gray-500 focus:bg-white focus:outline-none focus:ring-1 ${fieldBorder("password")}`}
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
          {errors.password ? <p className="mt-1 text-xs text-red-600">{errors.password}</p> : null}
        </div>

        <div>
          <label htmlFor="confirmPassword" className="mb-2 block text-sm font-medium text-gray-700">
            Confirm password
          </label>
          <div className="relative">
            <div className="pointer-events-none absolute bottom-0 left-0 top-0 flex w-12 items-center justify-center text-gray-400">
              <Lock className="size-4" aria-hidden />
            </div>
            <input
              id="confirmPassword"
              type={showConfirmPassword ? "text" : "password"}
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              className={`w-full rounded-sm border bg-gray-50 py-2.5 pl-12 pr-12 text-sm text-gray-900 placeholder-gray-500 focus:bg-white focus:outline-none focus:ring-1 ${fieldBorder("confirmPassword")}`}
              placeholder="Confirm your password"
              required
              disabled={loading}
            />
            <button
              type="button"
              onClick={() => setShowConfirmPassword(!showConfirmPassword)}
              className="absolute bottom-0 right-0 top-0 flex w-12 items-center justify-center text-gray-400 hover:text-gray-600"
              tabIndex={-1}
              aria-label={showConfirmPassword ? "Hide password" : "Show password"}
            >
              {showConfirmPassword ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
            </button>
          </div>
          {errors.confirmPassword ? <p className="mt-1 text-xs text-red-600">{errors.confirmPassword}</p> : null}
        </div>

        <button
          type="submit"
          disabled={loading}
          className="btn btn-primary mt-6 flex w-full items-center justify-center gap-2 text-sm disabled:cursor-not-allowed disabled:opacity-50"
        >
          {loading ? (
            <>
              <span className="size-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
              <span>Creating account…</span>
            </>
          ) : (
            "Create account"
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

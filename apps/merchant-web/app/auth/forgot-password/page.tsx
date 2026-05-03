"use client";

import Link from "next/link";
import { AuthBrandLogo } from "@/components/auth/AuthBrandLogo";
import { AuthSplitShell } from "@/components/auth/AuthSplitShell";
import { routes } from "@/lib/config/nav.config";

export default function ForgotPasswordPage() {
  return (
    <AuthSplitShell>
      <div className="mb-8">
        <AuthBrandLogo />
        <h1 className="mb-2 text-3xl font-bold text-gray-900">Forgot password</h1>
        <p className="text-sm text-gray-600">
          Self-serve password reset will connect to the Zoea API soon.{" "}
          <Link href={routes.login} className="font-medium text-primary hover:opacity-80">
            Back to log in
          </Link>
        </p>
      </div>
      <div className="mt-12 text-center">
        <p className="mb-2 text-xs text-gray-500">© {new Date().getFullYear()} Zoea</p>
        <p className="text-xs text-gray-500">Merchant business portal</p>
      </div>
    </AuthSplitShell>
  );
}

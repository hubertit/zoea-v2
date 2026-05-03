import type { ReactNode } from "react";

/** Same split layout as `gemura-web` auth: form column + hero cover. */
export function AuthSplitShell({ children }: { children: ReactNode }) {
  return (
    <div className="flex min-h-screen">
      <div className="flex w-full items-center justify-center bg-white p-6 sm:p-8 lg:w-[40%] lg:p-12">
        <div className="w-full max-w-sm">{children}</div>
      </div>
      <div className="relative hidden bg-black lg:flex lg:w-[60%]">
        <div
          className="absolute inset-0 bg-cover bg-center bg-no-repeat"
          style={{ backgroundImage: "url(/cover.jpg)" }}
        >
          <div className="absolute inset-0 bg-black/50" />
        </div>
      </div>
    </div>
  );
}

import Image from "next/image";
import Link from "next/link";
import { routes } from "@/lib/config/nav.config";

/** Official Zoea wordmark for light auth backgrounds (`public/logo.png`). */
export function AuthBrandLogo({ href = routes.login }: { href?: string }) {
  return (
    <Link href={href} className="mb-6 inline-block">
      <Image
        src="/logo.png"
        alt="Zoea"
        width={200}
        height={63}
        className="h-10 w-auto max-w-[220px] object-contain object-left sm:h-11"
        priority
        sizes="220px"
      />
    </Link>
  );
}

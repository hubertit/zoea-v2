import { redirect } from "next/navigation";
import { routes } from "@/lib/config/nav.config";

export default function Home() {
  redirect(routes.login);
}

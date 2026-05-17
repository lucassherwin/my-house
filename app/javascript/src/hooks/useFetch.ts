import { useState } from "react";
import { getCsrfToken } from "@/lib/csrf";

export type FetchStatus = "idle" | "pending" | "success" | "error";

const CSRF_METHODS = new Set(["POST", "PUT", "PATCH", "DELETE"]);

// TODO:
// add onSuccess and onError callbacks
// add default behavior for onError -> show toast

export function useFetch<T = unknown>(url: string, options: RequestInit = {}) {
  const [status, setStatus] = useState<FetchStatus>("idle");
  const [errors, setErrors] = useState<string[]>([]);
  const [data, setData] = useState<T | null>(null);

  const method = (options.method ?? "GET").toUpperCase();

  async function execute(body?: unknown): Promise<boolean> {
    setStatus("pending");
    setErrors([]);

    const headers = new Headers(options.headers);

    if (body !== undefined) {
      headers.set("Content-Type", "application/json");
    }

    if (CSRF_METHODS.has(method)) {
      try {
        headers.set("X-CSRF-Token", getCsrfToken());
      } catch {
        setErrors([
          "Page security token is missing — please refresh and try again.",
        ]);
        setStatus("error");
        return false;
      }
    }

    try {
      const res = await globalThis.fetch(url, {
        ...options,
        method,
        headers,
        body: body !== undefined ? JSON.stringify(body) : undefined,
      });

      const text = await res.text();

      let parsed: unknown = null;

      try {
        parsed = JSON.parse(text);
      } catch {
        console.error(
          `[useFetch] Non-JSON response from ${url} (HTTP ${res.status}):`,
          text.slice(0, 500),
        );
        setErrors(["An unexpected server error occurred. Please try again."]);
        setStatus("error");
        return false;
      }

      if (res.ok) {
        setData(parsed as T);
        setStatus("success");

        return true;
      }

      setErrors(extractErrors(parsed));
      setStatus("error");

      return false;
    } catch (err) {
      if (err instanceof DOMException && err.name === "AbortError") {
        setStatus("idle");
        return false;
      }

      console.error(
        `[useFetch] Error for ${url}:`,
        err instanceof Error ? `${err.name}: ${err.message}` : err,
      );

      setErrors(["Something went wrong. Please try again."]);
      setStatus("error");

      return false;
    }
  }

  return { fetch: execute, status, errors, data };
}

function extractErrors(body: unknown): string[] {
  if (!body || typeof body !== "object") return ["Something went wrong."];

  const d = body as Record<string, unknown>;

  if (Array.isArray(d.errors) && d.errors.every((e) => typeof e === "string"))
    return d.errors;

  if (typeof d.error === "string") return [d.error];

  console.error("Unexpected response body from server:", d);

  return ["Something went wrong."];
}

"use client";

export function MiniBarChart({
  values,
  height = 140,
  barColor = "var(--foreground)",
}: {
  /** Heights in 0–1 relative to chart */
  values: number[];
  height?: number;
  barColor?: string;
}) {
  const w = 560;
  const padX = 12;
  const padY = 8;
  const gap = 6;
  const n = values.length;
  const innerW = w - padX * 2;
  const barW = n > 0 ? (innerW - gap * (n - 1)) / n : 0;
  const innerH = height - padY * 2;

  return (
    <svg viewBox={`0 0 ${w} ${height}`} className="w-full max-w-full" preserveAspectRatio="none" aria-hidden>
      {values.map((v, i) => {
        const bh = Math.max(4, innerH * Math.min(1, Math.max(0, v)));
        const x = padX + i * (barW + gap);
        const y = padY + innerH - bh;
        return (
          <rect
            key={i}
            x={x}
            y={y}
            width={barW}
            height={bh}
            rx={3}
            fill={barColor}
            opacity={0.35 + v * 0.45}
          />
        );
      })}
    </svg>
  );
}

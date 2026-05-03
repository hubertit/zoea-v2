"use client";

/**
 * Lightweight SVG area chart (sacco-style: flat, no chart library).
 */
export function MiniAreaChart({
  data,
  stroke = "#181e29",
  height = 160,
}: {
  data: number[];
  stroke?: string;
  height?: number;
}) {
  const w = 560;
  const padX = 8;
  const padY = 10;
  const innerW = w - padX * 2;
  const innerH = height - padY * 2;
  const max = Math.max(...data, 1);
  const min = 0;
  const n = data.length;
  const step = n <= 1 ? innerW / 2 : innerW / (n - 1);

  const points = data.map((v, i) => {
    const x = padX + (n <= 1 ? innerW / 2 : i * step);
    const t = max === min ? 0.5 : (v - min) / (max - min);
    const y = padY + innerH * (1 - t);
    return { x, y };
  });

  const lineD = points.map((p, i) => `${i === 0 ? "M" : "L"} ${p.x.toFixed(1)} ${p.y.toFixed(1)}`).join(" ");
  const areaD = `${lineD} L ${points[points.length - 1]?.x ?? padX} ${padY + innerH} L ${points[0]?.x ?? padX} ${padY + innerH} Z`;

  return (
    <svg
      viewBox={`0 0 ${w} ${height}`}
      className="w-full max-w-full"
      style={{ maxHeight: height }}
      preserveAspectRatio="none"
      aria-hidden
    >
      <defs>
        <linearGradient id="mini-area-fill" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor={stroke} stopOpacity="0.12" />
          <stop offset="100%" stopColor={stroke} stopOpacity="0" />
        </linearGradient>
      </defs>
      <path d={areaD} fill="url(#mini-area-fill)" />
      <path d={lineD} fill="none" stroke={stroke} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" vectorEffect="non-scaling-stroke" />
      {points.map((p, i) => (
        <circle key={i} cx={p.x} cy={p.y} r="3.5" fill="white" stroke={stroke} strokeWidth="1.5" vectorEffect="non-scaling-stroke" />
      ))}
    </svg>
  );
}

'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import {
  MobileAppUpdateAPI,
  type MobilePlatformPolicy,
  type MobileUpdateMode,
} from '@/src/lib/api/mobile-app-update';
import { Button, Input, Select, Textarea, Breadcrumbs } from '@/app/components';
import Card, { CardBody, CardHeader } from '@/app/components/Card';
import { toast } from '@/app/components/Toaster';
import Icon, { faSave, faArrowLeft } from '@/app/components/Icon';

const MODES: { value: MobileUpdateMode; label: string }[] = [
  { value: 'none', label: 'Off (no prompt)' },
  { value: 'optional', label: 'Optional (user can dismiss)' },
  { value: 'mandatory', label: 'Mandatory (must update)' },
];

function emptyPlatform(): MobilePlatformPolicy {
  return {
    minVersion: '1.0.0',
    minBuild: null,
    mode: 'none',
    title: 'Update Zoea',
    message: 'A new version is available.',
    storeUrl: '',
    dismissForDays: 7,
  };
}

function PlatformForm({
  value,
  onChange,
}: {
  value: MobilePlatformPolicy;
  onChange: (p: MobilePlatformPolicy) => void;
}) {
  return (
    <div className="space-y-4">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Select
          label="Prompt mode"
          value={value.mode}
          onChange={(e) => onChange({ ...value, mode: e.target.value as MobileUpdateMode })}
          options={MODES.map((m) => ({ value: m.value, label: m.label }))}
        />
        <Input
          label="Minimum version (semver)"
          value={value.minVersion}
          onChange={(e) => onChange({ ...value, minVersion: e.target.value })}
          placeholder="2.1.0"
        />
        <Input
          label="Minimum build (optional)"
          value={value.minBuild === null || value.minBuild === undefined ? '' : String(value.minBuild)}
          onChange={(e) => {
            const v = e.target.value.trim();
            onChange({ ...value, minBuild: v === '' ? null : parseInt(v, 10) || 0 });
          }}
          placeholder="e.g. 30 — only after version equals minimum"
        />
        <Input
          label="Snooze days (optional mode only)"
          type="number"
          value={String(value.dismissForDays)}
          onChange={(e) =>
            onChange({ ...value, dismissForDays: Math.max(1, Math.min(365, parseInt(e.target.value, 10) || 7)) })
          }
        />
      </div>
      <Input
        label="Store URL"
        value={value.storeUrl}
        onChange={(e) => onChange({ ...value, storeUrl: e.target.value })}
        placeholder="https://apps.apple.com/... or https://play.google.com/..."
      />
      <Input label="Dialog title" value={value.title} onChange={(e) => onChange({ ...value, title: e.target.value })} />
      <Textarea
        label="Message"
        value={value.message}
        onChange={(e) => onChange({ ...value, message: e.target.value })}
        rows={3}
      />
    </div>
  );
}

export default function MobileAppUpdateSettingsPage() {
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [isActive, setIsActive] = useState(true);
  const [ios, setIos] = useState<MobilePlatformPolicy>(emptyPlatform);
  const [android, setAndroid] = useState<MobilePlatformPolicy>(emptyPlatform);
  const [updatedAt, setUpdatedAt] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const data = await MobileAppUpdateAPI.getPolicy();
        if (cancelled) return;
        setIsActive(data.isActive);
        setIos({ ...emptyPlatform(), ...data.ios });
        setAndroid({ ...emptyPlatform(), ...data.android });
        setUpdatedAt(data.updatedAt);
      } catch (e: any) {
        toast.error(e?.response?.data?.message || e?.message || 'Failed to load policy');
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const save = async () => {
    setSaving(true);
    try {
      const data = await MobileAppUpdateAPI.savePolicy({ ios, android, isActive });
      setUpdatedAt(data.updatedAt);
      toast.success('Mobile app update policy saved');
    } catch (e: any) {
      toast.error(e?.response?.data?.message || e?.message || 'Save failed');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[240px] text-gray-600">Loading…</div>
    );
  }

  return (
    <div className="space-y-6">
      <Breadcrumbs
        items={[
          { label: 'Settings', href: '/dashboard/settings' },
          { label: 'Mobile app updates' },
        ]}
      />
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div className="flex items-center gap-4">
          <Link href="/dashboard/settings">
            <Button variant="ghost" size="sm" icon={faArrowLeft}>
              Back
            </Button>
          </Link>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Mobile app updates</h1>
            <p className="text-gray-600 mt-1">
              Control optional and mandatory update prompts in the public iOS and Android apps.
            </p>
            {updatedAt && (
              <p className="text-xs text-gray-500 mt-1">Last saved: {new Date(updatedAt).toLocaleString()}</p>
            )}
          </div>
        </div>
        <Button variant="primary" icon={faSave} onClick={save} loading={saving}>
          Save
        </Button>
      </div>

      <Card>
        <CardHeader>
          <h2 className="text-lg font-semibold text-gray-900">Integration</h2>
        </CardHeader>
        <CardBody>
          <label className="flex items-center gap-2 text-sm text-gray-700 cursor-pointer">
            <input
              type="checkbox"
              className="rounded border-gray-300 text-[#0e1a30] focus:ring-[#0e1a30]"
              checked={isActive}
              onChange={(e) => setIsActive(e.target.checked)}
            />
            Policy active (when off, apps behave as &quot;no update required&quot;)
          </label>
        </CardBody>
      </Card>

      <Card>
        <CardHeader>
          <h2 className="text-lg font-semibold text-gray-900">iOS</h2>
        </CardHeader>
        <CardBody>
          <PlatformForm value={ios} onChange={setIos} />
        </CardBody>
      </Card>

      <Card>
        <CardHeader>
          <h2 className="text-lg font-semibold text-gray-900">Android</h2>
        </CardHeader>
        <CardBody>
          <PlatformForm value={android} onChange={setAndroid} />
        </CardBody>
      </Card>

      <Card>
        <CardBody>
          <p className="text-sm text-gray-600">
            The app calls <code className="text-xs bg-gray-100 px-1 rounded">GET /api/app/update-check</code> with{' '}
            <code className="text-xs bg-gray-100 px-1 rounded">platform</code>,{' '}
            <code className="text-xs bg-gray-100 px-1 rounded">version</code>, and{' '}
            <code className="text-xs bg-gray-100 px-1 rounded">build</code>. Set{' '}
            <strong>minimum version</strong> to the lowest version that may run without seeing the prompt. Use{' '}
            <strong>minimum build</strong> when the marketing version is unchanged but the store build must increase.
            Fill <strong>store URL</strong> for the Update button to open the listing.
          </p>
        </CardBody>
      </Card>
    </div>
  );
}

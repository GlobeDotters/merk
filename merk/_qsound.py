"""Provide a safe QSound wrapper.

PyQt5's QSound pulls in system Kerberos libraries via PulseAudio. The
Flathub KDE 5.15 runtime lacks libgssapi_krb5, so importing the
multimedia module would raise ImportError.  This wrapper degrades
gracefully: when QSound is available we re-export it; otherwise we
supply a stub with a no-op ``play`` method so MERK keeps running without
sound notifications.
"""

from __future__ import annotations

try:  # pragma: no cover - depends on runtime availability
    from PyQt5.QtMultimedia import QSound as _QSound
except ImportError:  # pragma: no cover
    class _FallbackSound:
        """Minimal stub replacement when QtMultimedia is unavailable."""

        @staticmethod
        def play(_path: str) -> None:
            """Ignore play requests when sound output is unavailable."""
            return None

    _QSound = _FallbackSound

QSound = _QSound

__all__ = ["QSound"]

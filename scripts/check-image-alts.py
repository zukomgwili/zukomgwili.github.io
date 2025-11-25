#!/usr/bin/env python3
"""Scan a built site directory for <img> tags missing alt attributes.

Usage: check-image-alts.py <site-dir>
"""
import sys
from html.parser import HTMLParser
from pathlib import Path


class ImgAltFinder(HTMLParser):
    def __init__(self, path):
        super().__init__()
        self.missing = []
        self.path = path

    def handle_starttag(self, tag, attrs):
        if tag.lower() != 'img':
            return
        attrs = dict(attrs)
        if 'alt' not in attrs or attrs.get('alt', '').strip() == '':
            # record location
            self.missing.append(attrs.get('src', '(no-src)'))


def scan_file(path: Path):
    try:
        text = path.read_text(encoding='utf-8', errors='ignore')
    except Exception:
        return []

    parser = ImgAltFinder(path)
    parser.feed(text)
    return parser.missing


def main():
    if len(sys.argv) < 2:
        print('Usage: check-image-alts.py <site-dir>')
        return 2

    site = Path(sys.argv[1])
    if not site.exists():
        print('Directory not found:', site)
        return 2

    total_missing = 0

    for html in site.rglob('*.html'):
        missing = scan_file(html)
        if missing:
            total_missing += len(missing)
            print(f'Missing alt(s) in {html.relative_to(site)}:')
            for src in missing:
                print('  -', src)

    if total_missing:
        print(f'Found {total_missing} <img> tags missing alt text.')
        return 1

    print('PASS: no missing image alt attributes detected.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())

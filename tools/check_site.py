"""Check built documentation links, fragment targets, search, and download policy."""

import json
import hashlib
import struct
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit


class Page(HTMLParser):
    def __init__(self, path):
        super().__init__(convert_charrefs=True)
        self.path = path
        self.ids = set()
        self.links = []
        self.feed(path.read_text(encoding="utf-8"))

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if attrs.get("id"):
            self.ids.add(attrs["id"])
        if tag == "a" and attrs.get("name"):
            self.ids.add(attrs["name"])
        for attribute in ("href", "src"):
            if attrs.get(attribute):
                self.links.append(attrs[attribute])


def main():
    root = Path(__file__).resolve().parents[1]
    site = root / "site"
    pages = {path.resolve(): Page(path) for path in site.rglob("*.html")}
    errors = []
    if not pages:
        raise SystemExit("No HTML found: run python -m mkdocs build --strict first.")
    link_count = 0
    for path, page in pages.items():
        for href in page.links:
            link_count += 1
            url = urlsplit(href)
            if "/releases" in url.path.lower() or url.path.lower().endswith((".exe", ".msi", ".zip")):
                errors.append(f"Software/release download link: {path.name}: {href}")
            if url.scheme or url.netloc:
                continue
            decoded = unquote(url.path)
            if decoded.startswith("/"):
                base_path = "/fleet-erechnung-vs-docs/"
                if not decoded.startswith(base_path):
                    errors.append(f"Unexpected absolute link: {href}")
                    continue
                target = site / decoded[len(base_path):]
            else:
                target = path.parent / decoded if decoded else path
            target = target.resolve()
            if target.is_dir():
                target = target / "index.html"
            if not target.is_file():
                errors.append(f"Missing target: {path.relative_to(site)}: {href}")
            elif url.fragment and target in pages:
                if unquote(url.fragment) not in pages[target].ids:
                    errors.append(f"Missing anchor: {path.relative_to(site)}: {href}")
    search = site / "search/search_index.json"
    if not search.exists():
        errors.append("Missing search index")
    else:
        index = json.loads(search.read_text(encoding="utf-8"))
        searchable = " ".join(item.get("text", "") for item in index["docs"])
        for term in ("BT151", "VATEX_EU_AE", "UnitConversion", "Taskplaner", "LandISO"):
            if term not in searchable:
                errors.append(f"Search index missing topic: {term}")
    workflow = (root / ".github/workflows/pages.yml").read_text(encoding="utf-8")
    if "contents: write" in workflow or "gh release" in workflow:
        errors.append("Workflow must not publish releases")
    screenshots = root / "docs/assets/screenshots"
    manifest = json.loads((screenshots / "manifest.json").read_text(encoding="utf-8"))
    fixture_text = (root / "tools/screenshots/demo.sql").read_text(encoding="utf-8")
    if hashlib.sha256(fixture_text.encode("utf-8")).hexdigest() != manifest["fixture_sha256"]:
        errors.append("Demo SQL fixture checksum differs (UTF-8/LF)")
    if len(manifest["images"]) != 7:
        errors.append("Expected seven documented original screenshots")
    for entry in manifest["images"]:
        png = screenshots / entry["file"]
        data = png.read_bytes()
        if data[:8] != b"\x89PNG\r\n\x1a\n":
            errors.append(f"Invalid PNG: {png.name}")
        elif struct.unpack(">II", data[16:24]) != (entry["width"], entry["height"]):
            errors.append(f"Screenshot dimensions differ: {png.name}")
        if hashlib.sha256(data).hexdigest() != entry["sha256"]:
            errors.append(f"Screenshot checksum differs: {png.name}")
        if not any(entry["file"] in href for page in pages.values() for href in page.links):
            errors.append(f"Screenshot is not embedded or linked: {png.name}")
    if errors:
        raise SystemExit("\n".join(errors))
    print(f"OK: {len(pages)} HTML pages, {link_count} links, seven screenshot checksums, anchors, search topics, no release downloads.")


if __name__ == "__main__":
    main()

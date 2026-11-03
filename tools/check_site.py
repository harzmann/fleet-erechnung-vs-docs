"""Check built documentation links, fragment targets, search, and download policy."""

import json
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
    if errors:
        raise SystemExit("\n".join(errors))
    print(f"OK: {len(pages)} HTML pages, {link_count} links, anchors, search topics, no release downloads.")


if __name__ == "__main__":
    main()

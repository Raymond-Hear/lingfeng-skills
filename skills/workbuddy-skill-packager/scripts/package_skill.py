"""Build a WorkBuddy Skill ZIP from adapted metadata, Markdown, and resources."""

import argparse
import json
import re
from pathlib import Path
from tempfile import TemporaryDirectory
from zipfile import ZIP_DEFLATED, ZipFile


REQUIRED_FIELDS = (
    "name", "display_name", "display_name_en", "description",
    "description_zh", "description_en", "version", "author",
)
EXAMPLE_FIELDS = ("examples_zh", "examples_en")
RESOURCE_DIRS = {"references", "scripts", "templates"}
SKILL_NAME = re.compile(r"[a-z0-9]+(?:-[a-z0-9]+)*")
REFERENCE = re.compile(r'(?<!@)@(references/[^\s\x60<>"\x27()[\]{}，。；！、：“”「」]+)')


def read_metadata(path):
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    if not isinstance(data, dict):
        raise ValueError("Metadata must be a JSON object.")

    allowed = {*REQUIRED_FIELDS, *EXAMPLE_FIELDS, "allowed-tools"}
    unknown = sorted(data.keys() - allowed)
    if unknown:
        raise ValueError(f"Unknown WorkBuddy fields: {', '.join(unknown)}")

    for field in REQUIRED_FIELDS:
        if not isinstance(data.get(field), str) or not data[field].strip():
            raise ValueError(f"Missing or empty WorkBuddy field: {field}")
    if not SKILL_NAME.fullmatch(data["name"]):
        raise ValueError("Use lowercase letters, digits, and hyphens for the skill name.")
    for field in EXAMPLE_FIELDS:
        if field in data and (
            not isinstance(data[field], list)
            or any(not isinstance(item, str) or not item.strip() for item in data[field])
        ):
            raise ValueError(f"{field} must be an array of nonempty strings.")
    if "allowed-tools" in data and (
        not isinstance(data["allowed-tools"], str) or not data["allowed-tools"].strip()
    ):
        raise ValueError("allowed-tools must be a comma-separated string.")
    return data


def collect_resources(root):
    if root is None:
        return {}
    if not root.is_dir():
        raise ValueError(f"Resource directory does not exist: {root}")
    for child in root.iterdir():
        if child.name not in RESOURCE_DIRS or not child.is_dir():
            raise ValueError(f"Use a standard WorkBuddy resource directory: {child.name}")

    files = {}
    resolved_root = root.resolve()
    for path in sorted(root.rglob("*")):
        relative_path = path.relative_to(root).as_posix()
        if path.is_symlink() or not path.resolve().is_relative_to(resolved_root):
            raise ValueError(f"Package a regular resource instead of a link: {relative_path}")
        if path.is_file():
            files[relative_path] = path
    return files


def quoted(value):
    return json.dumps(value, ensure_ascii=False)


def render_skill(metadata, body):
    lines = ["---"]
    for key, value in metadata.items():
        if isinstance(value, list) and value:
            lines.append(f"{key}:")
            lines.extend(f"  - {quoted(item)}" for item in value)
        elif isinstance(value, str):
            lines.append(f"{key}: {quoted(value)}")
    lines.extend(["---", "", body.strip(), ""])
    return "\n".join(lines)


def package(metadata_path, body_path, resource_path, output):
    metadata = read_metadata(metadata_path)
    body = body_path.read_text(encoding="utf-8-sig")
    if not body.strip() or body.lstrip().splitlines()[0] == "---":
        raise ValueError("Provide the Markdown body without another frontmatter block.")
    resources = collect_resources(resource_path)
    missing = set(REFERENCE.findall(body)) - resources.keys()
    if missing:
        raise ValueError(f"Missing referenced resources: {', '.join(sorted(missing))}")
    if output.suffix.lower() != ".zip":
        raise ValueError("The output filename must end in .zip.")
    if resource_path and output.resolve().is_relative_to(resource_path.resolve()):
        raise ValueError("Write the ZIP outside the resource directory.")
    output.parent.mkdir(parents=True, exist_ok=True)
    name = metadata["name"]

    with TemporaryDirectory(prefix="workbuddy-", dir=output.parent) as temp:
        archive_path = Path(temp) / "skill.zip"
        with ZipFile(archive_path, "w", compression=ZIP_DEFLATED) as archive:
            archive.writestr(f"{name}/SKILL.md", render_skill(metadata, body))
            for relative_path, path in resources.items():
                archive.write(path, f"{name}/{relative_path}")
        with ZipFile(archive_path) as archive:
            expected = {f"{name}/SKILL.md", *(f"{name}/{path}" for path in resources)}
            if set(archive.namelist()) != expected or archive.testzip() is not None:
                raise ValueError("The generated ZIP did not pass verification.")
        archive_path.replace(output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--metadata", type=Path, required=True)
    parser.add_argument("--body", type=Path, required=True)
    parser.add_argument("--resources", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    try:
        package(args.metadata, args.body, args.resources, args.output)
    except (OSError, ValueError) as error:
        parser.exit(1, f"{error}\n")
    print(args.output.resolve())


if __name__ == "__main__":
    main()

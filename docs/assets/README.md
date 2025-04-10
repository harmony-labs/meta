# Visual Assets

This directory contains visual assets for the `meta` CLI documentation, such as screenshots, diagrams, and GIFs.

## Adding Visual Assets

- Place all screenshots, diagrams, and demo GIFs in this directory.
- Use descriptive filenames (e.g., `meta-cli-screenshot.png`, `architecture-diagram.svg`, `meta-cli-demo.gif`).
- Reference these assets in documentation using relative paths, e.g.:
  ```markdown
  ![meta CLI Screenshot](assets/meta-cli-screenshot.png)
  ```

## Placeholders

If a required screenshot or GIF is not yet available, use a placeholder image or add a note in the relevant documentation section:
```markdown
<!-- ![Placeholder](https://via.placeholder.com/800x200?text=Screenshot+Coming+Soon) -->
```

## Recommended Visuals

- CLI screenshots (main README, Advanced Usage Guide)
- Architecture diagrams (Architecture Overview)
- Demo GIFs (Quick Start, Plugin Development Guide)
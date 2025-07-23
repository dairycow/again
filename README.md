# again

A minimal blog built with HTML and CSS.

## Workflow

1. Write a new post in `posts/your-post.html`
2. Push to main
3. GitHub Actions automatically builds and deploys to GitHub Pages

Posts should include `<h1>`, `<time datetime="">`, and content in `<article>` tags for proper parsing.

## Deployment

- **Source**: `main` branch contains source files (posts, CSS, build script)
- **Generated files**: `index.html` and `posts/all.html` are auto-generated and ignored in git
- **Deployment**: GitHub Actions builds and deploys to `gh-pages` branch
- **Site**: Served from `gh-pages` branch via GitHub Pages
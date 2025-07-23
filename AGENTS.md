# Agent Guidelines for "again" Blog

## Build/Test Commands
- **Build**: `./build.sh` (standalone script, also used by GitHub Actions)
- **No package.json**: This is a static HTML/CSS blog with no dependencies
- **Deploy**: Push to main branch triggers GitHub Actions build and deployment to gh-pages branch

## Code Style Guidelines

### HTML
- Use semantic HTML5 elements (`<article>`, `<header>`, `<nav>`, `<time>`)
- Include `datetime` attribute on `<time>` elements (YYYY-MM-DD format)
- Post structure: `<h1>` title, `<time>` date, content in `<article>` tags
- Use relative paths for internal links (`../` for parent directory)

### CSS
- Minimalist black and white design
- System fonts: `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`
- Max width: 800px, centered layout
- Colors: `#000` (black) and `#fff` (white) only
- Hover effects: invert colors (black background, white text)

### File Structure
- Posts go in `posts/` directory as individual HTML files
- Each post needs `<h1>`, `<time datetime="">`, and `<article>` for build script parsing
- Build script auto-generates `index.html` and `posts/all.html` (ignored in git, deployed to gh-pages)

### Deployment Architecture
- **main branch**: Source files only (posts, CSS, build script, .gitignore)
- **gh-pages branch**: Generated files deployed by GitHub Actions
- **Generated files**: `index.html` and `posts/all.html` are in .gitignore but deployed to gh-pages
- **GitHub Pages**: Serves site from gh-pages branch
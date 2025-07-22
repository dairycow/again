#!/bin/bash

# Extract post data and build index.html
echo "Building index.html..."

cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <h1>again</h1>
    </header>
    
    <main>
        <div class="post-list">
HTML

# Process each post file
for post in posts/*.html; do
    if [[ "$post" != "posts/all.html" ]]; then
        # Extract title, date, and first paragraph
        title=$(grep -o '<h1>.*</h1>' "$post" | sed 's/<[^>]*>//g')
        date=$(grep -o 'datetime="[^"]*"' "$post" | sed 's/datetime="//;s/"//')
        first_p=$(grep -o '<p>.*</p>' "$post" | head -1 | sed 's/<[^>]*>//g')
        filename=$(basename "$post")
        
        cat >> index.html << HTML
            <article class="post-excerpt">
                <h2><a href="posts/$filename">$title</a></h2>
                <time datetime="$date">$(date -d "$date" "+%B %d, %Y" 2>/dev/null || echo "$date")</time>
                <p>$first_p</p>
            </article>
            
HTML
    fi
done

cat >> index.html << 'HTML'
        </div>
        
        <div class="read-all">
            <a href="posts/all.html" class="read-all-btn">Read All Posts</a>
        </div>
    </main>
</body>
</html>
HTML

# Build all.html
echo "Building posts/all.html..."

cat > posts/all.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Posts - Blog</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body>
    <nav>
        <a href="../">Back</a>
    </nav>
    
HTML

# Add each post's article content
first=true
for post in posts/*.html; do
    if [[ "$post" != "posts/all.html" ]]; then
        if [[ "$first" != "true" ]]; then
            echo "    <hr>" >> posts/all.html
        fi
        # Extract just the article content
        sed -n '/<article>/,/<\/article>/p' "$post" >> posts/all.html
        first=false
    fi
done

cat >> posts/all.html << 'HTML'
</body>
</html>
HTML

echo "Build complete!"
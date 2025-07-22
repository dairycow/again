#!/bin/bash

# Function to get date from post file
get_post_date() {
    grep -o 'datetime="[^"]*"' "$1" | sed 's/datetime="//;s/"//'
}

# Function to get sorted posts by date (newest first)
get_sorted_posts() {
    for post in posts/*.html; do
        if [[ "$post" != "posts/all.html" ]]; then
            date=$(get_post_date "$post")
            echo "$date $post"
        fi
    done | sort -r | cut -d' ' -f2-
}

# Function to update navigation in a post
update_post_navigation() {
    local post_file="$1"
    local prev_post="$2"
    local next_post="$3"
    
    # Create temporary file
    local temp_file=$(mktemp)
    
    # Read the original file and replace navigation
    awk -v prev="$prev_post" -v nextpost="$next_post" '
    /<nav>/ {
        print "    <nav>"
        print "        <a href=\"../\">home</a>"
        print ""
        if (prev != "") {
            print "        <a href=\"" prev "\">prev</a>"
            if (nextpost != "") print ""
        }
        if (nextpost != "") {
            print "        <a href=\"" nextpost "\">next</a>"
        }
        print "    </nav>"
        
        # Skip until </nav>
        while (getline && !/<\/nav>/) {}
        next
    }
    { print }
    ' "$post_file" > "$temp_file"
    
    mv "$temp_file" "$post_file"
}

# Update navigation for all posts
echo "Updating post navigation..."
posts_array=($(get_sorted_posts))
total_posts=${#posts_array[@]}

for i in "${!posts_array[@]}"; do
    post="${posts_array[$i]}"
    filename=$(basename "$post")
    
    # Determine prev and next posts
    prev_post=""
    next_post=""
    
    if [ $i -gt 0 ]; then
        next_post=$(basename "${posts_array[$((i-1))]}")
    fi
    
    if [ $i -lt $((total_posts-1)) ]; then
        prev_post=$(basename "${posts_array[$((i+1))]}")
    fi
    
    update_post_navigation "$post" "$prev_post" "$next_post"
done

# Extract post data and build index.html
echo "Building index.html..."

cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>again</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <h1>again</h1>
    </header>
    
    <main>
        <div class="read-all">
            <a href="posts/all.html" class="read-all-btn">read all</a>
        </div>
        
        <div class="contact">
            <p>contact: <a href="mailto:h@8z.au">h@8z.au</a></p>
        </div>
        
        <div class="post-list">
HTML

# Process each post file (sorted by date, newest first)
for post in $(get_sorted_posts); do
    # Extract title, date, and first paragraph
    title=$(grep -o '<h1>.*</h1>' "$post" | sed 's/<[^>]*>//g')
    date=$(get_post_date "$post")
    first_p=$(grep -o '<p>.*</p>' "$post" | head -1 | sed 's/<[^>]*>//g')
    filename=$(basename "$post")
    
    cat >> index.html << HTML
            <article class="post-excerpt">
                <h2><a href="posts/$filename">$title</a></h2>
                <time datetime="$date">$(date -d "$date" "+%B %d, %Y" 2>/dev/null || echo "$date")</time>
                <p>$first_p</p>
            </article>
            
HTML
done

cat >> index.html << 'HTML'
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

# Add each post's article content (sorted by date, newest first)
first=true
for post in $(get_sorted_posts); do
    if [[ "$first" != "true" ]]; then
        echo "    <hr>" >> posts/all.html
    fi
    # Extract just the article content
    sed -n '/<article>/,/<\/article>/p' "$post" >> posts/all.html
    first=false
done

cat >> posts/all.html << 'HTML'
</body>
</html>
HTML

echo "Build complete!"

import os
import markdown

def create_html_template(title, content, css_path, breadcrumb_path):
    """Creates a full HTML document string with consistent styling."""
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title}</title>
    <link rel="stylesheet" href="{css_path}">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,700;1,400&family=Lato:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <main class="container">
        <header>
            <nav class="breadcrumb">
                <a href="{breadcrumb_path}">&larr; Back to Home</a>
            </nav>
        </header>
        {content}
    </main>
</body>
</html>
"""

def convert_markdown_to_html():
    """
    Finds all markdown files in the 'character designs' directory,
    converts them to HTML, and saves them.
    """
    print("Starting markdown to HTML conversion...")
    project_root = os.path.dirname(os.path.abspath(__file__))
    character_dir = 'character designs'
    character_path = os.path.join(project_root, character_dir)
    
    generated_files = []

    for root, _, files in os.walk(character_path):
        for file in files:
            if file.endswith('.md'):
                md_path = os.path.join(root, file)
                html_path = os.path.splitext(md_path)[0] + '.html'
                
                print(f"Processing: {md_path}")

                with open(md_path, 'r', encoding='utf-8') as f:
                    md_content = f.read()

                # Convert markdown to HTML, enabling the 'tables' extension
                html_content = markdown.markdown(md_content, extensions=['markdown.extensions.tables'])

                # Extract a title for the HTML page
                # We'll use the filename, removing the extension and ' profile'
                base_name = os.path.splitext(file)[0]
                title = base_name.replace(' profile', '')

                # Determine relative paths for CSS and breadcrumb
                # The CSS is in the root of 'character designs', and home is at the project root.
                depth = root.replace(project_root, '').count(os.sep) - 1
                css_path = '../' * (depth -1) + 'character-profile.css'
                breadcrumb_path = '../' * depth + 'index.html'

                # Create the full HTML page from the template
                full_html = create_html_template(title, html_content, css_path, breadcrumb_path)

                # Write the HTML file
                with open(html_path, 'w', encoding='utf-8') as f:
                    f.write(full_html)
                
                generated_files.append({
                    "path": os.path.relpath(html_path, project_root),
                    "title": title
                })
                print(f"  -> Saved HTML to: {html_path}")
    
    print("Conversion complete!")
    return generated_files

def update_homepage(generated_files):
    """Updates the main index.html with links to the generated profiles."""
    print("\nUpdating homepage with character profiles...")
    project_root = os.path.dirname(os.path.abspath(__file__))
    homepage_path = os.path.join(project_root, 'index.html')
    placeholder = '<!-- CHARACTER_PROFILES_LIST -->'

    if not generated_files:
        print("No files generated, skipping homepage update.")
        return

    # Sort files alphabetically by title for a consistent order
    sorted_files = sorted(generated_files, key=lambda x: x['title'])

    # Create the HTML list items
    list_items = []
    for file_info in sorted_files:
        # Ensure forward slashes for HTML paths
        html_safe_path = file_info['path'].replace(os.sep, '/')
        list_items.append(f'                        <li><a href="./{html_safe_path}">{file_info["title"]}</a></li>')
    
    character_list_html = '\n'.join(list_items)

    with open(homepage_path, 'r+', encoding='utf-8') as f:
        content = f.read()
        # Replace the placeholder and the empty <ul> that follows it
        new_content = content.replace(f'{placeholder}\n                    <ul class="character-list">\n                    </ul>', f'{placeholder}\n                    <ul class="character-list">\n{character_list_html}\n                    </ul>')
        f.seek(0)
        f.write(new_content)
        f.truncate()
    print("Homepage updated successfully!")

if __name__ == '__main__':
    files = convert_markdown_to_html()
    update_homepage(files)
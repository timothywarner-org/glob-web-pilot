import re

def fix_broken_links():
    """Fix all known broken links in GHAS-RESOURCES.md"""
    
    # Define the link corrections based on research
    corrections = {
        # GitHub Certifications - remove extra /github/ directory
        'https://learn.microsoft.com/en-us/credentials/certifications/github/github-advanced-security/': 
            'https://learn.microsoft.com/en-us/credentials/certifications/github-advanced-security/',
        
        'https://learn.microsoft.com/en-us/credentials/certifications/github/github-advanced-security/study-guide': 
            'https://learn.microsoft.com/en-us/credentials/certifications/github-advanced-security/',
        
        'https://learn.microsoft.com/en-us/credentials/certifications/github/github-foundations/': 
            'https://learn.microsoft.com/en-us/credentials/certifications/github-foundations/',
        
        'https://learn.microsoft.com/en-us/credentials/certifications/github/github-actions/': 
            'https://learn.microsoft.com/en-us/credentials/certifications/github-actions/',
        
        'https://learn.microsoft.com/en-us/credentials/certifications/github/github-administration/': 
            'https://learn.microsoft.com/en-us/credentials/certifications/github-administration/',
        
        # Learning Paths - updated paths
        'https://learn.microsoft.com/en-us/training/paths/configure-github-advanced-security-features/': 
            'https://learn.microsoft.com/en-us/training/paths/github-advanced-security/',
        
        'https://learn.microsoft.com/en-us/training/paths/github-administration/': 
            'https://learn.microsoft.com/en-us/training/paths/github-administration-products/',
        
        # Modules - updated module names
        'https://learn.microsoft.com/en-us/training/modules/github-secret-scanning/': 
            'https://learn.microsoft.com/en-us/training/modules/configure-use-secret-scanning-github-repository/',
        
        'https://learn.microsoft.com/en-us/training/modules/manage-security-findings-github-advanced-security/': 
            'https://learn.microsoft.com/en-us/training/modules/github-advanced-security-manage-security-findings/',
        
        'https://learn.microsoft.com/en-us/training/modules/introduction-to-github-products/': 
            'https://learn.microsoft.com/en-us/training/modules/github-introduction-products/',
        
        'https://learn.microsoft.com/en-us/training/modules/introduction-to-github-administration/': 
            'https://learn.microsoft.com/en-us/training/modules/github-introduction-administration/',
        
        'https://learn.microsoft.com/en-us/training/modules/manage-users-access-github/': 
            'https://learn.microsoft.com/en-us/training/modules/github-manage-users-access-organization/',
        
        # GitHub Blog - remove incorrect path
        'https://github.blog/changelog/label/security/': 
            'https://github.blog/changelog/'
    }
    
    # Read the file
    with open('GHAS-RESOURCES.md', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Track changes
    changes_made = []
    
    # Apply corrections
    for old_url, new_url in corrections.items():
        if old_url in content:
            content = content.replace(old_url, new_url)
            changes_made.append(f"Fixed: {old_url} -> {new_url}")
    
    # Write the corrected content back
    with open('GHAS-RESOURCES.md', 'w', encoding='utf-8') as f:
        f.write(content)
    
    # Print summary
    print(f"Link corrections applied: {len(changes_made)}")
    for change in changes_made:
        print(f"  - {change}")
    
    return len(changes_made)

if __name__ == "__main__":
    num_fixes = fix_broken_links()
    print(f"\nTotal links fixed: {num_fixes}")
    print("\nNow run validate_links.py to verify all links are working.")
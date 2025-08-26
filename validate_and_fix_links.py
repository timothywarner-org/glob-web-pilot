#!/usr/bin/env python3
"""
Enhanced link validator with automatic fixing capabilities for GHAS-RESOURCES.md
"""

import re
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed
import time
from urllib.parse import urlparse
import sys

# Known link corrections mapping
LINK_CORRECTIONS = {
    # GitHub Certifications - remove extra /github/ directory
    'https://learn.microsoft.com/en-us/credentials/certifications/github/github-advanced-security/': 
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
    
    'https://learn.microsoft.com/en-us/training/modules/introduction-to-github-products/': 
        'https://learn.microsoft.com/en-us/training/modules/github-introduction-products/',
    
    'https://learn.microsoft.com/en-us/training/modules/introduction-to-github-administration/': 
        'https://learn.microsoft.com/en-us/training/modules/github-introduction-administration/',
    
    # GitHub Blog - remove incorrect path
    'https://github.blog/changelog/label/security/': 
        'https://github.blog/changelog/'
}

def extract_links_from_markdown(file_path):
    """Extract all markdown links from the file"""
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    links = []
    for line_num, line in enumerate(content.split('\n'), 1):
        for match in re.finditer(r'\[([^\]]+)\]\(([^)]+)\)', line):
            links.append({
                'line': line_num,
                'text': match.group(1),
                'url': match.group(2)
            })
    
    return links, content

def check_url(link_info, timeout=10):
    """Check if a URL is accessible"""
    url = link_info['url']
    line = link_info['line']
    text = link_info['text']
    
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        response = requests.head(url, headers=headers, timeout=timeout, allow_redirects=True)
        
        if response.status_code == 405:
            response = requests.get(url, headers=headers, timeout=timeout, allow_redirects=True)
        
        status_code = response.status_code
        
        if status_code == 200:
            return {
                'line': line,
                'text': text,
                'url': url,
                'status': 'OK',
                'code': status_code,
                'final_url': response.url if response.url != url else None
            }
        elif status_code in [301, 302, 303, 307, 308]:
            return {
                'line': line,
                'text': text,
                'url': url,
                'status': 'REDIRECT',
                'code': status_code,
                'final_url': response.url
            }
        else:
            return {
                'line': line,
                'text': text,
                'url': url,
                'status': 'ERROR',
                'code': status_code,
                'error': f'HTTP {status_code}'
            }
    
    except requests.exceptions.Timeout:
        return {
            'line': line,
            'text': text,
            'url': url,
            'status': 'TIMEOUT',
            'error': 'Request timed out'
        }
    except requests.exceptions.ConnectionError as e:
        return {
            'line': line,
            'text': text,
            'url': url,
            'status': 'CONNECTION_ERROR',
            'error': str(e)
        }
    except Exception as e:
        return {
            'line': line,
            'text': text,
            'url': url,
            'status': 'EXCEPTION',
            'error': str(e)
        }

def validate_links(file_path, max_workers=10, auto_fix=False):
    """Validate all links in the markdown file"""
    print(f"Extracting links from {file_path}...")
    links, content = extract_links_from_markdown(file_path)
    
    print(f"Found {len(links)} links. Validating...")
    print("-" * 80)
    
    results = []
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        future_to_link = {executor.submit(check_url, link): link for link in links}
        
        for future in as_completed(future_to_link):
            result = future.result()
            results.append(result)
            
            if result['status'] == 'OK':
                print(f"[OK] Line {result['line']}: {result['text'][:50]}...")
                if result.get('final_url'):
                    print(f"   -> Redirected to: {result['final_url']}")
            elif result['status'] == 'REDIRECT':
                print(f"[REDIRECT] Line {result['line']}: {result['text'][:50]}...")
                print(f"   -> Redirects to: {result['final_url']}")
            else:
                print(f"[ERROR] Line {result['line']}: {result['text'][:50]}...")
                print(f"   URL: {result['url']}")
                print(f"   Error: {result.get('error', 'Unknown error')}")
    
    results.sort(key=lambda x: x['line'])
    
    # Summary
    print("\n" + "=" * 80)
    print("VALIDATION SUMMARY")
    print("=" * 80)
    
    ok_count = sum(1 for r in results if r['status'] == 'OK')
    redirect_count = sum(1 for r in results if r['status'] == 'REDIRECT')
    error_count = sum(1 for r in results if r['status'] not in ['OK', 'REDIRECT'])
    
    print(f"\nTotal Links: {len(results)}")
    print(f"[OK] Valid: {ok_count}")
    print(f"[REDIRECT] Redirects: {redirect_count}")
    print(f"[ERROR] Errors: {error_count}")
    
    # Show failed links
    if error_count > 0:
        print("\n" + "-" * 80)
        print("FAILED LINKS DETAILS:")
        print("-" * 80)
        for result in results:
            if result['status'] not in ['OK', 'REDIRECT']:
                print(f"\nLine {result['line']}: {result['text']}")
                print(f"  URL: {result['url']}")
                print(f"  Status: {result['status']}")
                print(f"  Error: {result.get('error', 'Unknown')}")
        
        # Auto-fix option
        if auto_fix:
            print("\n" + "-" * 80)
            print("ATTEMPTING AUTO-FIX...")
            print("-" * 80)
            
            fixed_count = 0
            for old_url, new_url in LINK_CORRECTIONS.items():
                if old_url in content:
                    content = content.replace(old_url, new_url)
                    fixed_count += 1
                    print(f"Fixed: {old_url}")
                    print(f"    -> {new_url}")
            
            if fixed_count > 0:
                # Write back the fixed content
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"\n[SUCCESS] Fixed {fixed_count} broken links in {file_path}")
                print("Please run the validator again to confirm all links are working.")
            else:
                print("\n[INFO] No automatic fixes available for the broken links.")
                print("Manual intervention may be required.")
    
    # Show redirected links
    if redirect_count > 0:
        print("\n" + "-" * 80)
        print("REDIRECTED LINKS:")
        print("-" * 80)
        for result in results:
            if result['status'] == 'REDIRECT' or (result['status'] == 'OK' and result.get('final_url')):
                print(f"\nLine {result['line']}: {result['text']}")
                print(f"  Original: {result['url']}")
                print(f"  Final: {result.get('final_url', 'N/A')}")
    
    return results, error_count

def main():
    """Main function"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Validate and optionally fix markdown links')
    parser.add_argument('file', nargs='?', default='GHAS-RESOURCES.md', 
                        help='Markdown file to validate (default: GHAS-RESOURCES.md)')
    parser.add_argument('--auto-fix', action='store_true', 
                        help='Automatically fix known broken links')
    parser.add_argument('--workers', type=int, default=10, 
                        help='Number of parallel workers (default: 10)')
    
    args = parser.parse_args()
    
    results, error_count = validate_links(args.file, max_workers=args.workers, auto_fix=args.auto_fix)
    
    # Exit with error code if there are broken links
    sys.exit(error_count)

if __name__ == "__main__":
    main()
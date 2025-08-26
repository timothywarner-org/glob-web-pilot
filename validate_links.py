import re
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed
import time
from urllib.parse import urlparse

def extract_links_from_markdown(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    pattern = r'\[([^\]]+)\]\(([^)]+)\)'
    matches = re.findall(pattern, content)
    
    links = []
    for line_num, line in enumerate(content.split('\n'), 1):
        for match in re.finditer(r'\[([^\]]+)\]\(([^)]+)\)', line):
            links.append({
                'line': line_num,
                'text': match.group(1),
                'url': match.group(2)
            })
    
    return links

def check_url(link_info, timeout=10):
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

def validate_links(file_path, max_workers=10):
    print(f"Extracting links from {file_path}...")
    links = extract_links_from_markdown(file_path)
    
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
    
    if redirect_count > 0:
        print("\n" + "-" * 80)
        print("REDIRECTED LINKS:")
        print("-" * 80)
        for result in results:
            if result['status'] == 'REDIRECT' or (result['status'] == 'OK' and result.get('final_url')):
                print(f"\nLine {result['line']}: {result['text']}")
                print(f"  Original: {result['url']}")
                print(f"  Final: {result.get('final_url', 'N/A')}")
    
    return results

if __name__ == "__main__":
    file_path = "GHAS-RESOURCES.md"
    results = validate_links(file_path)
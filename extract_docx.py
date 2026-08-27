import zipfile
import xml.etree.ElementTree as ET
import os
import glob


def extract_text_from_docx(docx_path):
    """Extract text from a .docx file by reading word/document.xml."""
    text = []
    try:
        with zipfile.ZipFile(docx_path) as z:
            xml = z.read('word/document.xml')
    except Exception as e:
        return f"[Error reading {docx_path}: {e}]"

    ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
    root = ET.fromstring(xml)

    for paragraph in root.findall('.//w:p', ns):
        para_text = []
        for node in paragraph.findall('.//w:t', ns):
            if node.text:
                para_text.append(node.text)
        if para_text:
            text.append(''.join(para_text))

    return '\n'.join(text)


def main():
    attachments_dir = r'C:\Users\User\Downloads\attachments'
    output_dir = r'C:\Users\User\Downloads\attachments\extracted'
    os.makedirs(output_dir, exist_ok=True)

    docx_files = glob.glob(os.path.join(attachments_dir, '*.docx'))
    for docx in docx_files:
        filename = os.path.basename(docx)
        text = extract_text_from_docx(docx)
        out_name = os.path.splitext(filename)[0] + '.txt'
        out_path = os.path.join(output_dir, out_name)
        with open(out_path, 'w', encoding='utf-8') as f:
            f.write(text)
        print(f"Extracted: {filename} -> {out_path}")


if __name__ == '__main__':
    main()

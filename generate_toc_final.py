import os, re, subprocess
from docx import Document
from reportlab.platypus import Paragraph, BaseDocTemplate, PageBreak, Frame, PageTemplate
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.pagesizes import letter
from reportlab.lib.units import inch
from pypdf import PdfReader, PdfWriter

# --- 🟢 SETTINGS 🟢 ---
docx_path = "/Users/jess/Downloads/Lopez_v_Vistra_Informer_Complaint_v2.docx"
source_pdf = "/Users/jess/Downloads/Blank_Pleading_Extra-Pages_20241.pdf"
overlay_temp = "overlay_temp.pdf"
final_output = "/Users/jess/Documents/MOSS_LANDING_FINAL_PLEADING.pdf"

FIRST_PAGE_TOP = 1.56 * inch 
REST_PAGE_TOP  = 1.10 * inch 
LINE_HEIGHT    = 24

# --- 🏛️ THE FULL-WIDTH HANGING TAB STYLES 🏛️ ---
def get_styles():
    # leftIndent=0 ensures subsequent lines wrap to the far left
    base = {'fontName': 'Times-Roman', 'fontSize': 12, 'leading': LINE_HEIGHT, 'leftIndent': 0}
    return {
        'title': ParagraphStyle('title', alignment=1, fontName='Times-Bold', fontSize=13, leading=LINE_HEIGHT, spaceAfter=12),
        'L1': ParagraphStyle('L1', **base, firstLineIndent=0.5*inch), # Roman numerals
        'L2': ParagraphStyle('L2', **base, firstLineIndent=0.75*inch), # Letters
        'L3': ParagraphStyle('L3', **base, firstLineIndent=1.0*inch), # Paragraph numbers
    }

styles = get_styles()

def load_and_clean(path):
    if not os.path.exists(path): return []
    doc = Document(path)
    content_list = []
    # Words that should remain lowercase
    lower_words = {'A', 'AN', 'THE', 'AND', 'BUT', 'FOR', 'OR', 'NOR', 'IN', 'ON', 'AT', 'BY', 'TO', 'OF', 'V.'}
    for para in doc.paragraphs:
        text = para.text.strip()
        if not text: continue
        
        # Fixed cleaning logic
        text = text.replace("EFENDANTS", "DEFENDANTS")
        text = re.sub(r'\.{2,}', ' ', text)
        
        words = text.split()
        processed = [w.lower() if w.upper() in lower_words and i != 0 else w.upper() for i, w in enumerate(words)]
        text = " ".join(processed)
        
        # Separate page numbers
        p_match = re.search(r'(\d+)$', text)
        p_num = p_match.group(1) if p_match else ""
        content = text[:p_match.start()].strip() if p_match else text
        content_list.append((content, p_num))
    return content_list

def apply_spacing(content, p_num):
    # Detect the numbering level to apply the correct indent
    l1_match = re.match(r'^(I|II|III|IV|V|VI|VII|VIII|IX|X)+\.', content)
    l2_match = re.match(r'^[A-Z]\.', content)
    l3_match = re.match(r'^\d+\.', content)
    
    if l1_match: style = styles['L1']
    elif l2_match: style = styles['L2']
    elif l3_match: style = styles['L3']
    else: return (f"<b>{content}</b>", styles['L1'])

    # Injecting non-breaking spaces for the "Tab" effect 
    # to maintain full-width wrapping on the left
    disp = f"<b>{content.replace('.', '.&nbsp;&nbsp;&nbsp;', 1)}</b>"
    
    if p_num:
        formatted = f'{disp}<setNextTabStop stop="6.75in" leader="."/><tab/><b>{p_num}</b>'
    else:
        formatted = disp
    return (formatted, style)

# --- THE ENGINE ---
data = load_and_clean(docx_path)
story = [Paragraph("<u><b>TABLE OF CONTENTS</b></u>", styles['title'])]
for c, p in data:
    if any(s in c.upper() for s in ["TABLE OF AUTHORITIES", "SUMMARY", "CONCLUSION"]):
        story.append(PageBreak())
        story.append(Paragraph(f"<u><b>{c}</b></u>", styles['title']))
        continue
    p_str, p_sty = apply_spacing(c, p)
    story.append(Paragraph(p_str, p_sty))

doc = BaseDocTemplate(overlay_temp, pagesize=letter)
f_width, f_bottom = 6.9 * inch, 1.0 * inch
frame1 = Frame(0.95*inch, f_bottom, f_width, 11*inch - FIRST_PAGE_TOP - f_bottom, id='first')
frame2 = Frame(0.95*inch, f_bottom, f_width, 11*inch - REST_PAGE_TOP - f_bottom, id='rest')

template1 = PageTemplate(id='FirstPage', frames=frame1, onPageEnd=lambda c, d: d.handle_nextPageTemplate('RestPages'))
template2 = PageTemplate(id='RestPages', frames=frame2)
doc.addPageTemplates([template1, template2])
doc.build(story)

# Merge with Pleading Paper
if os.path.exists(source_pdf):
    r, o, w = PdfReader(source_pdf), PdfReader(overlay_temp), PdfWriter()
    for i in range(len(o.pages)):
        out_p = w.add_blank_page(width=letter[0], height=letter[1])
        out_p.merge_page(r.pages[i % len(r.pages)])
        out_p.merge_page(o.pages[i])
    with open(final_output, "wb") as f: w.write(f)
    if os.path.exists(overlay_temp): os.remove(overlay_temp)
    print("FINISHED REFRESH")

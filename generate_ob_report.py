from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    HRFlowable, KeepTogether
)
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT
from datetime import date

OUTPUT = "/Users/mburnside/MBDEV/MBSFDXDEV/ebikes-lwc-2/OB_Security_Insights_Report.pdf"

# ── Data ──────────────────────────────────────────────────────────────────────

AUTHENTICATION = [
    ("SSO / MFA Coverage",          "48.3%",  "HIGH",   "Nearly half of users bypass SSO/MFA and use local username/password. Review local login policies and technically restrict this access to a minimal set of trusted users."),
    ("Stale Users",                 "24",     "HIGH",   "24 internal users have not logged in for 30+ days. Deactivate per Infosec policy to reduce attack surface."),
    ("Non-Compliant Password Policies", "3",  "MEDIUM", "3 password policies are misaligned with Infosec standards. Enforce strong policies to protect privileged users who can bypass SSO."),
    ("Users Without IP Restrictions", "39",   "MEDIUM", "39 users have no IP restrictions. Apply profile-level IP whitelisting, prioritising integration and privileged accounts."),
]

AUTHORIZATION = [
    ("Digital Experience Sharing",           "18",    "HIGH",   "18 objects/fields exposed in Digital Experiences lack proper sharing configuration. Align record sharing to business and regulatory requirements."),
    ("Digital Experience High-Risk Perms",   "2.02%", "HIGH",   "Experience users hold excess high-risk permissions. Apply Principle of Least Privilege to reduce risk surface."),
    ("High-Risk Permission Access",          "21.1%", "HIGH",   "More than 1 in 5 users hold high-risk permissions. Use Who Sees What Permissions Lens to identify and reduce assignments."),
    ("Report / Export Access",               "59.1%", "CRITICAL","59% of users can run or export reports — the primary data-exfiltration avenue for insider threats. Restrict Export Reports and Subscribe to Reports permissions."),
    ("Unused Custom Profiles",               "4",     "LOW",    "4 unused custom profiles exist. Remove to eliminate misconfiguration risk."),
    ("Vulnerable High-Risk Fields",          "0",     "OK",     "No vulnerable high-risk field access detected."),
    ("Objects Open to Deletion",             "0",     "OK",     "No objects unnecessarily open to mass deletion."),
]

DATA_PROTECTION = [
    ("Digital Experience High-Risk Fields",  "0",     "OK",     "No high-risk fields inappropriately exposed via Digital Experiences."),
    ("Permission Sets – High-Risk Fields",   "0",     "OK",     "No permission sets grant excess access to high-risk fields."),
    ("Profiles – High-Risk Fields",          "0",     "OK",     "No profiles grant excess access to high-risk fields."),
    ("Seldom-Used High-Risk Fields",         "0",     "OK",     "No dormant high-risk fields detected."),
    ("Potential High-Risk Field Candidates", "109",   "HIGH",   "109 fields identified as potentially high-risk have not yet been classified. Prioritise classification to enable accurate risk monitoring."),
    ("Data Classified",                      "1.15%", "CRITICAL","Only 1.15% of data has been classified. Complete classification — especially for high-risk fields — before meaningful data protection analysis is possible."),
]

INTEGRATION = [
    ("Event Bus Encryption",         "2",  "MEDIUM", "2 event bus items are unencrypted. If Shield Platform Encryption is licensed, enable 'Encrypt change data capture events and platform events' in Setup → Encryption Policy."),
    ("REST-Exposed Apex Classes",    "5",  "HIGH",   "5 Apex classes are exposed via REST. Verify OLS/FLS enforcement (WITH_SECURITY_ENFORCED / Security.stripInaccessible) and 'with sharing' declarations on each class."),
    ("Change Data Capture Objects",  "0",  "OK",     "No sensitive data replicated via CDC."),
    ("Outbound Messages",            "0",  "OK",     "No insecure outbound message configurations detected."),
    ("External High-Risk Fields",    "0",  "OK",     "No high-risk fields sourced from external objects."),
    ("Unencrypted Settings",         "13", "HIGH",   "13 application secrets are stored in Custom Metadata. Migrate to Named Credentials or Custom Settings to prevent exposure."),
    ("Insecure Remote Site Settings","1",  "MEDIUM", "1 remote site uses HTTP instead of HTTPS. Enable secure communication where possible."),
]

SEVERITY_COLOR = {
    "CRITICAL": colors.HexColor("#C0392B"),
    "HIGH":     colors.HexColor("#E67E22"),
    "MEDIUM":   colors.HexColor("#F1C40F"),
    "LOW":      colors.HexColor("#27AE60"),
    "OK":       colors.HexColor("#2ECC71"),
}

SEVERITY_TEXT = {
    "CRITICAL": colors.white,
    "HIGH":     colors.white,
    "MEDIUM":   colors.HexColor("#333333"),
    "LOW":      colors.white,
    "OK":       colors.white,
}

# ── Helpers ───────────────────────────────────────────────────────────────────

def severity_badge(sev, styles):
    bg   = SEVERITY_COLOR[sev]
    fg   = SEVERITY_TEXT[sev]
    cell_style = ParagraphStyle(
        "badge", parent=styles["Normal"],
        fontSize=7, textColor=fg, alignment=TA_CENTER,
        fontName="Helvetica-Bold"
    )
    return Paragraph(sev, cell_style), bg


def build_section_table(rows, styles):
    header_style = ParagraphStyle(
        "th", parent=styles["Normal"],
        fontSize=8, textColor=colors.white, fontName="Helvetica-Bold"
    )
    cell_style  = ParagraphStyle("td",  parent=styles["Normal"], fontSize=8)
    tip_style   = ParagraphStyle("tip", parent=styles["Normal"], fontSize=7.5,
                                 textColor=colors.HexColor("#555555"))

    table_data = [[
        Paragraph("Finding",    header_style),
        Paragraph("Metric",     header_style),
        Paragraph("Severity",   header_style),
        Paragraph("Recommendation", header_style),
    ]]

    row_styles = []
    for i, (finding, metric, sev, tip) in enumerate(rows, start=1):
        badge_para, badge_bg = severity_badge(sev, styles)
        table_data.append([
            Paragraph(finding, cell_style),
            Paragraph(metric,  cell_style),
            badge_para,
            Paragraph(tip, tip_style),
        ])
        row_styles.append(("BACKGROUND", (2, i), (2, i), badge_bg))

    col_widths = [1.7*inch, 0.65*inch, 0.75*inch, 4.0*inch]
    t = Table(table_data, colWidths=col_widths, repeatRows=1)

    base = [
        ("BACKGROUND",   (0, 0), (-1, 0),  colors.HexColor("#2C3E50")),
        ("TEXTCOLOR",    (0, 0), (-1, 0),  colors.white),
        ("FONTNAME",     (0, 0), (-1, 0),  "Helvetica-Bold"),
        ("FONTSIZE",     (0, 0), (-1, 0),  8),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#F7F9FB")]),
        ("GRID",         (0, 0), (-1, -1), 0.4, colors.HexColor("#CCCCCC")),
        ("VALIGN",       (0, 0), (-1, -1), "MIDDLE"),
        ("TOPPADDING",   (0, 0), (-1, -1), 5),
        ("BOTTOMPADDING",(0, 0), (-1, -1), 5),
        ("LEFTPADDING",  (0, 0), (-1, -1), 6),
        ("RIGHTPADDING", (0, 0), (-1, -1), 6),
        ("ALIGN",        (1, 0), (2, -1),  "CENTER"),
        ("ROUNDEDCORNERS", [3]),
    ]
    t.setStyle(TableStyle(base + row_styles))
    return t


def risk_summary_table(styles):
    data = [
        ("Report / Export Access",           "Authorization", "CRITICAL"),
        ("Data Classification Coverage",     "Data Protection", "CRITICAL"),
        ("High-Risk Permission Access",      "Authorization", "HIGH"),
        ("Potential High-Risk Field Candidates", "Data Protection", "HIGH"),
        ("SSO / MFA Coverage",               "Authentication", "HIGH"),
        ("REST-Exposed Apex Classes",        "Integration",   "HIGH"),
        ("Unencrypted Integration Settings", "Integration",   "HIGH"),
        ("Digital Experience Permissions",   "Authorization", "HIGH"),
        ("Stale Users",                      "Authentication","HIGH"),
    ]
    hdr = ParagraphStyle("rh", parent=styles["Normal"], fontSize=8,
                         textColor=colors.white, fontName="Helvetica-Bold")
    cel = ParagraphStyle("rc", parent=styles["Normal"], fontSize=8)

    table_data = [[
        Paragraph("#",        hdr),
        Paragraph("Finding",  hdr),
        Paragraph("Domain",   hdr),
        Paragraph("Severity", hdr),
    ]]
    row_styles = []
    for i, (finding, domain, sev) in enumerate(data, start=1):
        badge_para, badge_bg = severity_badge(sev, styles)
        table_data.append([
            Paragraph(str(i), cel),
            Paragraph(finding, cel),
            Paragraph(domain,  cel),
            badge_para,
        ])
        row_styles.append(("BACKGROUND", (3, i), (3, i), badge_bg))

    t = Table(table_data, colWidths=[0.3*inch, 2.9*inch, 1.4*inch, 0.75*inch], repeatRows=1)
    base = [
        ("BACKGROUND",     (0, 0), (-1, 0), colors.HexColor("#2C3E50")),
        ("ROWBACKGROUNDS",  (0, 1), (-1, -1), [colors.white, colors.HexColor("#F7F9FB")]),
        ("GRID",           (0, 0), (-1, -1), 0.4, colors.HexColor("#CCCCCC")),
        ("VALIGN",         (0, 0), (-1, -1), "MIDDLE"),
        ("TOPPADDING",     (0, 0), (-1, -1), 5),
        ("BOTTOMPADDING",  (0, 0), (-1, -1), 5),
        ("LEFTPADDING",    (0, 0), (-1, -1), 6),
        ("RIGHTPADDING",   (0, 0), (-1, -1), 6),
        ("ALIGN",          (0, 0), (0, -1),  "CENTER"),
        ("ALIGN",          (3, 0), (3, -1),  "CENTER"),
    ]
    t.setStyle(TableStyle(base + row_styles))
    return t


# ── Main ──────────────────────────────────────────────────────────────────────

def build():
    doc = SimpleDocTemplate(
        OUTPUT,
        pagesize=letter,
        leftMargin=0.75*inch, rightMargin=0.75*inch,
        topMargin=0.75*inch,  bottomMargin=0.75*inch,
        title="OB Security Insights Report",
        author="Security Engineering",
    )

    styles = getSampleStyleSheet()

    title_style = ParagraphStyle(
        "title", parent=styles["Title"],
        fontSize=22, textColor=colors.HexColor("#2C3E50"),
        fontName="Helvetica-Bold", spaceAfter=4
    )
    subtitle_style = ParagraphStyle(
        "subtitle", parent=styles["Normal"],
        fontSize=11, textColor=colors.HexColor("#7F8C8D"),
        alignment=TA_CENTER, spaceAfter=2
    )
    date_style = ParagraphStyle(
        "date", parent=styles["Normal"],
        fontSize=9, textColor=colors.HexColor("#95A5A6"),
        alignment=TA_CENTER, spaceAfter=12
    )
    section_style = ParagraphStyle(
        "section", parent=styles["Heading2"],
        fontSize=13, textColor=colors.HexColor("#2C3E50"),
        fontName="Helvetica-Bold", spaceBefore=18, spaceAfter=6,
        borderPad=4,
    )
    body_style = ParagraphStyle(
        "body", parent=styles["Normal"],
        fontSize=9, textColor=colors.HexColor("#444444"),
        spaceAfter=8, leading=13
    )
    confidential_style = ParagraphStyle(
        "conf", parent=styles["Normal"],
        fontSize=8, textColor=colors.HexColor("#C0392B"),
        alignment=TA_CENTER, fontName="Helvetica-Bold"
    )

    story = []

    # ── Cover block ──
    story.append(Spacer(1, 0.3*inch))
    story.append(Paragraph("Salesforce Org Security Insights", title_style))
    story.append(Paragraph("OB Security Assessment Report", subtitle_style))
    story.append(Paragraph(f"Prepared: {date.today().strftime('%B %d, %Y')}", date_style))
    story.append(Paragraph("CONFIDENTIAL — For Chief Security Officer Review", confidential_style))
    story.append(HRFlowable(width="100%", thickness=2, color=colors.HexColor("#2C3E50"), spaceAfter=14))

    # ── Executive Summary ──
    story.append(Paragraph("Executive Summary", section_style))
    story.append(Paragraph(
        "This report presents security findings derived from an automated OB (Org Baseline) analysis of "
        "the Salesforce production environment. Four security domains were assessed: Authentication, "
        "Authorization, Data Protection, and Integration. The analysis identified <b>two Critical</b> and "
        "<b>seven High</b> severity findings that require prompt remediation. The most urgent issues are "
        "the critically low data classification coverage (1.15%) and the broad report/export access granted "
        "to 59% of users, both of which present significant data exfiltration risk.",
        body_style
    ))

    # ── Priority Risk Summary ──
    story.append(Paragraph("Priority Risk Summary", section_style))
    story.append(risk_summary_table(styles))
    story.append(Spacer(1, 0.15*inch))

    # ── Domain sections ──
    sections = [
        ("1. Authentication",  AUTHENTICATION,
         "Controls governing how users prove their identity when accessing the org."),
        ("2. Authorization",   AUTHORIZATION,
         "Controls governing what users can see and do once authenticated."),
        ("3. Data Protection", DATA_PROTECTION,
         "Controls ensuring sensitive data is classified, restricted, and monitored."),
        ("4. Integration",     INTEGRATION,
         "Controls securing data flows between Salesforce and external systems."),
    ]

    for heading, rows, blurb in sections:
        story.append(KeepTogether([
            Paragraph(heading, section_style),
            Paragraph(blurb, body_style),
        ]))
        story.append(build_section_table(rows, styles))
        story.append(Spacer(1, 0.1*inch))

    # ── Recommended Next Steps ──
    story.append(Paragraph("Recommended Next Steps", section_style))
    steps = [
        ("Immediate (0–30 days)",
         "1. Launch a Data Classification sprint — classify all 109 high-risk field candidates.<br/>"
         "2. Restrict 'Export Reports' and 'Subscribe to Reports' permissions; reduce report access from 59% to role-appropriate levels.<br/>"
         "3. Deactivate 24 stale users immediately."),
        ("Short-term (30–60 days)",
         "4. Enforce SSO/MFA for the remaining ~52% of non-compliant users; restrict local login to a named admin group.<br/>"
         "5. Migrate 13 secrets from Custom Metadata to Named Credentials.<br/>"
         "6. Review and reduce high-risk permission assignments (currently 21% of users)."),
        ("Medium-term (60–90 days)",
         "7. Apply IP restrictions to integration users and other privileged accounts (39 users outstanding).<br/>"
         "8. Audit REST-exposed Apex classes (5) for OLS/FLS enforcement and 'with sharing' compliance.<br/>"
         "9. Align Digital Experience sharing and permission assignments with Principle of Least Privilege."),
    ]
    for timeframe, actions in steps:
        story.append(Paragraph(f"<b>{timeframe}</b>", body_style))
        story.append(Paragraph(actions, body_style))

    # ── Footer note ──
    story.append(Spacer(1, 0.2*inch))
    story.append(HRFlowable(width="100%", thickness=0.5, color=colors.HexColor("#CCCCCC"), spaceAfter=6))
    story.append(Paragraph(
        "This report was generated automatically from live Salesforce org data. "
        "Findings should be reviewed in conjunction with your organisation's Infosec policy "
        "and applicable regulatory requirements.",
        ParagraphStyle("footer", parent=styles["Normal"], fontSize=7.5,
                       textColor=colors.HexColor("#888888"), alignment=TA_CENTER)
    ))

    doc.build(story)
    print(f"PDF written to: {OUTPUT}")


if __name__ == "__main__":
    build()

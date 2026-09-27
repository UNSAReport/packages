# @unsareport/autoindent

Hierarchical contextual auto-indentation engine for academic reports and technical documents.

## Overview

In academic reports with numbered headings (e.g. `1.`, `1.1.`, `1.1.1.`), subsequent paragraphs, lists, tables, figures, and code blocks need to align dynamically to the heading's indentation and numbering gutter.

`@unsareport/autoindent` abstracts:
- **Contextual Hierarchical Indentation**: Automatically insets blocks relative to the active heading level and numbering width.
- **Heading Alignment**: Insets heading title text aligned past measured numbering labels.
- **Nested List & Table Protection**: Avoids redundant double-indentation on nested list/enum items and preserves native unindented layout inside tables.
- **Escape Hatches**: Provides `no-indent-block(body)` to exempt arbitrary content from auto-indentation, and `force-indent-block(body)` to force indentation.

## Usage

```typst
#import "/components/@unsareport/autoindent/lib.typ": (
  autoindent,
  indent-heading,
  no-indent-block,
  force-indent-block,
)

// Apply auto-indentation rules to the document
#show: autoindent

// Or apply with custom indent width and heading handling:
#show: autoindent.with(
  indent-width: 14pt,
  num-gutter: 0.8em,
  include-heading: true,
)
```

### Manual Heading Show Rule

If you are customizing heading typography and layout separately:

```typst
#import "/components/@unsareport/autoindent/lib.typ": autoindent, indent-heading

#show heading: it => indent-heading(it, indent-width: 12pt, num-gutter: 0.6em)
#show: autoindent.with(indent-width: 12pt, include-heading: false)
```

### Escape Hatches

```typst
#no-indent-block[
  This paragraph will not be indented regardless of current heading level.
]

#force-indent-block[
  This block will be indented even if appearing outside headings or inside nested containers.
]
```

## Exported API

- `autoindent(doc, indent-width: 12pt, num-gutter: 0.6em, indent-level-offset: 1, force-level: 1, include-heading: false)`
- `apply-autoindent` (alias for `autoindent`)
- `auto-indent(it, indent-width: 12pt, force-level: 1, indent-level-offset: 1)`
- `indent-heading(it, indent-width: 12pt, num-gutter: 0.6em, indent-level-offset: 1)`
- `no-indent-block(body)`
- `force-indent-block(body)`
- `wrap-list-item(it)`
- `wrap-enum-item(it)`
- `wrap-table(it)`
- `heading-num-width`
- `in-table`

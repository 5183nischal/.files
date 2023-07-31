local helpers = require('personal.luasnip-helper-funcs')
local get_visual = helpers.get_visual

local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Math context detection
local tex = {}
tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
tex.in_text = function() return not tex.in_mathzone() end

-- Return snippet tables
return
{
  -- ANNOTATE (custom command for annotating equation derivations)
  s({ trig = "ann", snippetType = "autosnippet" },
    fmta(
      [[
      \annotate{<>}{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
      }
    )
  ),
  -- REFERENCE
  s({ trig = "rff", snippetType = "autosnippet", wordTrig = false },
    fmta(
      [[
      ~\ref{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- DOCUMENTCLASS
  s({ trig = "dcc", snippetType = "autosnippet" },
    fmta(
      [=[
        \documentclass[<>]{<>}
        ]=],
      {
        i(1, "a4paper"),
        i(2, "article"),
      }
    ),
    { condition = line_begin }
  ),
  -- USE A LATEX PACKAGE
  s({ trig = "pack", snippetType = "autosnippet" },
    fmta(
      [[
        \usepackage{<>}
        ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- INPUT a LaTeX file
  s({ trig = "inn", snippetType = "autosnippet" },
    fmta(
      [[
      \input{<><>}
      ]],
      {
        i(1, "~/.config/templates/"),
        i(2)
      }
    ),
    { condition = line_begin }
  ),
  -- LABEL
  s({ trig = "lbl", snippetType = "autosnippet" },
    fmta(
      [[
      \label{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- HPHANTOM
  s({ trig = "hpp", snippetType = "autosnippet" },
    fmta(
      [[
      \hphantom{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),
  s({ trig = "TODOO", snippetType = "autosnippet" },
    fmta(
      [[\TODO{<>}]],
      {
        d(1, get_visual),
      }
    )
  ),
  s({ trig = "nc" },
    fmta(
      [[\newcommand{<>}{<>}]],
      {
        i(1),
        i(2)
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "sii", snippetType = "autosnippet" },
    fmta(
      [[\si{<>}]],
      {
        i(1),
      }
    )
  ),
  s({ trig = "SI" },
    fmta(
      [[\SI{<>}{<>}]],
      {
        i(1),
        i(2)
      }
    )
  ),
  s({ trig = "url" },
    fmta(
      [[\url{<>}]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- VSPACE
  s({ trig = "vs" },
    fmta(
      [[\vspace{<>}]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- Section
  s({ trig = "h1", regTrig = false, wordTrig = true, snippetType = "autosnippet" },
    fmta([[
    \section{<>}
    ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "hh1", regTrig = false, wordTrig = true, snippetType = "autosnippet" },
    fmta([[
    \section*{<>}
    ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Subsection
  s({ trig = "h2", regTrig = false, wordTrig = true, snippetType = "autosnippet" },
    fmta([[
    \subsection{<>}
    ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "hh2", regTrig = false, wordTrig = true, snippetType = "autosnippet" },
    fmta([[
    \subsection*{<>}
    ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Subsubsection
  s({ trig = "h3", regTrig = false, wordTrig = true, snippetType = "autosnippet" },
    fmta([[
    \subsubsection{<>}
    ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "hh3", regTrig = false, wordTrig = true, snippetType = "autosnippet" },
    fmta([[
    \subsubsection*{<>}
    ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- INPUT a LaTeX file
  s({ trig = "pre", snippetType = "autosnippet" },
    fmta(
      [[
      \documentclass[a4paper]{scrartcl}
      \usepackage[ fancytheorems, fancyproofs, noindent, ]{~/.config/templates/<>}

      \title{<>}
      \author{<>}
      \date{\today}

      \allowdisplaybreaks

      \begin{document}
      \maketitle
      \tableofcontents

      <>

      \end{document}
      ]],
      {
        i(1, "nisch"),
        i(2),
        i(3, "Nischal Mainali"),
        i(4)
      }
    ),
    { condition = line_begin }
  ),
}

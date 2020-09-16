We modified the expander in `type-expander.hl.rkt`. In particular, lines
423-488 implement the expander environment manipulation interface used
by the rest of the expander in terms of our new syntax system API. Line
651 directly uses our `apply-as-transformer` procedure rather than
`define/hygienic` because it was a simpler change relative to the
existing code.

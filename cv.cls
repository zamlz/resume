
\LoadClass{article}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}

% Customize the section headers
\RequirePackage{titlesec}
\RequirePackage{ifthen}
\RequirePackage{enumitem}
\RequirePackage{xparse}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage[stable]{footmisc}
\providecommand\fullresume{false}

\RequirePackage{natbib}
\RequirePackage{bibentry}
\nobibliography*

% Set the margins
\usepackage[margin=0.75in]{geometry}

% We also to use images
\usepackage[]{graphicx}
\graphicspath{{icons/}}
\usepackage{amsmath}
\usepackage{changepage}

% We also to use hyperlinks to projects.
\usepackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=NavyBlue,
    filecolor=magenta,
    urlcolor=NavyBlue,
}

% Turn off page numbering
\pagenumbering{gobble}

% Customize the section heading
\titleformat{\section}
    {\Large\scshape\raggedright} % Customize the size fo the section command
    {}{0em} % Provides a prefix to every section
    {} % Insert code before the heading
    [\titlerule] % Inserts a horizontal line after the heading

% Customize the subsection heading
\titleformat{\subsection}
    {\large\scshape\raggedright}
    {}{0em}
    {}

% This provides dates to certain section headers
\newcommand{\datedsection}[2]{%
    \section[#1]{#1 \hfill #2}%
}
\newcommand{\datedsubsection}[2]{%
    \subsection[#1]{#1 \hfill #2}%
}

% Provide a command for name and contact information
\newcommand{\name}[1]{
    \centerline{\Huge{#1}}
}

\ExplSyntaxOn
\NewDocumentCommand{\speciallist}{O{}+m}{%
    \group_begin:
    \seq_set_from_clist:Nn \l_tmpa_seq {#2}
    \seq_if_empty:NF \l_tmpa_seq {
        \begin{itemize}[leftmargin=3.5cm,labelsep=0.5cm,font={\scshape},#1]
        \int_step_inline:nnnn {1}{2} {\seq_count:N \l_tmpa_seq} {
            \item[\seq_item:Nn \l_tmpa_seq {##1}]  \seq_item:Nn \l_tmpa_seq {##1+1}
        }
        \end{itemize}
    }
    \group_end:
    \vspace{-16pt}
}
\ExplSyntaxOff

% Generate the new contact details
\newcommand{\contact}[6]{
    \speciallist[leftmargin=4.0cm, itemsep=-4pt]
        {Website:,\href{#3}{\ttfamily#3},
        GitHub:,\href{#5}{\ttfamily#5},
        GitLab:,\href{#6}{\ttfamily#6},
        Email:,\href{mailto:#1}{\ttfamily#1},
        Phone:,#2,Citizenship:,#4}
}

% Create a skills list
\newcommand{\skills}[3]{
    \speciallist[leftmargin=4.0cm, itemsep=-4pt]
    %{Languages:,{#1},Libraries:,{#2},Technologies:,{#3}}
    {Languages:,{#1},Libraries:,{#2}}
}

% Create a education list
\newcommand{\datelist}[1]{
    \speciallist[leftmargin=4.0cm]{#1}
}

% Create a paper list
\newcommand{\paperlist}[1]{
    \speciallist[leftmargin=1.25cm]{#1}
}

% A sub-section for recent projects
\newcommand{\projectsubsection}[4]{
    \pagebreak[1] % This tells latex that if we need to, break page
    \subsection[#1]{\href{#4}{#1}
        ~{\normalfont\footnotesize\textit{(#2)}}\\
        {\normalfont\normalsize#3}
    }
}

% A sub-section for project entires that are old.
\newcommand{\projectsubsectionold}[4]{
    \ifthenelse{\equal{\fullresume}{true}}{
        \projectsubsection{#1}{#2}{#3}{#4}
    }{}
}

% A sub-section for recent jobs/experience
\newcommand{\jobsubsection}[4]{
    \pagebreak[1] % This tells latex that if we need to, break page
    \subsection[#1]{#1 \hfill #2
        \\ {\normalfont\normalsize\textit{#3}\\#4}
    }
}

% The sub-section for job/experience entries that are old.
\newcommand{\jobsubsectionold}[4]{
    \ifthenelse{\equal{\fullresume}{true}}{
        \jobsubsection{#1}{#2}{#3}{#4}
    }{}
}

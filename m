From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v2 0/9] docs: cgroup-v1: formatting improv for "Memory Resource Controller" doc
Date: Thu,  5 Jan 2023 20:16:25 +0700
Message-ID: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HUkOkbYzuv5WTxnO2sv3n0IBM4omUdA6IheQF/z4HEk=;
        b=NGtacwLgGIfh31U+j37UAkxT1pREhpEa5I7Zke513uzhR7ayCdgCJbrs6KJiPvm06G
         fFnCmYRv+PHI1g5DcOZktq7IN/66rGcEzHoW3YjMbKRqEvewBDT8rUuYaoaaHqHZ78QP
         PtEv4zWfcdWbJYB7ILQwRDe/bGViy3ZC63cJeYMXvm8MbStVEc3cjzLQnVHYp+FNYSb5
         PQNcD40i+b5wMdGICjjhXSmU5X7aytJ1yHYPs94FSKOKHIuzzpjLwfEopRxYZyhe2GU3
         nrs86tF5hzi0AXjOlJujcpTA+Bmag6mafIsPZcuIeq6mpMF3FF8GB3vZHPbXUaTjKHqL
         Jn2g==
X-Developer-Signature: v=1; a=openpgp-sha256; l=3353; i=bagasdotme@gmail.com; h=from:subject; bh=/kf4xrQxZdifPynYl0ZAE3ZdLLa3+RCO1xkFVH/rr78=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbzq74Oaf24mtmL1epe2kFR1t/Gskr2N2/xXXUT5Cp7Mit N8vOdJSyMIhxMciKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAiAWcZGU5FLnntdv6I4smC0myPyx r1nxvn7So4dqmS6VnI/EmdLxYx/FOWCK2cymic2LvpZ6Cq+MkLArusbB7tVZ543rpZb8f/2WwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups@vger.kernel.org>, Linux Documentation <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

"Memory Resource Controller" CGroup v1 documentation has been in reST since
99c8b231ae6c6c ("docs: cgroup-v1: convert docs to ReST and rename to *.rst").
The current doc look is kinda ugly, so improve the formatting (only htmldocs is
tested).

Changes since v1 [1]:
  * Drop the underline fix, since the blamed commit had been dropped
  * Rebase on top of current cgroup tree (for-next branch)

Range-diff against v1:

 1:  e0f2b878ad6435 <  -:  -------------- docs: cgroup-v1: extend underline of section 8
 2:  4e26b743ce9b42 =  1:  cb31249cacdad6 docs: cgroup-v1: replace custom note constructs with appropriate admonition blocks
 3:  c89f9aa1e6dac9 <  -:  -------------- docs: cgroup-v1: wrap remaining admonitions in admonition blocks
 -:  -------------- >  2:  8e03baf289c4f2 docs: cgroup-v1: wrap remaining admonitions in admonition blocks
 4:  b901b2b0407e23 =  3:  790ac70bcf31e1 docs: cgroup-v1: use code block for locking order schema
 5:  f4112d2f9990ce =  4:  2af22c24977a38 docs: cgroup-v1: fix footnotes
 6:  d5d16831555e6b =  5:  9788d0e8c87cc5 docs: cgroup-v1: move hierarchy of accounting caption
 7:  92db959851e2c8 =  6:  b191e2bd87871b docs: cgroup-v1: use bullet lists for list of stat file tables
 8:  767988658f58b8 !  7:  56e4ba363e4e65 docs: cgroup-v1: use make swap extension subsections subsections
    @@ Metadata
     Author: Bagas Sanjaya <bagasdotme@gmail.com>
     
      ## Commit message ##
    -    docs: cgroup-v1: use make swap extension subsections subsections
    +    docs: cgroup-v1: make swap extension subsections subsections
     
         Subsections text of swap extension section is marked up as bold text,
         whereas making them proper subsection is more appropriate.
 9:  a502f09f9a3c33 !  8:  6895ee7c84e840 docs: cgroup-v1: add internal cross-references
    @@ Documentation/admin-guide/cgroup-v1/memory.rst: If we want to change this to 1G,
      
     +.. _cgroup-v1-memory-move-charges:
     +
    - 8. Move charges at task migration (DEPRECATED!)
    - ===============================================
    + 8. Move charges at task migration
    + =================================
      
     @@ Documentation/admin-guide/cgroup-v1/memory.rst: If you want to enable it::
      
10:  895b1f1aa37d33 =  9:  b179c2788f2a36 docs: cgroup-v1: use numbered lists for user interface setup

[1]: https://lore.kernel.org/linux-doc/20221219042209.22898-1-bagasdotme@gmail.com/

Bagas Sanjaya (9):
  docs: cgroup-v1: replace custom note constructs with appropriate
    admonition blocks
  docs: cgroup-v1: wrap remaining admonitions in admonition blocks
  docs: cgroup-v1: use code block for locking order schema
  docs: cgroup-v1: fix footnotes
  docs: cgroup-v1: move hierarchy of accounting caption
  docs: cgroup-v1: use bullet lists for list of stat file tables
  docs: cgroup-v1: make swap extension subsections subsections
  docs: cgroup-v1: add internal cross-references
  docs: cgroup-v1: use numbered lists for user interface setup

 .../admin-guide/cgroup-v1/cgroups.rst         |   2 +
 .../admin-guide/cgroup-v1/memory.rst          | 268 ++++++++++--------
 2 files changed, 146 insertions(+), 124 deletions(-)


base-commit: 21786e5cb375a1e58a9175fee423e1d7f892d965
-- 
An old man doll... just what I always wanted! - Clara


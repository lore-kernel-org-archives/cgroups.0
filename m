From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 0/3] Some cleanups for page isolation
Date: Tue, 14 Feb 2023 11:18:05 +0800
Message-ID: <cover.1676342827.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

The page isolation functions did not return a boolean to indicate
success or not, instead it will return a negative error when failed
to isolate a page. So it's better to check the negative error explicitly
for isolation to make the code more clear per Linus's suggestion in [1].

No functional changes intended in this patch series.

[1] https://lore.kernel.org/all/CAHk-=wiBrY+O-4=2mrbVyxR+hOqfdJ=Do6xoucfJ9_5az01L4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

Baolin Wang (3):
  mm: check negative error of folio_isolate_lru() when failed to isolate
    a folio
  mm: check negative error of isolate_lru_page() when failed to isolate
    a page
  mm: mempolicy: check negative error of isolate_hugetlb() when failed
    to isolate a hugetlb

 mm/damon/paddr.c    | 2 +-
 mm/gup.c            | 2 +-
 mm/khugepaged.c     | 4 ++--
 mm/memcontrol.c     | 2 +-
 mm/mempolicy.c      | 2 +-
 mm/migrate.c        | 4 ++--
 mm/migrate_device.c | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.27.0


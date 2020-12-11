From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 0/7] Convert all THP vmstat counters to pages
Date: Fri, 11 Dec 2020 12:19:47 +0800
Message-ID: <20201211041954.79543-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JadMn18aCnIs/6Vjw45Dh3eAfbEtua6oaOg4kdj6BCQ=;
        b=eCkNBMu8UVMzizfhgKu+N0keqKcYMkDxoJqXSjBAJuVT24Zx4JcNlyj0zk9vCTikLs
         lmzn027hZix4kWPCyIGZc1e46yyFv/eFpJz+1yi15kgG+bSNG+uyewJKh+89avQLygjj
         rQMrtG67rImSPoJJ9pa7mEwIZ4pF1N+8l2eozAfJ5BAejTuj052QDZOo2I0PvwKCgYqx
         OtShU6qB3lCEaj6fqfhCiiYnLMKVF/kLzQV8XXJ/Pmt+NTyUYCgSL4ZHiYXjxhf5hiLY
         41wf3VKfjPgBY/IGXC7MWQBe/DOuf1DDWIrxCUjdMiZHSI3AcnQitgBRtjadqjT0bNko
         W6eg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, samitolvanen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hi,

This patch series is aimed to convert all THP vmstat counters to pages.

The unit of some vmstat counters are pages, some are bytes, some are
HPAGE_PMD_NR, and some are KiB. When we want to expose these vmstat
counters to the userspace, we have to know the unit of the vmstat counters
is which one. When the unit is bytes or kB, both clearly distinguishable
by the B/KB suffix. But for the THP vmstat counters, we may make mistakes.

For example, the below is some bug fix for the THP vmstat counters:

  - 7de2e9f195b9 ("mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg")
  - The first commit in this series ("fix NR_ANON_THPS accounting in charge moving")

This patch series can make the code clear. And make all the unit of the THP
vmstat counters in pages. Finally, the unit of the vmstat counters are
pages, kB and bytes. The B/KB suffix can tell us that the unit is bytes
or kB. The rest which is without suffix are pages.

In this series, I changed the following vmstat counters unit from HPAGE_PMD_NR
to pages. However, there is no change to the print format of output to user
space.

  - NR_ANON_THPS
  - NR_FILE_THPS
  - NR_SHMEM_THPS
  - NR_SHMEM_PMDMAPPED
  - NR_FILE_PMDMAPPED

Although every THP stats update overflows the per-cpu counter, resorting to
atomic global updates.

But this change is consistent with 4.7's 8f182270dfec ("mm/swap.c: flush
lru pvecs on compound page arrival"): we accepted greater overhead for
greater accuracy back then, so I think it's okay to do so for THP stats.
Thanks Hugh for mentioning this.

This was inspired by Johannes and Roman. Thanks to them.

Changes in v3 -> v4:
  - Rename the first commit subject to "mm: memcontrol: fix NR_ANON_THPS
    accounting in charge moving".
  - Fix /proc/vmstat printing. Thanks to Johannes points out that.

Changes in v2 -> v3:
  - Change the series subject from "Convert all vmstat counters to pages or bytes"
    to "Convert all THP vmstat counters to pages".
  - Remove convert of KB to B.

Changes in v1 -> v2:
  - Change the series subject from "Convert all THP vmstat counters to pages"
    to "Convert all vmstat counters to pages or bytes".
  - Convert NR_KERNEL_SCS_KB account to bytes.
  - Convert vmstat slab counters to bytes.
  - Remove {global_}node_page_state_pages.

Muchun Song (7):
  mm: memcontrol: fix NR_ANON_THPS accounting in charge moving
  mm: memcontrol: convert NR_ANON_THPS account to pages
  mm: memcontrol: convert NR_FILE_THPS account to pages
  mm: memcontrol: convert NR_SHMEM_THPS account to pages
  mm: memcontrol: convert NR_SHMEM_PMDMAPPED account to pages
  mm: memcontrol: convert NR_FILE_PMDMAPPED account to pages
  mm: memcontrol: make the slab calculation consistent

 drivers/base/node.c    |  27 +++++-----
 fs/proc/meminfo.c      |  10 ++--
 include/linux/mmzone.h |  13 +++++
 mm/filemap.c           |   4 +-
 mm/huge_memory.c       |   9 ++--
 mm/khugepaged.c        |   4 +-
 mm/memcontrol.c        | 132 +++++++++++++++++++++++--------------------------
 mm/page_alloc.c        |   7 ++-
 mm/rmap.c              |  19 ++++---
 mm/shmem.c             |   3 +-
 mm/vmstat.c            |  11 ++++-
 11 files changed, 130 insertions(+), 109 deletions(-)

-- 
2.11.0


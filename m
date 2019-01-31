From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] fixup: mm: memcontrol: Unbreak memcontrol build when THP is
 disabled
Date: Thu, 31 Jan 2019 11:08:02 -0500
Message-ID: <20190131160802.GA5777@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=UP69wWmTtINd5/Z9K2WlkOH7AzazUM8Nzb3CPcSA8gQ=;
        b=e5XfwYDUxCjfYGxGVHOfo2wOQLLTu8dorggsDA1b94sfaIEhbQOcpTwGBL4wrv8DEB
         6aj6uOANmvjxCC9EDZok7Vk1Bpm49Kn7YW6vHp+em848JQLHEP8P1IkY6Akuwjl/Ke7x
         CEzZnIMsE9w8xVkUDaQEOrC4oaryD1DFRuQ18=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

This can be folded into "mm: memcontrol: Expose THP events on a
per-memcg basis"
(mm-memcontrol-expose-thp-events-on-a-per-memcg-basis.patch).

kbuild points out that this patch can't be built with
CONFIG_TRANSPARENT_HUGEPAGE not set. I had originally worried about
this, but had only checked NR_ANON_THPS (which is not ifdeffed), not the
event counters.

NR_ANON_THPS is not #ifdeffed in node_stat_item, so we don't need to
also guard MEMCG_RSS_HUGE to futureproof it.

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kernel-team@fb.com
---
 Documentation/admin-guide/cgroup-v2.rst | 8 +++++---
 mm/memcontrol.c                         | 2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b6989b39ed8e..53d3288c328b 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1255,12 +1255,14 @@ PAGE_SIZE multiple when read back.
 	  thp_fault_alloc
 
 		Number of transparent hugepages which were allocated to satisfy
-		a page fault, including COW faults
+		a page fault, including COW faults. This counter is not present
+		when CONFIG_TRANSPARENT_HUGEPAGE is not set.
 
 	  thp_collapse_alloc
 
-		Number of transparent hugepages which were allocated to
-		allow collapsing an existing range of pages
+		Number of transparent hugepages which were allocated to allow
+		collapsing an existing range of pages. This counter is not
+		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
 
   memory.swap.current
 	A read-only single value file which exists on non-root
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2f4fe2fb9046..bc4da016b8ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5643,9 +5643,11 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	seq_printf(m, "pglazyfree %lu\n", acc.events[PGLAZYFREE]);
 	seq_printf(m, "pglazyfreed %lu\n", acc.events[PGLAZYFREED]);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	seq_printf(m, "thp_fault_alloc %lu\n", acc.events[THP_FAULT_ALLOC]);
 	seq_printf(m, "thp_collapse_alloc %lu\n",
 		   acc.events[THP_COLLAPSE_ALLOC]);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	return 0;
 }
-- 
2.20.1


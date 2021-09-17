From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH mm] vmalloc: back off when the current task is OOM-killed
Date: Fri, 17 Sep 2021 11:06:49 +0300
Message-ID: <d07a5540-3e07-44ba-1e59-067500f024d9@virtuozzo.com>
References: <YT8PEBbYZhLixEJD@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=vNgx/3n9bi2etAGIYh4+okt/y0F7gydwzwqScVihv4w=; b=iE23CrPuqYwx6L+WuP0
        MSRozyky9urm64czXwWLrNZ/9ayDJS3aSLwMOheJcHJmfyOFUBrdXFadLP1BGBDronLgyS7h3usB1
        piWpEhLqoM1qklkFq3aRzLuG0vmdNKeGMym8Xsi1sQMvfui8ccy6JpnJzOA3VxSbOB8PjqsSCNM=;
In-Reply-To: <YT8PEBbYZhLixEJD-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Huge vmalloc allocation on heavy loaded node can lead to a global
memory shortage. A task called vmalloc can have the worst badness
and be chosen by OOM-killer, however received fatal signal and
oom victim mark does not interrupt allocation cycle. Vmalloc will
continue allocating pages over and over again, exacerbating the crisis
and consuming the memory freed up by another killed tasks.

This patch allows OOM-killer to break vmalloc cycle, makes OOM more
effective and avoid host panic.

Unfortunately it is not 100% safe. Previous attempt to break vmalloc
cycle was reverted by commit b8c8a338f75e ("Revert "vmalloc: back off when
the current task is killed"") due to some vmalloc callers did not handled
failures properly. Found issues was resolved, however, there may
be other similar places.

Such failures may be acceptable for emergencies, such as OOM. On the other
hand, we would like to detect them earlier. However they are quite rare,
and will be hidden by OOM messages, so I'm afraid they wikk have quite
small chance of being noticed and reported.

To improve the detection of such places this patch also interrupts the vmalloc
allocation cycle for all fatal signals. The checks are hidden under DEBUG_VM
config option to do not break unaware production kernels.

Vmalloc uses new alloc_pages_bulk subsystem, so newly added checks can
affect other users of this subsystem.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 mm/page_alloc.c | 5 +++++
 mm/vmalloc.c    | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b37435c274cf..133d52e507ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5288,6 +5288,11 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
+		if (tsk_is_oom_victim(current) ||
+		    (IS_ENABLED(CONFIG_DEBUG_VM) &&
+		     fatal_signal_pending(current)))
+			break;
+
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
 		if (unlikely(!page)) {
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c3b8e3e5cfc5..04b291076726 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -38,6 +38,7 @@
 #include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
+#include <linux/oom.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
@@ -2860,6 +2861,11 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		struct page *page;
 		int i;
 
+		if (tsk_is_oom_victim(current) ||
+		    (IS_ENABLED(CONFIG_DEBUG_VM) &&
+		     fatal_signal_pending(current)))
+			break;
+
 		page = alloc_pages_node(nid, gfp, order);
 		if (unlikely(!page))
 			break;
-- 
2.31.1


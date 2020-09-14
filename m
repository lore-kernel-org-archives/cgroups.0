From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 2/3] mm/memcg: Simplify mem_cgroup_get_max()
Date: Mon, 14 Sep 2020 11:09:28 -0400
Message-ID: <20200914150928.7841-1-longman@redhat.com>
References: <20200914024452.19167-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600096188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=6+JqwjvDWrEa3i/FAJIeAH613qFKBYUmXeFNszVZCpA=;
        b=Ouj/omuOl1248vhafLIetAEkfQJW40Lae1+3OF9wjKo1HH7XitdvoKV9fuBaQ/Xm5a11rY
        BzYvVLz8ls5OLWRqz7ojdgvIch1tKEs7gBeFbrm3BEbSgTqt96NimE13C7V482wGre1pHX
        f8jjNme/ECnr9COmKUDcCumVTGigUgw=
In-Reply-To: <20200914024452.19167-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The mem_cgroup_get_max() function used to get memory+swap max from
both the v1 memsw and v2 memory+swap page counters & return the maximum
of these 2 values. This is redundant and it is more efficient to just
get either the v1 or the v2 values depending on which one is currently
in use.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8c74f1200261..cad1ac4551ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1633,17 +1633,19 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
  */
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 {
-	unsigned long max;
-
-	max = READ_ONCE(memcg->memory.max);
-	if (mem_cgroup_swappiness(memcg)) {
-		unsigned long memsw_max;
-		unsigned long swap_max;
-
-		memsw_max = memcg->memsw.max;
-		swap_max = READ_ONCE(memcg->swap.max);
-		swap_max = min(swap_max, (unsigned long)total_swap_pages);
-		max = min(max + swap_max, memsw_max);
+	unsigned long max = READ_ONCE(memcg->memory.max);
+
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		if (mem_cgroup_swappiness(memcg))
+			max += min(READ_ONCE(memcg->swap.max),
+				   (unsigned long)total_swap_pages);
+	} else { /* v1 */
+		if (mem_cgroup_swappiness(memcg)) {
+			/* Calculate swap excess capacity from memsw limit */
+			unsigned long swap = READ_ONCE(memcg->memsw.max) - max;
+
+			max += min(swap, (unsigned long)total_swap_pages);
+		}
 	}
 	return max;
 }
-- 
2.18.1


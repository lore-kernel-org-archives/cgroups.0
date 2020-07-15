From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch] mm, memcg: provide a stat to describe reclaimable memory
Date: Tue, 14 Jul 2020 20:18:52 -0700 (PDT)
Message-ID: <alpine.DEB.2.23.453.2007142018150.2667860@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=msyTwNMWxPuFJXiWs5O0lYGKZpuyME2C9XStVaZzeTU=;
        b=KJdT54GXo7EEU/QR4u7uq62UiYdr9gxzmi0ZURm9A0MTeNUw3zq+2pui1mR3K0t1M/
         WUKYhb7JWjwhW+5QC6pwKbqRh96pnLKJWcl+Fe4Hiwjo+ldU+/Eo6O4RcZgZ6ESKJwXt
         Twjcj5jJy+7hqpX2ysrYTUPuRP8AAj59Ru24wZCOIauOq1NiCfosqhvt4/ahwDTEz5C+
         oJsMN8EKywZZ56O6YYRQHRXkRutlGELSEcHXrmSc86ShTCKX1MXwc4prD99KiZWm5edE
         CLplwcmpvwvsF4yyq3o2L6vA+QIYQXRqh7hRD3zHaRrvmIPw5hD9aJy2F6bRrpXzz30G
         KKcw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

MemAvailable in /proc/meminfo provides some guidance on the amount of
memory that can be made available for starting new applications (see
Documentation/filesystems/proc.rst).

Userspace can lack insight into the amount of memory that can be reclaimed
from a memcg based on values from memory.stat, however.  Two specific
examples:

 - Lazy freeable memory (MADV_FREE) that are clean anonymous pages on the
   inactive file LRU that can be quickly reclaimed under memory pressure
   but otherwise shows up as mapped anon in memory.stat, and

 - Memory on deferred split queues (thp) that are compound pages that can
   be split and uncharged from the memcg under memory pressure, but
   otherwise shows up as charged anon LRU memory in memory.stat.

Userspace can currently derive this information and use the same heuristic
as MemAvailable by doing this:

	deferred = (active_anon + inactive_anon) - anon
	lazyfree = (active_file + inactive_file) - file

	avail = deferred + lazyfree + (file + slab_reclaimable) / 2

But this depends on implementation details for how this memory is handled
in the kernel for the purposes of reclaim (anon on inactive file LRU or
unmapped anon on the LRU).

For the purposes of writing portable userspace code that does not need to
have insight into the kernel implementation for reclaimable memory, this
exports a metric that can provide an estimate of the amount of memory that
can be reclaimed and uncharged from the memcg to start new applications.

As the kernel implementation evolves for memory that can be reclaimed
under memory pressure, this metric can be kept consistent.

Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 12 +++++++++
 mm/memcontrol.c                         | 35 +++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1314,6 +1314,18 @@ PAGE_SIZE multiple when read back.
 		Part of "slab" that cannot be reclaimed on memory
 		pressure.
 
+	  avail
+		An estimate of how much memory can be made available for
+		starting new applications, similar to MemAvailable from
+		/proc/meminfo (Documentation/filesystems/proc.rst).
+
+		This is derived by assuming that half of page cahce and
+		reclaimable slab can be uncharged without significantly
+		impacting the workload, similar to MemAvailable.  It also
+		factors in the amount of lazy freeable memory (MADV_FREE) and
+		compound pages that can be split and uncharged under memory
+		pressure.
+
 	  pgfault
 		Total number of page faults incurred
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1350,6 +1350,35 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
 	return false;
 }
 
+/*
+ * Returns an estimate of the amount of available memory that can be reclaimed
+ * for a memcg, in pages.
+ */
+static unsigned long mem_cgroup_avail(struct mem_cgroup *memcg)
+{
+	long deferred, lazyfree;
+
+	/*
+	 * Deferred pages are charged anonymous pages that are on the LRU but
+	 * are unmapped.  These compound pages are split under memory pressure.
+	 */
+	deferred = max_t(long, memcg_page_state(memcg, NR_ACTIVE_ANON) +
+			       memcg_page_state(memcg, NR_INACTIVE_ANON) -
+			       memcg_page_state(memcg, NR_ANON_MAPPED), 0);
+	/*
+	 * Lazyfree pages are charged clean anonymous pages that are on the file
+	 * LRU and can be reclaimed under memory pressure.
+	 */
+	lazyfree = max_t(long, memcg_page_state(memcg, NR_ACTIVE_FILE) +
+			       memcg_page_state(memcg, NR_INACTIVE_FILE) -
+			       memcg_page_state(memcg, NR_FILE_PAGES), 0);
+
+	/* Using same heuristic as si_mem_available() */
+	return (unsigned long)deferred + (unsigned long)lazyfree +
+	       (memcg_page_state(memcg, NR_FILE_PAGES) +
+		memcg_page_state(memcg, NR_SLAB_RECLAIMABLE)) / 2;
+}
+
 static char *memory_stat_format(struct mem_cgroup *memcg)
 {
 	struct seq_buf s;
@@ -1417,6 +1446,12 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 	seq_buf_printf(&s, "slab_unreclaimable %llu\n",
 		       (u64)memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE) *
 		       PAGE_SIZE);
+	/*
+	 * All values in this buffer are read individually, no implied
+	 * consistency amongst them.
+	 */
+	seq_buf_printf(&s, "avail %llu\n",
+		       (u64)mem_cgroup_avail(memcg) * PAGE_SIZE);
 
 	/* Accumulated memory events */
 

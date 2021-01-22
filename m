From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] Revert "mm: memcontrol: avoid workload stalls when lowering memory.high"
Date: Fri, 22 Jan 2021 13:43:41 -0500
Message-ID: <20210122184341.292461-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C9fNjhrnoyOFnHJ9WQ+/Ta+coPGgxGkP5OqAw7eb4FE=;
        b=jZfX+8gSvsMknjij2NXiIkewNvE/gS0U3cVGRcyPmCqSxmENCBZB94bg9qNEDpz1/6
         EraLaqdwbEc4JCtd9r5PpiJZrDTX7sq3ubzrQkZDk37siT5lhYY+2d86mkxF/54wMn6I
         FFW2rpjqkRxx58b4cmvX5LghbDFYl6D9T1qiLQIrf9H0/Bm4zCQjT3lPd29XyUUTsyWW
         JErij86cT0276L6OHd2ics2wWE8glvLdLu7uHZiKNM6MBGiI+DCKpcAUKMGjRuiCo+tE
         5IOV2/n++vOYBzOW3Dja7cVPBGgJKROdI78/O8suUL/c0aHEqbgDjxPMVcUaAYd1rEuH
         YIHw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

This reverts commit 536d3bf261a2fc3b05b3e91e7eef7383443015cf, as it
can cause writers to memory.high to get stuck in the kernel forever,
performing page reclaim and consuming excessive amounts of CPU cycles.

Before the patch, a write to memory.high would first put the new limit
in place for the workload, and then reclaim the requested delta. After
the patch, the kernel tries to reclaim the delta before putting the
new limit into place, in order to not overwhelm the workload with a
sudden, large excess over the limit. However, if reclaim is actively
racing with new allocations from the uncurbed workload, it can keep
the write() working inside the kernel indefinitely.

This is causing problems in Facebook production. A privileged
system-level daemon that adjusts memory.high for various workloads
running on a host can get unexpectedly stuck in the kernel and
essentially turn into a sort of involuntary kswapd for one of the
workloads. We've observed that daemon busy-spin in a write() for
minutes at a time, neglecting its other duties on the system, and
expending privileged system resources on behalf of a workload.

To remedy this, we have first considered changing the reclaim logic to
break out after a couple of loops - whether the workload has converged
to the new limit or not - and bound the write() call this way.
However, the root cause that inspired the sequence change in the first
place has been fixed through other means, and so a revert back to the
proven limit-setting sequence, also used by memory.max, is preferable.

The sequence was changed to avoid extreme latencies in the workload
when the limit was lowered: the sudden, large excess created by the
limit lowering would erroneously trigger the penalty sleeping code
that is meant to throttle excessive growth from below. Allocating
threads could end up sleeping long after the write() had already
reclaimed the delta for which they were being punished.

However, erroneous throttling also caused problems in other scenarios
at around the same time. This resulted in commit b3ff92916af3 ("mm,
memcg: reclaim more aggressively before high allocator throttling"),
included in the same release as the offending commit. When allocating
threads now encounter large excess caused by a racing write() to
memory.high, instead of entering punitive sleeps, they will simply be
tasked with helping reclaim down the excess, and will be held no
longer than it takes to accomplish that. This is in line with regular
limit enforcement - i.e. if the workload allocates up against or over
an otherwise unchanged limit from below.

With the patch breaking userspace, and the root cause addressed by
other means already, revert it again.

Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 5.8+
Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Andrew, this is a replacement for
mm-memcontrol-prevent-starvation-when-writing-memoryhigh.patch

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 605f671203ef..a8611a62bafd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6273,6 +6273,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 	if (err)
 		return err;
 
+	page_counter_set_high(&memcg->memory, high);
+
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
@@ -6296,10 +6298,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 			break;
 	}
 
-	page_counter_set_high(&memcg->memory, high);
-
 	memcg_wb_domain_size_changed(memcg);
-
 	return nbytes;
 }
 
-- 
2.30.0

